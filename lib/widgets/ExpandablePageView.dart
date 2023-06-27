import 'package:sumday/providers/generate_provider.dart';
import 'package:sumday/widgets/SizeReportingWidget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ExpandablePageView extends StatefulWidget {
  final List<Widget> children;

  const ExpandablePageView({
    Key? key,
    required this.children,
  }) : super(key: key);

  @override
  State<ExpandablePageView> createState() => _ExpandablePageViewState();
}

class _ExpandablePageViewState extends State<ExpandablePageView>
    with TickerProviderStateMixin {
  late PageController _pageController;
  late List<double> _heights;
  int _currentPage = 0;

  double get _currentHeight => _heights[_currentPage];

  @override
  void initState() {
    _heights = widget.children.map((e) => 0.0).toList();
    super.initState();
    _pageController = PageController()
      ..addListener(() {
        final newPage = _pageController.page?.round() ?? 0;
        if (_currentPage != newPage) {
          setState(() => _currentPage = newPage);
        }
      });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GenerateProvider>(builder: (context, generateProvider, _) {
      return TweenAnimationBuilder<double>(
        curve: Curves.easeInOutCubic,
        duration: const Duration(milliseconds: 100),
        tween: Tween<double>(begin: _heights[0], end: _currentHeight),
        builder: (context, value, child) =>
            SizedBox(height: value, child: child),
        child: PageView(
          onPageChanged: (changePage) {
            setState(() {
              generateProvider.setPageValue(changePage);
              generateProvider.setSliderValue((changePage + 1).toDouble());
            });
          },
          scrollDirection: Axis.horizontal,
          controller: _pageController,
          children: _sizeReportingChildren
              .asMap() //
              .map((index, child) => MapEntry(index, child))
              .values
              .toList(),
        ),
      );
    });
  }

  List<Widget> get _sizeReportingChildren => widget.children
      .asMap() //
      .map(
        (index, child) => MapEntry(
          index,
          OverflowBox(
            //needed, so that parent won't impose its constraints on the children, thus skewing the measurement results.
            minHeight: 0,
            maxHeight: double.infinity,
            alignment: Alignment.topCenter,
            child: SizeReportingWidget(
              onSizeChange: (size) =>
                  setState(() => _heights[index] = size.height),
              child: Align(child: child),
            ),
          ),
        ),
      )
      .values
      .toList();
}
