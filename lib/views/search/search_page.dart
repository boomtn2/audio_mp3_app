import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../home/widgets/item_playlist.dart';
import 'search_controller.dart';

class SearchPage extends StatelessWidget {
  SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("TÌM KIẾM TRUYỆN"),
      ),
      body: Obx(
        () => ListView(
          children: [
            Padding(
              padding: EdgeInsets.all(8),
              child: TextFormField(
                controller:
                    Get.find<SearchPageController>().textEditingController,
                decoration: InputDecoration(
                  hintText: 'Nhập tên truyện / Tên Tác giả',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
            ),
            Container(
                height: 260,
                width: MediaQuery.sizeOf(context).width,
                child: GridViewCheckbox()),
            ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
                ),
                onPressed: () {
                  Get.find<SearchPageController>().search();
                  FocusScope.of(context).unfocus();
                },
                child: Text(
                  "Tìm Kiếm",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                )),
            Column(
              mainAxisSize: MainAxisSize.max,
              children: Get.find<SearchPageController>()
                  .data
                  .map((element) => Card(
                      color: Colors.black,
                      child: ItemPlaylist(
                        audio: element,
                        isHideImg: false,
                      )))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class GridViewCheckbox extends StatelessWidget {
  List<String> items = [
    'Huyền Học',
    'Quân Hôn',
    'Ngọt Sủng',
    'Nữ Cường',
    'Dưỡng Oa',
    'Làm Ruộng',
    'Không Gian',
    'Hệ Thống',
  ];

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SearchPageController>();
    return GridView.builder(
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3, // Điều chỉnh tỉ lệ khung hình của mỗi ô
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            controller.selectedItems[items[index]] =
                !(controller.selectedItems[items[index]] ?? false);
          },
          child: Obx(
            () => Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(items[index]),
                    Checkbox(
                      value: controller.selectedItems[items[index]] ?? false,
                      onChanged: (value) {
                        controller.selectedItems[items[index]] = value!;
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
