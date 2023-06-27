import 'package:sumday/screens/ai_writeDiary.dart';
// diary_model을 다른 용도로 사용하고 있음..

class Diary {
  String userID;
  List<String> context, tags, photos;
  DateTime date;
  bool favorite;

  Diary({
    required this.userID,
    required this.date,
    required this.tags,
    required this.photos,
    required this.context,
    required this.favorite,
  });

  Diary.fromJson(Map<String, dynamic> json)
      : userID = json['userID'],
        date = json['date'].toDate(),
        tags = json['tags'].cast<String>(),
        context = json["context"].cast<String>(),
        photos = json["photos"].cast<String>(),
        favorite = json['favorite'];

  Map<String, dynamic> toJson() => {
        "userID": userID,
        "date": date,
        "tags": tags,
        "context": context,
        "photos": photos,
        "favorite": favorite,
      };

  List<String> getCurrTags(int index) {
    return tags.sublist(4 * index, 4 * index + 4);
  }

  String joinWithHash(List<String> list) {
    return list.map((item) => '#$item').join(' ');
  }

  // List<UserForm> -> List<String>
  static List<String> listConverter(List<UserForm> userForms) {
    List<String> convertedList = [];
    for (var userForm in userForms) {
      convertedList.addAll([
        userForm.location,
        userForm.relation,
        userForm.activity,
        userForm.userState,
      ]);
    }
    return convertedList;
  }
}
