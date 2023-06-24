import 'package:flutter/material.dart';

class DiaryModalCard extends StatelessWidget {
  final List<String> tags;
  final String location;
  final String photo;
  const DiaryModalCard({
    super.key,
    required this.tags,
    required this.location,
    required this.photo,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.asset(
            "assets/$photo",
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
            for (var tag in tags)
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
        Row(
          children: [
            const Icon(
              Icons.location_on_outlined,
              size: 32,
            ),
            Text(
              location,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ],
    );
  }
}
