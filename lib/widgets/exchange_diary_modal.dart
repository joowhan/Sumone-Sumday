import 'package:flutter/material.dart';
import 'package:sumday/models/rdiary_model.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:sumday/widgets/diary_modal_card.dart';

class ExchangeDiaryModal extends StatefulWidget {
  final Function(int) setCurrent;
  final Diary diaries;
  const ExchangeDiaryModal({
    super.key,
    required this.setCurrent,
    required this.diaries,
  });

  @override
  State<ExchangeDiaryModal> createState() => _ExchangeDiaryModalState();
}

class _ExchangeDiaryModalState extends State<ExchangeDiaryModal> {
  CarouselController buttonCarouselController = CarouselController();
  @override
  Widget build(BuildContext context) {
    final items = List.generate(
        widget.diaries.context.length,
        (index) => DiaryModalCard(
              tags: widget.diaries.getCurrTags(index).sublist(0, 3),
              location: widget.diaries.getCurrTags(index)[3],
              photo: widget.diaries.photos[index],
            ));
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: CarouselSlider(
        items: items,
        carouselController: buttonCarouselController,
        options: CarouselOptions(
          autoPlay: false,
          enlargeCenterPage: true,
          viewportFraction: 0.7,
          aspectRatio: 1.3,
          initialPage: 0,
          enlargeStrategy: CenterPageEnlargeStrategy.scale,
          enlargeFactor: 0.2,
          onPageChanged: (index, reason) => {
            widget.setCurrent(index),
          },
        ),
      ),
    );
  }
}
