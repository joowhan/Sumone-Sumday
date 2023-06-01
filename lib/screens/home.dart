import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class Calendar2 extends StatefulWidget {
  const Calendar2({Key? key}) : super(key: key);

  @override
  _Calendar2State createState() => _Calendar2State();
}

class _Calendar2State extends State<Calendar2> {
  @override
  Widget build(BuildContext) {
    return TableCalendar(
      focusedDay: DateTime.now(),
      firstDay: DateTime(2022,1,1),
      lastDay: DateTime(2023,12,31),
      rowHeight: 40,
      daysOfWeekHeight: 20,
      headerVisible: false,
    );
  }
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.fromLTRB(30.0, 40.0, 30.0, 0.0),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                CircleAvatar(
                  backgroundImage: AssetImage('assets/jjeri1.jpg'),
                  radius: 70.0,
                ),
                SizedBox(
                  width: 20,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('쩨리님,',
                          style: TextStyle(
                              color: Colors.black38,
                              letterSpacing: 2.0,
                              fontFamily: 'Nanum_JangMiCe',
                              fontSize: 40.0,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                        SizedBox(width:10),
                        Icon(
                          Icons.edit,
                          size: 15.0,
                        ),
                      ],
                    ),
                    Text('매일을 기록해 보세요!',
                      style: TextStyle(
                        fontFamily: 'Nanum_JangMiCe',
                        fontSize: 16,
                        color: Colors.black38,
                        letterSpacing: 2.0,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Divider(
              height: 60.0,
              color: Colors.grey,
              thickness: 0.5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Text(
                      '작성한 일기',
                      style: TextStyle(
                        color: Colors.black38,
                        letterSpacing: 1.0,
                      ),
                    ),
                    Text(
                      'n',
                      style: TextStyle(
                        color: Colors.black38,
                        letterSpacing: 3.0,
                      ),
                    ),
                  ],
                ),
                Container(
                  width: 3.0,
                  color: Colors.black38,
                ),
                Column(
                  children: [
                    Text(
                      '이번 달 일기',
                      style: TextStyle(
                        color: Colors.black38,
                        letterSpacing: 1.0,
                      ),
                    ),
                    Text(
                      'n',
                      style: TextStyle(
                        color: Colors.black38,
                        letterSpacing: 3.0,
                      ),
                    ),
                  ],
                ),
                VerticalDivider(
                  thickness: 1,
                  width: 1,
                  color: Colors.black38,
                ),
                Column(
                  children: [
                    Text(
                      '방문한 장소',
                      style: TextStyle(
                        color: Colors.black38,
                        letterSpacing: 1.0,
                      ),
                    ),
                    Text(
                      'n',
                      style: TextStyle(
                        color: Colors.black38,
                        letterSpacing: 3.0,
                      ),
                    ),
                  ],
                ),
                VerticalDivider(
                  thickness: 1,
                  width: 1,
                  color: Colors.black38,
                ),
                Column(
                  children: [
                    Text(
                      '현재 등급',
                      style: TextStyle(
                        color: Colors.black38,
                        letterSpacing: 1.0,
                      ),
                    ),
                    Text(
                      'n',
                      style: TextStyle(
                        color: Colors.black38,
                        letterSpacing: 3.0,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Divider(
              height: 60.0,
              color: Colors.grey,
              thickness: 0.5,
            ),
            Calendar2(
            ),
          ],
        ),
      ),
    );
  }
}