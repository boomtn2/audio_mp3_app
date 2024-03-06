class Audio {
  String date;
  String title;
  String author;
  String description;
  String imageUrl;
  String link;
  String txtLink;
  String audioLink;
  int views;
  int slTap; //sl tap
  String id; //id
  String theLoai;
  Audio({
    required this.date,
    required this.title,
    required this.author,
    required this.description,
    required this.imageUrl,
    required this.link,
    required this.txtLink,
    required this.audioLink,
    required this.views,
    required this.slTap,
    required this.id,
    required this.theLoai,
  });

  factory Audio.toJson(Map<String, String> row) => Audio(
        date: row['Ngày'] ?? "",
        title: row['Tên Truyện'] ?? "",
        author: row['Tác Giả'] ?? "",
        description: row['Mô Tả'] ?? "",
        imageUrl: row['Hình ảnh'] ?? "",
        link: row['Link truyện'] ?? "",
        txtLink: row['Link truyện txt'] ?? "",
        audioLink: row['Link audio'] ?? "",
        views: int.tryParse(row['Lượt Xem'] ?? "0") ?? 0,
        slTap: int.tryParse(row['Lượt Like'] ?? "0") ?? 0,
        id: row['Lượt DisLike'] ?? "",
        theLoai: row['Thể loại'] ?? "",
      );

  factory Audio.none() {
    return Audio(
        date: "",
        title: "",
        author: "",
        description: "",
        imageUrl: "",
        link: "",
        txtLink: "",
        audioLink: "",
        views: 0,
        slTap: 0,
        id: "",
        theLoai: "");
  }

  List<String> paths() {
    List<String> listAudio = [audioLink];

    // /text5.mp3
    String result = extractPath(audioLink);

    // [5,text,.mp3]
    List<String> result2 = extractNumberAndPath(result);

    //link dan xoa duoi file /text5.mp3
    String url = audioLink.replaceAll(result, "");
    int number = int.parse("${result2[0]}");
    if (number != -1) {
      for (int i = number + 1; i <= (number + slTap - 1); ++i) {
        // url/text${i}.mp3
        listAudio.add("${url}${result2[1]}${i}${result2[2]}");
        print("${url}${result2[1]}${i}${result2[2]}");
      }
    }

    return listAudio;
  }

  String extractPath(String url) {
    // Tìm vị trí của dấu gạch chéo cuối cùng trong chuỗi
    int lastIndex = url.lastIndexOf('/');

    // Kiểm tra xem có phải là URL hợp lệ không
    if (lastIndex != -1 && url.startsWith("https://")) {
      // Trả về phần cuối của chuỗi từ vị trí sau "https://"
      return url.substring(lastIndex);
    } else {
      // Trả về chuỗi rỗng nếu không phải là URL hợp lệ
      return "";
    }
  }

  List<String> extractNumberAndPath(String path) {
    // Tìm vị trí của chữ số trong chuỗi
    int digitIndex = path.indexOf(RegExp(r'\d'));

    // Kiểm tra xem có chữ số hay không
    if (digitIndex != -1) {
      // Lấy số từ chuỗi
      String number = path[digitIndex];

      // Tách đường dẫn và phần mở rộng
      String pathWithoutNumber = path.substring(0, digitIndex);
      String extension = path.substring(digitIndex + 1);

      return [number, pathWithoutNumber, extension];
    } else {
      // Trả về danh sách rỗng nếu không tìm thấy chữ số
      return ["-1", "-1", "-1"];
    }
  }
}
