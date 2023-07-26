import 'package:flutter/material.dart';
import 'package:sumday/screens/diaries.dart';
import 'package:sumday/screens/exchange_diary_list.dart';
import 'package:sumday/screens/newDiary.dart';
import 'package:sumday/screens/settings.dart';
import 'package:sumday/screens/home.dart';
import 'package:animated_floating_buttons/animated_floating_buttons.dart';
import 'package:sumday/screens/ai_writeDiary.dart';
import 'package:sumday/screens/writeDiary.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;
  final GlobalKey<AnimatedFloatingActionButtonState> key =
      GlobalKey<AnimatedFloatingActionButtonState>();
  final List<Widget> _widgetOptions = <Widget>[
    const Home(),
    const Diaries(),
    const NewDiary(),
    const ExchangeDiaryList(),
    const Settings(),
  ];
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // floating action button
  Widget float1() {
    return Container(
      child: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const Ai_WriteDiary(
                      pageIndex: 0,
                      dataList: [],
                    )),
          );
        },
        heroTag: "btn1",
        tooltip: 'First button',
        label: const Text('AI와 일기 작성 '),
        icon: const Icon(Icons.add),
      ),
    );
  }

  Widget float2() {
    return Container(
      child: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const WriteDiary()),
          );
        },
        heroTag: "btn2",
        tooltip: 'Second button',
        label: const Text("교환일기"),
        icon: const Icon(Icons.add),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final appBarHeight = screenHeight * 0.15; // 화면 높이의 10%

    return WillPopScope(
      onWillPop: () async {
        return await showDialog(
                context: context,
                builder: (context) => AlertDialog(
                      title: const Text('정말 종료하겠습니까?'),
                      actions: [
                        ElevatedButton(
                          onPressed: () => Navigator.of(context).pop(true),
                          child: const Text('확인'),
                        ),
                        ElevatedButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: const Text('취소'),
                        ),
                      ],
                    )) ??
            false;
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Image.asset('assets/small_logo.png'),
            onPressed: () {
              print('home_icon is clicked');
            },
          ),
          actions: [
            IconButton(
              onPressed: () {
                print('search Icon');
                print('${ModalRoute.of(context)?.settings.name}');
              },
              icon: const Icon(
                Icons.search,
                color: Colors.black38,
              ),
            ),
            IconButton(
              onPressed: () {
                print('alarm Icon');
              },
              icon: const Icon(
                Icons.alarm,
                color: Colors.black38,
              ),
            ),
            IconButton(
              onPressed: () {
                print('edit Icon');
              },
              icon: const Icon(
                Icons.edit,
                color: Colors.black38,
              ),
            ),
          ],
          backgroundColor: Colors.white,
          elevation: 0.25,
        ),
        body: Center(
          child: _widgetOptions[_selectedIndex],
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.library_books_rounded),
              label: '목록',
            ),
            // BottomNavigationBarItem(
            //   icon: Icon(
            //     Icons.add_circle_outline,
            //     size: 45,
            //   ),
            //   label: '',
            // ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bookmark_border),
              label: '북마크',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.edit_note_sharp),
              label: '교환일기',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: '설정',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: const Color(0xff136750),
          backgroundColor: Colors.white,
          onTap: _onItemTapped,
        ),
        floatingActionButton: AnimatedFloatingActionButton(
            //Fab list
            fabButtons: <Widget>[float1(), float2()],
            key: key,
            colorStartAnimation: Colors.blue,
            colorEndAnimation: Colors.red,
            animatedIconData: AnimatedIcons.menu_close //To principal button
            ),
      ),
    );
  }
}
