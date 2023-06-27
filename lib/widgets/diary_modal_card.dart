import 'package:flutter/material.dart';
import 'package:sumday/providers/diaries_provider.dart';
import 'package:provider/provider.dart';

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
          child: FutureBuilder<String>(
                      future:
                          Provider.of<DiariesProvider>(context, listen: false)
                              .getImageUrl(photo),
                      builder: (BuildContext context,
                          AsyncSnapshot<String> snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return SizedBox(
                            height: 10,
                            width: 10,
                            child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else {
                          return Image.network(snapshot.data!,            width: 320,
            height: 180,
            fit: BoxFit.fitWidth,
            alignment: Alignment.center,);
                        }
                      },
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
