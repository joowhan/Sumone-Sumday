import 'package:flutter/material.dart';
import 'package:sumday/screens/generate_diary.dart';
// import 'package:multi_select_flutter/multi_select_flutter.dart';
// import 'package:flutter_titled_container/flutter_titled_container.dart';
import 'package:sumday/widgets/locationInput.dart';
import 'package:sumday/models/diary_model.dart';

class Ai_WriteDiary extends StatefulWidget {
  // const Ai_WriteDiary({Key? key}) : super(key: key);
  final int pageIndex;
  final List<UserForm> dataList;
  Ai_WriteDiary({super.key, required this.pageIndex, required this.dataList});

  @override
  State<Ai_WriteDiary> createState() => _Ai_WriteDiaryState();
}

class _Ai_WriteDiaryState extends State<Ai_WriteDiary> {
  Widget _aiKeywordsForm() {
    return Center(
      child: ListView(
        children: [
          SizedBox(
            height: 50,
          ),
          Text(
            "${widget.pageIndex+1}", //timestamp에서 시간을 불러와야 한다.
            style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Color(0xff136750)),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // SizedBox(width: 10,),
              Text(
                "6월 9일, 오전 10시,", //timestamp에서 시간을 불러와야 한다.
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
                    children: locations.map((location) {
                      final locationId = locations.indexOf(location) + 1;
                      return Row(
                        children: [
                          OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              backgroundColor:
                                  _locationId == locationId.toString()
                                      ? Color(0xff136750)
                                      : Colors.white,
                            ),
                            onPressed: () {
                              locationClick(location, locationId.toString());
                            },
                            child: Text(
                              location,
                              style: TextStyle(
                                fontSize: 18,
                                color: _locationId == locationId.toString()
                                    ? Colors.white
                                    : Color(0xff136750),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 8,
                          ),
                        ],
                      );
                    }).toList(),
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
                  children: relations.map((relation) {
                    final relationId = relations.indexOf(relation) + 1;
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5),
                      child: Column(
                        children: [
                          Ink(
                            decoration: ShapeDecoration(
                              color: _relationId == relationId.toString()
                                  ? Color(0xff136750)
                                  : Colors.white,
                              shape: CircleBorder(),
                            ),
                            child: IconButton(
                              icon: Icon(relation.icon),
                              color: _relationId == relationId.toString()
                                  ? Colors.white
                                  : Color(0xff136750),
                              onPressed: () {
                                relationClick(
                                    relation.title, relationId.toString());
                              },
                            ),
                          ),
                          SizedBox(
                            height: 6,
                          ),
                          Text(
                            relation.title,
                            style: TextStyle(fontSize: 14),
                          )
                        ],
                      ),
                    );
                  }).toList(),
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
                  children: activities.map((activity) {
                    final activityId = activities.indexOf(activity) + 1;
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5),
                      child: Column(
                        children: [
                          Ink(
                            decoration: ShapeDecoration(
                              color: _activityId == activityId.toString()
                                  ? Color(0xff136750)
                                  : Colors.white,
                              shape: CircleBorder(),
                            ),
                            child: IconButton(
                              icon: Icon(activity.icon),
                              color: _activityId == activityId.toString()
                                  ? Colors.white
                                  : Color(0xff136750),
                              onPressed: () {
                                activityClick(
                                    activity.title, activityId.toString());
                              },
                            ),
                          ),
                          SizedBox(
                            height: 6,
                          ),
                          Text(
                            activity.title,
                            style: TextStyle(fontSize: 14),
                          )
                        ],
                      ),
                    );
                  }).toList(),
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
                      final feelingId = feelingTexts.indexOf(text) + 1;
                      return Ink(
                        padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                        decoration: ShapeDecoration(
                          color: Colors.white70,
                          shape: CircleBorder(),
                        ),
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            backgroundColor: _feelingId == feelingId.toString()
                                ? Color(0xff136750)
                                : Colors.white,
                          ),
                          onPressed: () {
                            feelingClick(text, feelingId.toString());
                          },
                          child: Text(
                            text,
                            style: TextStyle(
                              fontSize: 18,
                              color: _feelingId == feelingId.toString()
                                  ? Colors.white
                                  : Color(0xff136750),
                            ),
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
                onPressed: () {
                  UserForm userForm = UserForm(
                      location: _location,
                      relation: _relation,
                      activity: _activity,
                      userState: _feeling);
                  widget.dataList.add(userForm);

                  if (widget.pageIndex < 2) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Ai_WriteDiary(
                          pageIndex: widget.pageIndex + 1,
                          dataList: widget.dataList,
                        ),
                      ),
                    );
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => GenerateDiary(dataList: widget.dataList),
                      ),
                    );
                  }


                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (context) => GenerateDiary(data: userForm)));
                },
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
  var _relation = "";
  var _activity = "";
  var _feeling = "";
  var _locationId = "";
  var _relationId = "";
  var _activityId = "";
  var _feelingId = "";
  var _question = "";

  AskingQuestion() {
    if (_location == "") {
      _question = "장소를 선택해주세요!";
    } else {
      _question = "$_location에서 무엇을 하셨나요?";
    }
    return _question;
  }

  void locationClick(text, id) {
    setState(() {
      _location = text; // 버튼 클릭 시 변수에 값을 저장
      // isLocationClicked = !isLocationClicked;
      _locationId = id;
    });
  }

  void relationClick(text, id) {
    setState(() {
      _relation = text; // 버튼 클릭 시 변수에 값을 저장
      // isLocationClicked = !isLocationClicked;
      _relationId = id;
    });
  }

  void activityClick(text, id) {
    setState(() {
      _activity = text; // 버튼 클릭 시 변수에 값을 저장
      // isLocationClicked = !isLocationClicked;
      _activityId = id;
    });
  }

  void feelingClick(text, id) {
    setState(() {
      _feeling = text; // 버튼 클릭 시 변수에 값을 저장
      // isLocationClicked = !isLocationClicked;
      _feelingId = id;
    });
  }

  final List<String> locations = ['스타벅스', '투썸 플레이스', '삼성 내과 의원'];
  List<String> feelingTexts = ['즐겁다', '슬프다', '힘들다', '평범하다', '지쳤다', '최고다'];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: PageView.builder(itemBuilder: (BuildContext context, int index) {
      return _aiKeywordsForm();
    }));
  }
}

List<Activity> activities = [
  Activity(Icons.menu_book_sharp, "공부"),
  Activity(Icons.favorite_outline_sharp, "데이트"),
  Activity(Icons.restaurant, "식사"),
  Activity(Icons.sports_basketball_outlined, "운동"),
  Activity(Icons.beach_access, "휴식"),
];

List<Relation> relations = [
  Relation(Icons.family_restroom_sharp, "가족"),
  Relation(Icons.favorite, "연인"),
  Relation(Icons.people_alt, "친구"),
  Relation(Icons.accessibility_new_rounded, "혼자"),
  Relation(Icons.business, "비즈니스"),
];

class UserForm {
  final String location;
  final String relation;
  final String activity;
  final String userState;

  UserForm({
    required this.location,
    required this.relation,
    required this.activity,
    required this.userState,
  });
  @override
  String toString() {
    return 'UserForm{location: $location, relation: $relation, activity: $activity, userState: $userState}';
  }
  
  
}


