import 'package:floating_bottom_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:sumday/screens/diaries.dart';
import 'package:sumday/screens/get_place_test.dart';
import 'package:sumday/screens/newDiary.dart';
import 'package:sumday/screens/settings.dart';
import 'package:sumday/screens/home.dart';
import 'package:sumday/utils/variables.dart' as variable;

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;
  final List<Widget> _widgetOptions = <Widget>[
    const Home(),
    const Diaries(),
    const PlaceTest(),
    const Settings(),
    const NewDiary(),
  ];
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'SumDAY',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xffF4C54F),
        elevation: 0.0,
      ),
      body: Center(
        child: _widgetOptions[_selectedIndex],
      ),
      bottomNavigationBar: AnimatedBottomNavigationBar(
        controller: FloatingBottomBarController(initialIndex: 0),
        bottomBar: [
          BottomBarItem(
              icon: Icon(
                Icons.home,
                color: variable.AppColors.fontSecondaryColor(),
                size: 36,
              ),
              iconSelected: Icon(
                Icons.home,
                color: variable.AppColors.fontSecondaryColor().withOpacity(0.8),
                size: 36,
              ),
              title: "메인",
              titleStyle: TextStyle(
                  color:
                      variable.AppColors.fontSecondaryColor().withOpacity(0.8),
                  fontSize: 16),
              dotColor:
                  variable.AppColors.fontSecondaryColor().withOpacity(0.8),
              onTap: (value) {
                _onItemTapped(value);
              }),
          BottomBarItem(
              icon: Icon(Icons.library_books_rounded,
                  color: variable.AppColors.fontSecondaryColor()),
              iconSelected: Icon(
                Icons.library_books_rounded,
                color: variable.AppColors.fontSecondaryColor().withOpacity(0.5),
              ),
              title: "목록",
              titleStyle: TextStyle(
                color: variable.AppColors.fontSecondaryColor().withOpacity(0.5),
                fontSize: 16,
              ),
              dotColor:
                  variable.AppColors.fontSecondaryColor().withOpacity(0.5),
              onTap: (value) {
                _onItemTapped(value);
              }),
          BottomBarItem(
              icon: Icon(Icons.bookmark_border,
                  color: variable.AppColors.fontSecondaryColor()),
              iconSelected: Icon(
                Icons.bookmark_border,
                color: variable.AppColors.fontSecondaryColor().withOpacity(0.5),
              ),
              title: "북마크",
              titleStyle: TextStyle(
                  color:
                      variable.AppColors.fontSecondaryColor().withOpacity(0.5),
                  fontSize: 16),
              dotColor:
                  variable.AppColors.fontSecondaryColor().withOpacity(0.5),
              onTap: (value) {
                _onItemTapped(value);
              }),
          BottomBarItem(
              icon: Icon(Icons.settings,
                  color: variable.AppColors.fontSecondaryColor()),
              iconSelected: Icon(
                Icons.settings,
                color: variable.AppColors.fontSecondaryColor().withOpacity(0.5),
              ),
              title: "설정",
              titleStyle: TextStyle(
                  color:
                      variable.AppColors.fontSecondaryColor().withOpacity(0.5),
                  fontSize: 16),
              dotColor:
                  variable.AppColors.fontSecondaryColor().withOpacity(0.5),
              onTap: (value) {
                _onItemTapped(value);
              }),
        ],
        bottomBarCenterModel: BottomBarCenterModel(
          centerBackgroundColor: variable.AppColors.primaryColor(),
          centerIcon: FloatingCenterButton(
            child: Icon(
              Icons.add,
              size: 45,
              color: variable.AppColors.fontSecondaryColor(),
            ),
          ),
          centerIconChild: [
            FloatingCenterButtonChild(
                child: Icon(
                  Icons.android,
                  size: 30,
                  color: variable.AppColors.fontSecondaryColor(),
                ),
                onTap: () {}),
            FloatingCenterButtonChild(
              child: Icon(
                Icons.edit,
                size: 30,
                color: variable.AppColors.fontSecondaryColor(),
              ),
            ),
          ],
        ),
        barColor: variable.AppColors.primaryColor(),
      ),
    );
  }
}
