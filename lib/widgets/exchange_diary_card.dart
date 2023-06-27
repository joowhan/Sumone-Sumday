import 'package:flutter/material.dart';
import 'package:sumday/providers/diaries_provider.dart';
import 'package:sumday/screens/exchange_diary_detail.dart';
import 'package:sumday/utils/variables.dart';
import 'package:provider/provider.dart';

class ExchangeDiaryCard extends StatelessWidget {
  final int idx;
  final String diaryId;
  final String content;
  final List<dynamic> comments;
  final List<dynamic> tags;
  final String location;
  final DateTime date;
  final String writer;
  final String photo;

  const ExchangeDiaryCard({
    super.key,
    required this.idx,
    required this.diaryId,
    required this.content,
    required this.comments,
    required this.tags,
    required this.location,
    required this.date,
    required this.writer,
    required this.photo,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ExchangeDiaryDetail(
                    idx: idx,
                    diaryId: diaryId,
                    content: content,
                    comments: comments,
                    tags: tags,
                    location: location,
                    date: date,
                    writer: writer,
                    photo: photo,
                  ))),
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        decoration: BoxDecoration(
          color: AppColors.backgroundGreyColor(),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
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
                          return Image.network(snapshot.data!,
                                            width: double.maxFinite,
                  height: 185,
                  fit: BoxFit.fitWidth,
                  alignment: Alignment.center,);
                        }
                      },
                    ),
                
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  for (String tag in tags)
                    Text(
                      "#$tag",
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "${date.year}년 ${date.month}월 ${date.day}일",
                    style: TextStyle(
                      color: AppColors.fontGreyColor(),
                    ),
                  ),
                  Text(
                    "by. ${writer.substring(0, 6)}",
                    style: TextStyle(color: AppColors.fontSecondaryColor()),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
