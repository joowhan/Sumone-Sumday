import 'package:cloud_firestore/cloud_firestore.dart';

void exchangeDiaryInviteApi(var diaryId, var uid) {
  // 다이어리 초대
  var diaryListRef = FirebaseFirestore.instance
      .collection('exchangeDiaryList')
      .doc(diaryId)
      .collection('invite')
      .doc(uid)
      .set(<String, dynamic>{
    'uid': uid,
  });
}
