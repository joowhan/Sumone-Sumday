import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sumday/providers/location_provider.dart';
import 'package:sumday/screens/generate_diary.dart';
// import 'package:multi_select_flutter/multi_select_flutter.dart';
// import 'package:flutter_titled_container/flutter_titled_container.dart';
import 'package:sumday/widgets/locationInput.dart';
import 'package:sumday/models/diary_model.dart';

class Ai_WriteDiary extends StatefulWidget {
  // const Ai_WriteDiary({Key? key}) : super(key: key);
  final int pageIndex;
  final List<UserForm> dataList;
  const Ai_WriteDiary(
      {super.key, required this.pageIndex, required this.dataList});

  @override
  State<Ai_WriteDiary> createState() => _Ai_WriteDiaryState();
}

//count 높은 순으로 좌표 불러오기
// 날씨도 불러오기 -> 각 페이지에 날씨 기본 저장
//좌표로 근처 위치 리스트 데려오기
//위치 리스트에서 place_name 들을 따로 불러와서 list에 저장
// 카테고리 list도 순서대로 저장 혹은 dictionary로 key value로 저장
//ai_writeDiary로 위치 리스트, 날씨 pass
//ai writeDiary는 현재 list 형태로 위치가 저장되어 있음, 날씨도 제대로 표시할 것
class _Ai_WriteDiaryState extends State<Ai_WriteDiary> {
  // Timestamp 불러와서 변환
  // DateTime timestamp = DateTime.fromMillisecondsSinceEpoch(yourTimestamp);
  // int year = timestamp.year;
  // int month = timestamp.month;
  // int day = timestamp.day;
  // int hour = timestamp.hour;
  final TextEditingController _controller = TextEditingController();
  Widget _aiKeywordsForm() {
    final locationProviderList = Provider.of<LocationProvider>(context);
    final locationList = locationProviderList.locationList;
    locationList.sort((a, b) => a.places.length.compareTo(b.places.length));
    final sortedLocationList =
        locationList.reversed.toList().sublist(0, min(3, locationList.length));
    List<UserForm> dataList = widget.dataList;
    return Center(
      child: ListView(
        children: [
          const SizedBox(
            height: 50,
          ),
          Text(
            "${widget.pageIndex + 1}/3", //timestamp에서 시간을 불러와야 한다.
            style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Color(0xff136750)),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // SizedBox(width: 10,),
              Text(
                "${sortedLocationList[widget.pageIndex].timestamp.toDate().month}월 ${sortedLocationList[widget.pageIndex].timestamp.toDate().day}일 ${sortedLocationList[widget.pageIndex].timestamp.toDate().hour}시", //timestamp에서 시간을 불러와야 한다.
                style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff136750)),
              ),
            ],
          ),
          const SizedBox(
            height: 50,
          ),
          Text(
            AskingQuestion(),
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TitledContainer(
                titleText: '장소',
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: sortedLocationList[widget.pageIndex]
                        .places
                        .map((locationData) {
                      //final locationId = locations.indexOf(location) + 1;
                      final location = locationData['placeName'];
                      final locationId = sortedLocationList[widget.pageIndex]
                              .places
                              .indexOf(locationData) +
                          1;

                      return Row(
                        children: [
                          OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              backgroundColor:
                                  _locationId == locationId.toString()
                                      ? const Color(0xff136750)
                                      : Colors.white,
                            ),
                            onPressed: () {
                              var locationCategoryList =
                                  sortedLocationList[widget.pageIndex]
                                      .places[locationId - 1]
                                          ['placeCategoryName']
                                      .toString()
                                      .split(">");
                              var locationCategory = locationCategoryList[
                                  max(0, locationCategoryList.length - 2)];
                              print(locationCategory);
                              locationClick(location, locationId.toString(),
                                  locationCategory.toString());
                            },
                            child: Text(
                              location,
                              style: TextStyle(
                                fontSize: 18,
                                color: _locationId == locationId.toString()
                                    ? Colors.white
                                    : const Color(0xff136750),
                              ),
                            ),
                          ),
                          const SizedBox(
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
          const SizedBox(
            height: 20,
          ),
          Row(
            children: [
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: TextFormField(
                  controller: _controller,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.yellow), // 테두리 색상 설정
                    ),
                    labelText: '방문한 장소가 없다면 추가해주세요!',
                    hintText: '장소 추가',
                  ),
                  onChanged: (value) {
                    setState(() {
                      textValue = value;
                    });
                  },
                  // validator: (value) {
                  //   if (value == null || value.isEmpty) {
                  //     return 'Enter your message to continue';
                  //   }
                  //   return null;
                  // },
                ),
              ),
              const SizedBox(width: 8),
              OutlinedButton(
                onPressed: () async {
                  setState(() {
                    sortedLocationList[widget.pageIndex].places.insert(0, {
                      'placeName': textValue,
                      'placeCategoryName': '기타장소>기타장소',
                      'placeCategoryGroupCode': 'FD6',
                      'placeCategoryCode': 'FD6',
                      'count': 1,
                      'timestamp': Timestamp.now(),
                    });
                    locations.insert(0, textValue); // textValue를 버튼 리스트에 추가
                    textValue = '';
                    _controller.clear(); // textValue 초기화
                  });

                  // if (_formKey.currentState!.validate()) {
                  //   await widget.addMessage(_controller.text);
                  //   _controller.clear();
                  // }
                },
                child: const Row(
                  children: [
                    Icon(Icons.send),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          const SizedBox(
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
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Column(
                        children: [
                          Ink(
                            decoration: ShapeDecoration(
                              color: _relationId == relationId.toString()
                                  ? const Color(0xff136750)
                                  : Colors.white,
                              shape: const CircleBorder(),
                            ),
                            child: IconButton(
                              icon: Icon(relation.icon),
                              color: _relationId == relationId.toString()
                                  ? Colors.white
                                  : const Color(0xff136750),
                              onPressed: () {
                                relationClick(
                                    relation.title, relationId.toString());
                              },
                            ),
                          ),
                          const SizedBox(
                            height: 6,
                          ),
                          Text(
                            relation.title,
                            style: const TextStyle(fontSize: 14),
                          )
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
          const SizedBox(
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
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Column(
                        children: [
                          Ink(
                            decoration: ShapeDecoration(
                              color: _activityId == activityId.toString()
                                  ? const Color(0xff136750)
                                  : Colors.white,
                              shape: const CircleBorder(),
                            ),
                            child: IconButton(
                              icon: Icon(activity.icon),
                              color: _activityId == activityId.toString()
                                  ? Colors.white
                                  : const Color(0xff136750),
                              onPressed: () {
                                activityClick(
                                    activity.title, activityId.toString());
                              },
                            ),
                          ),
                          const SizedBox(
                            height: 6,
                          ),
                          Text(
                            activity.title,
                            style: const TextStyle(fontSize: 14),
                          )
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
          const SizedBox(
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
                        padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                        decoration: const ShapeDecoration(
                          color: Colors.white70,
                          shape: CircleBorder(),
                        ),
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            backgroundColor: _feelingId == feelingId.toString()
                                ? const Color(0xff136750)
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
                                  : const Color(0xff136750),
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
          const SizedBox(
            height: 50,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  backgroundColor: Colors.white,
                ),
                onPressed: () {
                  if (widget.pageIndex != 0) {
                    // 첫 페이지(기본 페이지)만 두고 모두 닫고, 탭 하나 열기
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              GenerateDiary(dataList: widget.dataList),
                        ),
                        (route) => route.isFirst);
                  }
                },
                child: const Text(
                  "건너뛰기",
                  style: TextStyle(fontSize: 18, color: Color(0xff136750)),
                ),
              ),
              const SizedBox(
                width: 30,
              ),
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  backgroundColor: Colors.white,
                ),
                onPressed: () {
                  UserForm userForm = UserForm(
                      location: _location,
                      category: _category,
                      relation: _relation,
                      activity: _activity,
                      userState: _feeling);
                  dataList = [...widget.dataList, userForm];
                  if (widget.pageIndex < min(2, locationList.length - 1)) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Ai_WriteDiary(
                          pageIndex: widget.pageIndex + 1,
                          dataList: dataList,
                        ),
                      ),
                    );
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => GenerateDiary(dataList: dataList),
                      ),
                    );
                  }

                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (context) => GenerateDiary(data: userForm)));
                },
                child: const Text(
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
  var _category = "";
  var _relation = "";
  var _activity = "";
  var _feeling = "";
  var _locationId = "";
  var _relationId = "";
  var _activityId = "";
  var _feelingId = "";
  var _question = "";
  String textValue = '';

  AskingQuestion() {
    if (_location == "") {
      _question = "장소를 선택해주세요!";
    } else {
      _question = "$_location에서 무엇을 하셨나요?";
    }
    return _question;
  }

  void locationClick(text, id, category) {
    setState(() {
      _location = text; // 버튼 클릭 시 변수에 값을 저장
      _category = category; // 버튼 클릭 시 변수에 값을 저장
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

  PageController pageController = PageController();
  List<String> userLocations = [];
  final List<String> locations = ['스타벅스', '투썸 플레이스', '삼성 내과 의원'];
  List<String> feelingTexts = ['즐겁다', '슬프다', '힘들다', '평범하다', '지쳤다', '최고다'];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _aiKeywordsForm(),
      //     body: PageView.builder(itemBuilder: (BuildContext context, int index) {
      //   return _aiKeywordsForm();
      // }
      // )
    );
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
  final String category;
  final String relation;
  final String activity;
  final String userState;

  UserForm({
    required this.location,
    required this.category,
    required this.relation,
    required this.activity,
    required this.userState,
  });

  String getHashTags() {
    return '#$relation #$activity #$userState';
  }

  String getLocation() {
    return location;
  }

  @override
  String toString() {
    return 'UserForm{location: $location, relation: $relation, activity: $activity, userState: $userState}';
  }
}
