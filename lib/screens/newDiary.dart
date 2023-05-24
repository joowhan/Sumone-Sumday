import 'package:flutter/material.dart';
class NewDiary extends StatelessWidget {
  const NewDiary({Key? key}) : super(key: key);
  Widget oneBoxedContainer() {
    return Container(
      color: Colors.red,
      width: 100,
      height: 100,
    );
  }

  Widget twoBoxedContainer() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          color: Colors.red,
          width: 100,
          height: 100,
        ),
        Container(
          color: Colors.blue,
          width: 100,
          height: 100,
        ),
      ],
    );
  }
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final width = constraints.maxWidth;
        final height = constraints.maxHeight;
        final ratio = width / height;
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "width: $width\nheight: $height\naspect ratio: $ratio",
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              height: 300,
              width: 300 * ratio,
              color: Colors.blueGrey[100],
            ),
            SizedBox(
              height: 20,
            ),
            ratio >= 1 ? twoBoxedContainer() : oneBoxedContainer()
          ],
        );
      },

    );
  }
}
