import 'package:hive/hive.dart';

class TimeLine {
  String id;
  String tile;
  String time;
  int index;
  String ngay;
  TimeLine(
      {required this.id,
      required this.tile,
      required this.time,
      required this.index,
      required this.ngay});

  factory TimeLine.json(Map<dynamic, dynamic> json) {
    return TimeLine(
        id: json['id'],
        tile: json['tile'],
        time: json['time'],
        index: json['index'],
        ngay: json['ngay']);
  }
  Map<String, dynamic> toMap() {
    return {"id": id, "tile": tile, "time": time, "index": index, "ngay": ngay};
  }

  Duration parseTimeString() {
    List<String> parts = time.split(":");
    int hours = int.parse(parts[0]);
    int minutes = int.parse(parts[1]);
    double seconds = double.parse(parts[2]);

    int milliseconds = (seconds * 1000).round();
    seconds = seconds % 1;

    return Duration(
      hours: hours,
      minutes: minutes,
      seconds: seconds.toInt(),
      milliseconds: milliseconds,
    );
  }

  DateTime getDateTime() {
    return DateTime.tryParse(ngay) ?? DateTime(2024);
  }

  String get ngayThangNam {
    return "${getDateTime().day}/${getDateTime().month}/${getDateTime().year}";
  }
}
