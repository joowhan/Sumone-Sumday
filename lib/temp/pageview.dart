import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final List<String> items = ['a', 'b', 'c'];
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPageIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      setState(() {
        _currentPageIndex = _pageController.page.round();
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('PageView Example'),
        ),
        body: Column(
          children: [
            Expanded(
              child: PageView(
                controller: _pageController,
                children: items.map((item) {
                  return Center(
                    child: Text(
                      item,
                      style: TextStyle(fontSize: 24),
                    ),
                  );
                }).toList(),
                onPageChanged: (int index) {
                  setState(() {
                    _currentPageIndex = index;
                  });
                },
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if (_currentPageIndex == items.length - 1) {
                  // 마지막 페이지인 경우 완료 동작 수행
                  _completeAction();
                } else {
                  // 다음 페이지로 이동
                  _pageController.nextPage(
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                }
              },
              child: Text(_getButtonText()),
            ),
          ],
        ),
      ),
    );
  }

  String _getButtonText() {
    if (_currentPageIndex == items.length - 1) {
      return '완료';
    } else {
      return '다음';
    }
  }

  void _completeAction() {
    // 완료 동작 수행
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('완료'),
        content: Text('작업이 완료되었습니다.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // 대화상자 닫기
            },
            child: Text('확인'),
          ),
        ],
      ),
    );
  }
}
