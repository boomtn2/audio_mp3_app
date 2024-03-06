import '/models/favorite_audio.dart';
import '/models/time_line.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

import '../../models/author.dart';

class HiveServices {
  HiveServices._();
  static const String _boxFavoriteAudio = "favorite_audio_app";
  static const String _boxFavoriteAuthor = "favorite_athur_audio_app";
  static const String _boxTimeLine = "timeline_audio_app";

  static late final Box hiveBoxAuthor;
  static late final Box hiveBoxFavoriteAudio;
  static late final Box hiveBoxTimeLine;

  static final RxList<FavoriteAudio> favoriteAudio = <FavoriteAudio>[].obs;
  static final RxList<FavoriteAuthor> favoriteAuthor = <FavoriteAuthor>[].obs;

  static Future init() async {
    final appDocumentDirectory =
        await path_provider.getApplicationDocumentsDirectory();
    Hive.init(appDocumentDirectory.path);
    hiveBoxAuthor = await Hive.openBox(_boxFavoriteAuthor);
    hiveBoxFavoriteAudio = await Hive.openBox(_boxFavoriteAudio);
    hiveBoxTimeLine = await Hive.openBox(_boxTimeLine);
  }

  static addTimeLine({required TimeLine timeLine}) async {
    if (hiveBoxTimeLine.get(timeLine.id) != null) {
      hiveBoxTimeLine.delete(timeLine.id);
    }

    await hiveBoxTimeLine.put(timeLine.id, timeLine.toMap());
  }

  static addFavoriteAudio({required FavoriteAudio audio}) async {
    await hiveBoxFavoriteAudio.put(audio.id, audio.tile);
    getData();
  }

  static addFavoriteAuthor({required FavoriteAuthor author}) async {
    await hiveBoxAuthor.put(author.author, author.author);
    getData();
  }

  static removeTimeLine({required String key}) async {
    await hiveBoxTimeLine.delete(key);
  }

  static removeAudio({required String id}) async {
    await hiveBoxFavoriteAudio.delete(id);
    getData();
  }

  static removeAuthor({required String author}) async {
    await hiveBoxAuthor.delete(author);
    getData();
  }

  static bool isDuplicateAudio({required String id}) {
    if (hiveBoxFavoriteAudio.get(id) != null) {
      return false;
    }
    return true;
  }

  static isDuplicateAuthor({required String author}) {
    if (hiveBoxAuthor.get(author) != null) {
      return false;
    }
    return true;
  }

  static getData() {
    deleteAll();
    hiveBoxFavoriteAudio.toMap().forEach((key, value) {
      favoriteAudio.add(FavoriteAudio(id: key, tile: value));
    });
    hiveBoxAuthor.toMap().forEach((key, value) {
      favoriteAuthor.add(FavoriteAuthor(author: key));
    });
  }

  static Map<dynamic, dynamic> getDataTimeLine() {
    return hiveBoxTimeLine.toMap();
  }

  static Map<dynamic, dynamic>? getTimeLine({required String id}) {
    return hiveBoxTimeLine.get(id);
  }

  static void deleteAll() {
    favoriteAudio.removeRange(0, favoriteAudio.length);
    favoriteAuthor.removeRange(0, favoriteAuthor.length);
  }
}
