import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ErrorNetWork extends StatelessWidget {
  const ErrorNetWork({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Không Có Mạng! Bạn Vui Lòng Kiểm tra lại kết nối mạng!"),
            Text("Tắt ứng dụng và vào lại nếu chắc chắn có mạng"),
          ],
        ),
      ),
    );
  }
}
