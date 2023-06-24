import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sumday/providers/exchange_diary_list_provider.dart';
import 'package:sumday/providers/loginProvider.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:sumday/widgets/diary_modal_card.dart';

class ExchangeDiaryModal extends StatefulWidget {
  final int idx;
  final Function(int) setCurrent;
  const ExchangeDiaryModal(
      {super.key, required this.idx, required this.setCurrent});

  @override
  State<ExchangeDiaryModal> createState() => _ExchangeDiaryModalState();
}

class _ExchangeDiaryModalState extends State<ExchangeDiaryModal> {
  CarouselController buttonCarouselController = CarouselController();
  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<LoginProvider>(context);
    final user = userData.userInformation;
    final diaryListProvider = Provider.of<ExchangeDiaryListProvider>(context);
    final diaryList = diaryListProvider.diaryList;
    final docIds = diaryListProvider.docIds;
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: CarouselSlider(
        items: const [DiaryModalCard(), DiaryModalCard()],
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
