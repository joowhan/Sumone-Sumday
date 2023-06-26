import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sumday/models/rdiary_model.dart';

class DiaryCard extends StatefulWidget {
  final Diary diary;
  final Function favoriteClickHandler;

  const DiaryCard({
    super.key,
    required this.diary,
    required this.favoriteClickHandler,
  });

  @override
  State<DiaryCard> createState() => _DiaryCardState();
}

class _DiaryCardState extends State<DiaryCard> {
  @override
  Widget build(BuildContext context) {
    String formattedDate(DateTime time) =>
        DateFormat('yyyy-MM-dd').format(time);

    String joinWithHash(List<String> list) {
      return list.map((item) => '#$item').join(' ');
    }

    final ThemeData theme = Theme.of(context);

    return Container(
      height: 125,
      padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 1),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        clipBehavior: Clip.antiAlias,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            AspectRatio(
              aspectRatio: 12 / 10,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(4.5, 4.5, 4.5, 4.5),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    // border: Border.all(
                    //   color: Colors.black,
                    //   width: 1.0,
                    // ),
                  ),
                  child: Image.asset(
                    'assets/${widget.diary.photos[0]}',
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(14.0, 12.0, 14.0, 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const SizedBox(height: 12.0),
                    Text(
                      joinWithHash(widget.diary.tags),
                      style: const TextStyle(
                          color: Color.fromARGB(0xff, 0x13, 0x67, 0x50),
                          fontSize: 14,
                          fontWeight: FontWeight.w600),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 10.0),
                    Text(
                      formattedDate(widget.diary.date),
                      style: theme.textTheme.titleSmall,
                    ),
                    const SizedBox(height: 12.0),
                    Text(
                      widget.diary.context[0],
                      style: TextStyle(
                          color: Colors.grey.shade900,
                          fontSize: 14,
                          fontWeight: FontWeight.w600),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0.0, 4.5, 4.5, 0.0),
              child: IconButton(
                onPressed: () {
                  setState(() {
                    widget.favoriteClickHandler();
                  });
                },
                icon: Icon(
                  widget.diary.favorite
                      ? Icons.favorite
                      : Icons.favorite_border,
                  color: widget.diary.favorite ? Colors.red : null,
                ),
                isSelected: widget.diary.favorite,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
