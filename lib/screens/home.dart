import 'package:flutter/material.dart';
import 'package:sumday/providers/exchange_diary_list_provider.dart';
import 'package:sumday/providers/location_provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:provider/provider.dart';
import 'package:sumday/providers/diaries_provider.dart';

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
      firstDay: DateTime(2022, 1, 1),
      lastDay: DateTime(2023, 12, 31),
      rowHeight: 40,
      daysOfWeekHeight: 20,
      headerVisible: false,
    );
  }
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
    final diariesProvider =
        Provider.of<DiariesProvider>(context, listen: false);
    diariesProvider.init();
  }

  var isInit = true;

  @override
  void didChangeDependencies() {
    if (isInit) {
      Provider.of<ExchangeDiaryListProvider>(context).fetchDiaryList();
      Provider.of<LocationProvider>(context).fetchLocationList();
    }
    isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0x00f5f5f5),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(30.0, 20.0, 30.0, 0.0),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                  border: Border.all(
                    color: Colors.grey,
                  ),
                ),
                padding: const EdgeInsets.all(20),
                child: const Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: AssetImage('assets/jjeri1.jpg'),
                      radius: 40.0,
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
                            Text(
                              '쩨리님,',
                              style: TextStyle(
                                  color: Colors.black38,
                                  letterSpacing: 2.0,
                                  fontFamily: 'Nanum_JangMiCe',
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(width: 10),
                            Icon(
                              Icons.edit,
                              size: 15.0,
                            ),
                          ],
                        ),
                        Text(
                          '오늘을 더해보세요!',
                          style: TextStyle(
                            fontFamily: 'Nanum_JangMiCe',
                            fontSize: 8,
                            color: Colors.black38,
                            letterSpacing: 2.0,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text('이번주 미션'),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                  border: Border.all(
                    color: Colors.grey,
                  ),
                ),
                padding: const EdgeInsets.all(20),
                child: const Column(
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.star,
                          size: 15,
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Text('3일 연속 일기 작성!'),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.star,
                          size: 15,
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Text('SNS 공유하기 1회'),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.star,
                          size: 15,
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Text('교환일기 친구 초대하기'),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                  border: Border.all(
                    color: Colors.white,
                  ),
                ),
                padding: const EdgeInsets.all(20),
                child: SfCalendar(
                  view: CalendarView.month,
                  initialSelectedDate: DateTime.now(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
