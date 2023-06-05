import 'package:flutter/material.dart';
// import 'package:multi_select_flutter/multi_select_flutter.dart';
// import 'package:flutter_titled_container/flutter_titled_container.dart';

class Ai_WriteDiary extends StatefulWidget {
  const Ai_WriteDiary({Key? key}) : super(key: key);

  @override
  State<Ai_WriteDiary> createState() => _Ai_WriteDiaryState();
}

class Animal {
  final int id;
  final String name;

  Animal({
    required this.id,
    required this.name,
  });
}

class TitledContainer extends StatelessWidget {
  const TitledContainer(
      {required this.titleText, required this.child, this.idden = 8, Key? key})
      : super(key: key);
  final String titleText;
  final double idden;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          alignment: Alignment.center,
          width: 350,
          margin: const EdgeInsets.only(top: 8),
          padding: EdgeInsets.all(idden),
          decoration: BoxDecoration(
            border: Border.all(color: Color(0xff136750)),
            borderRadius: BorderRadius.circular(idden * 0.6),
          ),
          child: child,
        ),
        Positioned(
          left: 10,
          right: 10,
          top: 0,
          child: Align(
            alignment: Alignment.topLeft,
            child: Container(
              // constraints: BoxConstraints.expand(),
              color: Colors.white,
              child: Text(
                titleText,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Color(0xff136750)),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _Ai_WriteDiaryState extends State<Ai_WriteDiary> {
  Widget _aiKeywordsForm() {
    return Center(
      child: ListView(
        children: [
          SizedBox(
            height: 50,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // SizedBox(width: 10,),
              Text(
                "6월 9일, 오전 10시,",
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff136750)),
              ),
            ],
          ),
          SizedBox(
            height: 50,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TitledContainer(
                titleText: '장소',
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          backgroundColor: _locationId == '1'
                              ? Color(0xff136750)
                              : Colors.white,
                        ),
                        onPressed: () {
                          locationClick("스타벅스", "1");
                        },
                        child: Text(
                          "스타벅스",
                          style: TextStyle(
                              fontSize: 18,
                              color: _locationId == '1'
                                  ? Colors.white
                                  : Color(0xff136750)),
                        ),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          backgroundColor: _locationId == '2'
                              ? Color(0xff136750)
                              : Colors.white,
                        ),
                        onPressed: () {
                          locationClick("투썸 플레이스", "2");
                        },
                        child: Text(
                          "투썸 플레이스",
                          style: TextStyle(
                              fontSize: 18,
                              color: _locationId == '2'
                                  ? Colors.white
                                  : Color(0xff136750)),
                        ),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          backgroundColor: _locationId == '3'
                              ? Color(0xff136750)
                              : Colors.white,
                        ),
                        onPressed: () {
                          locationClick("삼성 내과 의원", "3");
                        },
                        child: Text(
                          "삼성 내과 의원",
                          style: TextStyle(
                              fontSize: 18,
                              color: _locationId == '3'
                                  ? Colors.white
                                  : Color(0xff136750)),
                        ),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            AskingQuestion(),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TitledContainer(
                titleText: '관계',
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        Ink(
                          decoration: const ShapeDecoration(
                            color: Colors.white70,
                            shape: CircleBorder(),
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.family_restroom_sharp),
                            color: Color(0xff136750),
                            onPressed: () {},
                          ),
                        ),
                        SizedBox(
                          height: 6,
                        ),
                        Text(
                          "가족",
                          style: TextStyle(fontSize: 14),
                        )
                      ],
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Column(
                      children: [
                        Ink(
                          decoration: const ShapeDecoration(
                            color: Colors.white70,
                            shape: CircleBorder(),
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.favorite),
                            color: Color(0xff136750),
                            onPressed: () {},
                          ),
                        ),
                        SizedBox(
                          height: 6,
                        ),
                        Text(
                          "연인",
                          style: TextStyle(fontSize: 14),
                        )
                      ],
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Column(
                      children: [
                        Ink(
                          decoration: const ShapeDecoration(
                            color: Colors.white70,
                            shape: CircleBorder(),
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.people_alt),
                            color: Color(0xff136750),
                            onPressed: () {},
                          ),
                        ),
                        SizedBox(
                          height: 6,
                        ),
                        Text(
                          "친구",
                          style: TextStyle(fontSize: 14),
                        )
                      ],
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Column(
                      children: [
                        Ink(
                          decoration: const ShapeDecoration(
                            color: Colors.white70,
                            shape: CircleBorder(),
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.accessibility_new_rounded),
                            color: Color(0xff136750),
                            onPressed: () {},
                          ),
                        ),
                        SizedBox(
                          height: 6,
                        ),
                        Text(
                          "혼자",
                          style: TextStyle(fontSize: 14),
                        )
                      ],
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Column(
                      children: [
                        Ink(
                          decoration: const ShapeDecoration(
                            color: Colors.white70,
                            shape: CircleBorder(),
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.business),
                            color: Color(0xff136750),
                            onPressed: () {},
                          ),
                        ),
                        SizedBox(
                          height: 6,
                        ),
                        Text(
                          '비즈니스',
                          style: TextStyle(fontSize: 14),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TitledContainer(
                titleText: '활동',
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        Ink(
                          decoration: const ShapeDecoration(
                            color: Colors.white70,
                            shape: CircleBorder(),
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.menu_book_sharp),
                            color: Color(0xff136750),
                            onPressed: () {},
                          ),
                        ),
                        SizedBox(
                          height: 6,
                        ),
                        Text(
                          "공부",
                          style: TextStyle(fontSize: 14),
                        )
                      ],
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Column(
                      children: [
                        Ink(
                          decoration: const ShapeDecoration(
                            color: Colors.white70,
                            shape: CircleBorder(),
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.favorite_outline_sharp),
                            color: Color(0xff136750),
                            onPressed: () {},
                          ),
                        ),
                        SizedBox(
                          height: 6,
                        ),
                        Text(
                          "데이트",
                          style: TextStyle(fontSize: 14),
                        )
                      ],
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Column(
                      children: [
                        Ink(
                          decoration: const ShapeDecoration(
                            color: Colors.white70,
                            shape: CircleBorder(),
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.restaurant),
                            color: Color(0xff136750),
                            onPressed: () {},
                          ),
                        ),
                        SizedBox(
                          height: 6,
                        ),
                        Text(
                          "식사",
                          style: TextStyle(fontSize: 14),
                        )
                      ],
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Column(
                      children: [
                        Ink(
                          decoration: const ShapeDecoration(
                            color: Colors.white70,
                            shape: CircleBorder(),
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.sports_basketball_outlined),
                            color: Color(0xff136750),
                            onPressed: () {},
                          ),
                        ),
                        SizedBox(
                          height: 6,
                        ),
                        Text(
                          "운동",
                          style: TextStyle(fontSize: 14),
                        )
                      ],
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Column(
                      children: [
                        Ink(
                          decoration: const ShapeDecoration(
                            color: Colors.white70,
                            shape: CircleBorder(),
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.beach_access),
                            color: Color(0xff136750),
                            onPressed: () {},
                          ),
                        ),
                        SizedBox(
                          height: 6,
                        ),
                        Text(
                          '휴식',
                          style: TextStyle(fontSize: 14),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TitledContainer(
                titleText: '기분',
                child: SingleChildScrollView(
                  child: Wrap(
                    // mainAxisSize: MainAxisSize.max,

                    // mainAxisAlignment: MainAxisAlignment.center,
                    children: feelingTexts.map((text) {
                      return Ink(
                        padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                        decoration: const ShapeDecoration(
                          color: Colors.white70,
                          shape: CircleBorder(),
                        ),
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            backgroundColor: Colors.white,
                          ),
                          onPressed: () {},
                          child: Text(
                            text,
                            style: TextStyle(
                                fontSize: 18, color: Color(0xff136750)),
                          ),
                        ),
                      ); // 버튼 사이에 10픽셀의 간격
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 50,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  backgroundColor: Colors.white,
                ),
                onPressed: () {},
                child: Text(
                  "건너뛰기",
                  style: TextStyle(fontSize: 18, color: Color(0xff136750)),
                ),
              ),
              SizedBox(
                width: 30,
              ),
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  backgroundColor: Colors.white,
                ),
                onPressed: () {},
                child: Text(
                  "완료",
                  style: TextStyle(fontSize: 18, color: Color(0xff136750)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  var _location = "";
  var _locationId = "";
  var _question = "";
  AskingQuestion() {
    if (_location == "") {
      _question = "장소를 선택해주세요!";
    } else {
      _question = "$_location에서 무엇을 하셨나요?";
    }
    return _question;
  }

  // bool isLocationClicked = false;
  // final List<bool>_selectedLocation = <bool>[true, ]
  void locationClick(text, id) {
    setState(() {
      _location = text; // 버튼 클릭 시 변수에 값을 저장
      // isLocationClicked = !isLocationClicked;
      _locationId = id;
    });
  }

  List<String> feelingTexts = ['즐겁다', '슬프다', '힘들다', '평범하다', '지쳤다', '최고다'];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
          itemBuilder: (BuildContext context, int index){
        return _aiKeywordsForm();
      })
    );
  }
}
// OutlinedButton(onPressed: null, child:Text("한강대우아파트")),
