// This example demonstrates how to play a playlist with a mix of URI and asset
// audio sources, and the ability to add/remove/reorder playlist items.
//
// To run:
//
// flutter run -t lib/example_playlist.dart

import 'package:get/get.dart' as useGet;

import '../../models/favorite_audio.dart';
import '/data/local/hive_services.dart';
import '/models/time_line.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';

import 'package:rxdart/rxdart.dart';

import '../../models/audio.dart';
import '../../utils/common.dart';

class PlayListPage extends StatefulWidget {
  PlayListPage({Key? key, required this.audio}) : super(key: key);
  final Audio audio;
  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<PlayListPage> with WidgetsBindingObserver {
  late AudioPlayer _player;
  final _playlist = ConcatenatingAudioSource(children: []);

  final _scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
  useGet.RxBool isFavorite = false.obs;
  void addPlayList() {
    final _audio = widget.audio;
    final _paths = _audio.paths();
    for (int i = 0; i < _paths.length; ++i) {
      _playlist.add(
        ClippingAudioSource(
          child: AudioSource.uri(Uri.parse(_paths[i])),
          tag: AudioMetadata(
            album: _audio.title,
            title: "Tập ${i + 1}",
            artwork: _audio.imageUrl,
          ),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    ambiguate(WidgetsBinding.instance)!.addObserver(this);
    addPlayList();
    _player = AudioPlayer();

    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.black,
    ));
    _init();
    isFavorite.value = !sateFavorite();
  }

  void showDialog() {
    var tl = HiveServices.getTimeLine(id: widget.audio.id);
    if (tl != null) {
      final temp = TimeLine.json(tl);
      useGet.Get.defaultDialog(
          title: 'Thông báo',
          onConfirm: () {
            useGet.Get.back();
            _player.seek(temp.parseTimeString(), index: temp.index);
          },
          onCancel: () {},
          middleText:
              "Bạn Đã từng nghe Bộ Truyện này bạn có muốn tiếp tục nghe tiếp.");
    }
  }

  bool sateFavorite() {
    return HiveServices.isDuplicateAudio(id: widget.audio.id);
  }

  void addFavorite() {
    bool isDuplicateAudio = sateFavorite();
    if (isDuplicateAudio) {
      HiveServices.addFavoriteAudio(
          audio: FavoriteAudio(id: widget.audio.id, tile: widget.audio.title));
    } else {
      HiveServices.removeAudio(id: widget.audio.id);
    }
  }

  Future<void> _init() async {
    // final session = await AudioSession.instance;
    // await session.configure(const AudioSessionConfiguration.speech());
    // // Listen to errors during playback.
    _player.playbackEventStream.listen((event) {},
        onError: (Object e, StackTrace stackTrace) {
      print('A stream error occurred: $e');
    });
    try {
      // Preloading audio is not currently supported on Linux.
      await _player.setAudioSource(_playlist,
          preload: kIsWeb || defaultTargetPlatform != TargetPlatform.linux);
      WidgetsBinding.instance!.addPostFrameCallback((_) {
        showDialog();
      });
    } catch (e) {
      // Catch load errors: 404, invalid url...
      print("Error loading audio source: $e");
    }
    // Show a snackbar whenever reaching the end of an item in the playlist.
    _player.positionDiscontinuityStream.listen((discontinuity) {
      if (discontinuity.reason == PositionDiscontinuityReason.autoAdvance) {
        _showItemFinished(discontinuity.previousEvent.currentIndex);
      }
    });
    _player.processingStateStream.listen((state) {
      if (state == ProcessingState.completed) {
        _showItemFinished(_player.currentIndex);
      }
    });
  }

  void _showItemFinished(int? index) {
    if (index == null) return;
    final sequence = _player.sequence;
    if (sequence == null) return;
    final source = sequence[index];
    final metadata = source.tag as AudioMetadata;
    _scaffoldMessengerKey.currentState?.showSnackBar(SnackBar(
      content: Text('Finished playing ${metadata.title}'),
      duration: const Duration(seconds: 1),
    ));
  }

  @override
  void dispose() {
    ambiguate(WidgetsBinding.instance)!.removeObserver(this);

    HiveServices.addTimeLine(
        timeLine: TimeLine(
            id: widget.audio.id,
            tile: widget.audio.title,
            time: _player.position.toString(),
            index: _player.currentIndex ?? 0,
            ngay: DateTime.now().toString()));
    _player.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      // Release the player's resources when not in use. We use "stop" so that
      // if the app resumes later, it will still remember what position to
      // resume from.
      _player.stop();
    }
  }

  Stream<PositionData> get _positionDataStream =>
      Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
          _player.positionStream,
          _player.bufferedPositionStream,
          _player.durationStream,
          (position, bufferedPosition, duration) => PositionData(
              position, bufferedPosition, duration ?? Duration.zero));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Audio"),
        actions: [
          useGet.Obx(() => InkWell(
                onTap: () {
                  addFavorite();
                  isFavorite.value = !isFavorite.value;
                },
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Text(
                          isFavorite.value ? "Bỏ theo dõi" : "Theo dõi",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Icon(
                          Icons.favorite,
                          color: isFavorite.value ? Colors.red : Colors.black,
                        ),
                      ],
                    ),
                  ),
                ),
              )),
        ],
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: StreamBuilder<SequenceState?>(
                stream: _player.sequenceStateStream,
                builder: (context, snapshot) {
                  final state = snapshot.data;
                  if (state?.sequence.isEmpty ?? true) {
                    return const SizedBox();
                  }
                  final metadata = state!.currentSource!.tag as AudioMetadata;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(child: Image.network(metadata.artwork)),
                        ),
                      ),
                      Text(metadata.album,
                          style: Theme.of(context).textTheme.titleLarge),
                      Text(metadata.title),
                    ],
                  );
                },
              ),
            ),
            ControlButtons(_player),
            StreamBuilder<PositionData>(
              stream: _positionDataStream,
              builder: (context, snapshot) {
                final positionData = snapshot.data;
                return SeekBar(
                  duration: positionData?.duration ?? Duration.zero,
                  position: positionData?.position ?? Duration.zero,
                  bufferedPosition:
                      positionData?.bufferedPosition ?? Duration.zero,
                  onChangeEnd: (newPosition) {
                    _player.seek(newPosition);
                  },
                );
              },
            ),
            const SizedBox(height: 8.0),
            Row(
              children: [
                StreamBuilder<LoopMode>(
                  stream: _player.loopModeStream,
                  builder: (context, snapshot) {
                    final loopMode = snapshot.data ?? LoopMode.off;
                    const icons = [
                      Icon(Icons.repeat, color: Colors.grey),
                      Icon(Icons.repeat, color: Colors.orange),
                      Icon(Icons.repeat_one, color: Colors.orange),
                    ];
                    const cycleModes = [
                      LoopMode.off,
                      LoopMode.all,
                      LoopMode.one,
                    ];
                    final index = cycleModes.indexOf(loopMode);
                    return IconButton(
                      icon: icons[index],
                      onPressed: () {
                        _player.setLoopMode(cycleModes[
                            (cycleModes.indexOf(loopMode) + 1) %
                                cycleModes.length]);
                      },
                    );
                  },
                ),
                Expanded(
                  child: Text(
                    "Danh Sách Tập",
                    style: Theme.of(context).textTheme.titleLarge,
                    textAlign: TextAlign.center,
                  ),
                ),
                StreamBuilder<bool>(
                  stream: _player.shuffleModeEnabledStream,
                  builder: (context, snapshot) {
                    final shuffleModeEnabled = snapshot.data ?? false;
                    return IconButton(
                      icon: shuffleModeEnabled
                          ? const Icon(Icons.shuffle, color: Colors.orange)
                          : const Icon(Icons.shuffle, color: Colors.grey),
                      onPressed: () async {
                        final enable = !shuffleModeEnabled;
                        if (enable) {
                          await _player.shuffle();
                        }
                        await _player.setShuffleModeEnabled(enable);
                      },
                    );
                  },
                ),
              ],
            ),
            SizedBox(
              height: 240.0,
              child: StreamBuilder<SequenceState?>(
                stream: _player.sequenceStateStream,
                builder: (context, snapshot) {
                  final state = snapshot.data;
                  final sequence = state?.sequence ?? [];
                  return ReorderableListView(
                    onReorder: (int oldIndex, int newIndex) {
                      if (oldIndex < newIndex) newIndex--;
                      _playlist.move(oldIndex, newIndex);
                    },
                    children: [
                      for (var i = 0; i < sequence.length; i++)
                        Dismissible(
                          key: ValueKey(sequence[i]),
                          background: Container(
                            color: Colors.redAccent,
                            alignment: Alignment.centerRight,
                            child: const Padding(
                              padding: EdgeInsets.only(right: 8.0),
                              child: Icon(Icons.delete, color: Colors.white),
                            ),
                          ),
                          onDismissed: (dismissDirection) {
                            _playlist.removeAt(i);
                          },
                          child: Material(
                            color: i == state!.currentIndex
                                ? Colors.grey.shade300
                                : null,
                            child: ListTile(
                              title: Text(sequence[i].tag.title as String),
                              onTap: () {
                                _player.seek(Duration.zero, index: i);
                              },
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ControlButtons extends StatelessWidget {
  final AudioPlayer player;

  const ControlButtons(this.player, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: const Icon(Icons.volume_up),
          onPressed: () {
            showSliderDialog(
              context: context,
              title: "Điều Chỉnh Âm Lượng",
              divisions: 10,
              min: 0.0,
              max: 1.0,
              value: player.volume,
              stream: player.volumeStream,
              onChanged: player.setVolume,
            );
          },
        ),
        StreamBuilder<SequenceState?>(
          stream: player.sequenceStateStream,
          builder: (context, snapshot) => IconButton(
            icon: const Icon(Icons.skip_previous),
            onPressed: player.hasPrevious ? player.seekToPrevious : null,
          ),
        ),
        StreamBuilder<PlayerState>(
          stream: player.playerStateStream,
          builder: (context, snapshot) {
            final playerState = snapshot.data;
            final processingState = playerState?.processingState;
            final playing = playerState?.playing;
            if (processingState == ProcessingState.loading ||
                processingState == ProcessingState.buffering) {
              return Container(
                margin: const EdgeInsets.all(8.0),
                width: 64.0,
                height: 64.0,
                child: const CircularProgressIndicator(),
              );
            } else if (playing != true) {
              return IconButton(
                icon: const Icon(Icons.play_arrow),
                iconSize: 64.0,
                onPressed: player.play,
              );
            } else if (processingState != ProcessingState.completed) {
              return IconButton(
                icon: const Icon(Icons.pause),
                iconSize: 64.0,
                onPressed: player.pause,
              );
            } else {
              return IconButton(
                icon: const Icon(Icons.replay),
                iconSize: 64.0,
                onPressed: () => player.seek(Duration.zero,
                    index: player.effectiveIndices!.first),
              );
            }
          },
        ),
        StreamBuilder<SequenceState?>(
          stream: player.sequenceStateStream,
          builder: (context, snapshot) => IconButton(
            icon: const Icon(Icons.skip_next),
            onPressed: player.hasNext ? player.seekToNext : null,
          ),
        ),
        StreamBuilder<double>(
          stream: player.speedStream,
          builder: (context, snapshot) => InkWell(
            child: Card(
              color: Colors.pink,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("Tốc Độ"),
                    Text("${snapshot.data?.toStringAsFixed(1)}x",
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
            onTap: () {
              showSliderDialog(
                context: context,
                title: "Tốc Độ Đọc",
                divisions: 10,
                min: 0.5,
                max: 3,
                value: player.speed,
                stream: player.speedStream,
                onChanged: player.setSpeed,
              );
            },
          ),
        ),
      ],
    );
  }
}

class AudioMetadata {
  final String album;
  final String title;
  final String artwork;

  AudioMetadata({
    required this.album,
    required this.title,
    required this.artwork,
  });
}
