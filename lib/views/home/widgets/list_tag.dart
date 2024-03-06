import 'package:flutter/material.dart';

class ListTag extends StatefulWidget {
  const ListTag({super.key});

  @override
  State<ListTag> createState() => _ListTagState();
}

class _ListTagState extends State<ListTag> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: [
          itemTag(nameTag: "Tất cả", choose: true),
          itemTag(nameTag: "Ngôn Tình", choose: false),
          itemTag(nameTag: "Quân Văn", choose: false),
        ],
      ),
    );
  }

  Widget itemTag({required String nameTag, required bool choose}) {
    return Padding(
      padding: EdgeInsets.only(right: 10),
      child: Container(
        height: 35,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(9)),
            color: choose ? Colors.white : Color.fromARGB(107, 181, 177, 177)),
        child: Padding(
          padding: EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
          child: Text(
            nameTag,
            style: TextStyle(
                color: choose ? Colors.black : Colors.white,
                fontSize: 15,
                fontFamily: "Roboto"),
          ),
        ),
      ),
    );
  }
}
