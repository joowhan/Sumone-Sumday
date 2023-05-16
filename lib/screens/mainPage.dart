import 'package:flutter/material.dart';


class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;
  // final List<Widget> _widgetOptions = <Widget> [Home(), list(), MyProfile()];
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sumday!', style: TextStyle(fontWeight:FontWeight.bold),),
        backgroundColor: Color(0xff326295),
      ),
      body: Center(
        // child: _widgetOptions[_selectedIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.library_books_rounded),
            label: '목록',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: '마이 페이지',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Color(0xff326295),
        backgroundColor: Colors.white,
        onTap: _onItemTapped,
      ),
    );
  }
}
