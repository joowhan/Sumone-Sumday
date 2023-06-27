import 'package:flutter/material.dart';
import 'package:sumday/providers/diaries_provider.dart';
import 'package:sumday/utils/variables.dart';
import 'package:provider/provider.dart';

class CommentWidget extends StatelessWidget {
  final String photo;
  final String ownerId;
  final String ownerName;
  final String content;
  final DateTime createdAt;

  const CommentWidget({
    super.key,
    required this.photo,
    required this.ownerId,
    required this.ownerName,
    required this.content,
    required this.createdAt,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      decoration: BoxDecoration(
        border: Border.all(
          color: AppColors.backgroundGreyColor(),
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        child: Column(
          children: [
            Row(
              // 댓글 쓴 사람 정보
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: FutureBuilder<String>(
                    future: Provider.of<DiariesProvider>(context, listen: false)
                        .getImageUrl(photo),
                    builder:
                        (BuildContext context, AsyncSnapshot<String> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return SizedBox(
                            height: 10,
                            width: 10,
                            child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        return Image.network(
                          snapshot.data!,
                          width: 20,
                          height: 20,
                          fit: BoxFit.fitWidth,
                          alignment: Alignment.center,
                        );
                      }
                    },
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ownerName,
                      style: TextStyle(
                        color: AppColors.fontSecondaryColor(),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      content,
                      style: const TextStyle(
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Row(
              children: [
                const SizedBox(
                  width: 50,
                ),
                Text(
                  createdAt.toString().substring(0, 10),
                  style: TextStyle(
                    color: AppColors.fontGreyColor(),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
