import 'package:flutter/material.dart';

class DiaryModalCard extends StatelessWidget {
  const DiaryModalCard({super.key});

  @override
  Widget build(BuildContext context) {
    const tagList = [
      "해시태그1",
      "해시태그2",
      "해시태그3",
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: const Image(
            image: AssetImage('assets/images/test/test_image_000.jpg'),
            width: 320,
            height: 180,
            fit: BoxFit.fitWidth,
            alignment: Alignment.center,
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Row(
          children: [
            for (var tag in tagList)
              Row(
                children: [
                  Text(
                    "#$tag",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    width: 6,
                  ),
                ],
              ),
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        const Row(
          children: [
            Icon(
              Icons.location_on_outlined,
              size: 32,
            ),
            Text(
              "마포 오랑",
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ],
    );
  }
}
