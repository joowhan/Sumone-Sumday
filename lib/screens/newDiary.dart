import 'package:flutter/material.dart';
import 'package:sumday/screens/ai_writeDiary.dart';
import 'package:sumday/screens/writeDiary.dart';

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
            const Text(
              "AI와 일기를 작성할까요?",
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Ai_WriteDiary(pageIndex: 0,dataList: [],)),
                );
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepOrange,
                  minimumSize: const Size(300, 100)),
              label: const Text('AI와 일기 작성'),
              icon: const Icon(Icons.comment_bank_rounded),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const WriteDiary()),
                );
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  minimumSize: const Size(300, 100)),
              label: const Text('스스로 일기 작성'),
              icon: const Icon(Icons.comment_bank_rounded),
            ),
            // ratio >= 1 ? twoBoxedContainer() : oneBoxedContainer()
          ],
        );
      },
    );
  }
}
