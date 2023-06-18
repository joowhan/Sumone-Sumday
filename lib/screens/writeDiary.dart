//ai_resultDiary.dart
import 'package:flutter/material.dart';
class WriteDiary extends StatefulWidget {
  const WriteDiary({Key? key}) : super(key: key);

  @override
  State<WriteDiary> createState() => _WriteDiaryState();//ai_resultDiary();
}

class _WriteDiaryState extends State<WriteDiary> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            print('back');
          },
          icon: Icon(Icons.arrow_back_ios_new, color: Colors.black38,),
        ),
        actions: [
          IconButton(
              onPressed: (){
                print('save');
              },
              icon: Icon(Icons.done, color: Colors.black38,)
          )
        ],
        backgroundColor: Colors.white,
        elevation: 0.0,
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(30.0, 40.0,30.0, 40.0),
        child: Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [Column(children: [
                    //날짜 받아오기
                    Text('6월 6일 오후 4시',
                        style: TextStyle(
                          color: Colors.black38,
                          letterSpacing: 2.0,
                          // fontFamily: ...
                        ),
                      ),
                      // 해시태그 받아오기
                      Text('#카페, #강아지, #한강',
                        style: TextStyle(
                          color: Colors.black38,
                          letterSpacing: 2.0,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text('오늘의 날씨',
                        style: TextStyle(

                        ),
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      Icon(
                        Icons.sunny,
                        size: 15.0,
                      )
                    ],
                  ),
                ],),

                SizedBox(
                  height: 20,
                ),
                Container(
                  child: Image.asset('assets/karlo_1.png'),
                ),
                SizedBox(
                  height: 10,
                ),

                Container(
                  child: Text('오늘 강아지와 한강변을 따라 산책했다. 스타벅스도 들렸다. 날씨가 맑아서 행복했다.',
                    style: TextStyle(

                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.image),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_reaction),
            label: '',

          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.text_fields),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark_border),
            label: '',
          ),
        ],
        // currentIndex: _selectedIndex,
        // selectedItemColor: Colors.white,
        // backgroundColor: Color(0xffF4C54F),
        // onTap: _onItemTapped,
      ),
    );
  }
}
/*import 'package:flutter/material.dart';
class WriteDiary extends StatefulWidget {
  const WriteDiary({Key? key}) : super(key: key);

  @override
  State<WriteDiary> createState() => _WriteDiaryState();
}

class _WriteDiaryState extends State<WriteDiary> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}*/
