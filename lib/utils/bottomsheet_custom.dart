import 'package:flutter/material.dart';

Widget bottomSheetCustom(
    {required Function saveFavorite,
    required Function follow,
    required Function error,
    required Function download,
    bool isAddAudio = true,
    bool isAddAuthor = true}) {
  return Card(
    color: Colors.black,
    child: SizedBox(
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
              leading: Icon(
                Icons.favorite,
                color: isAddAudio ? Colors.white : Colors.red,
              ),
              title: Text(
                isAddAudio
                    ? 'Lưu vào danh sách Yêu Thích'
                    : 'Xóa khỏi danh sách yêu thích',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                saveFavorite();
              }),
          Divider(
            color: const Color.fromARGB(255, 87, 77, 77),
          ),
          ListTile(
            leading: Icon(
              Icons.person,
              color: isAddAuthor ? Colors.green : Colors.red,
            ),
            title: Text(
              isAddAuthor ? 'Theo Dõi Tác Giả' : 'Bỏ theo dõi tác giả',
              style: TextStyle(color: Colors.white),
            ),
            onTap: () {
              follow();
            },
          ),
          Divider(
            color: const Color.fromARGB(255, 87, 77, 77),
          ),
          ListTile(
              leading: Icon(Icons.error),
              title: Text('Báo Lỗi'),
              onTap: () {
                error();
              }),
          Divider(
            color: const Color.fromARGB(255, 87, 77, 77),
          ),
          ListTile(
            leading: Icon(Icons.download),
            title: Text('Tải về'),
            onTap: () {
              download();
            },
          ),
        ],
      ),
    ),
  );
}
