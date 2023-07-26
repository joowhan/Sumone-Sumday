// Copyright 2018-present the Flutter authors. All Rights Reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import 'dart:core';
import 'package:cloud_firestore/cloud_firestore.dart';

/*
로그인 provider
 */
class LoginProvider with ChangeNotifier {
  LoginProvider() {
    init();
  }

  Future<void> init() async {
    await Firebase.initializeApp();
  }

  StreamSubscription<QuerySnapshot>? _userSubscription;
  UserInformation? _userInformation;
  UserInformation? get userInformation => _userInformation;

  String? _userName;
  String? get userName => _userName;

  Future<void> downloadUserInfo(User? user) async {
    // 구글 로그인 유저 정보 다운로드
    FirebaseFirestore.instance
        .collection('user')
        .doc(user!.uid)
        .get()
        .then((value) {
      _userInformation = UserInformation(
        email: value.data()!['email'] as String,
        name: value.data()!['name'] as String,
        statusMessage: value.data()!['status_message'] as String,
        uid: value.data()!['uid'] as String,
        profileUrl: value.data()!['profileUrl'] as String,
      );
    });
    notifyListeners();
  }

  // Future<void> performLogout() async {
  //   await FirebaseAuth.instance.signOut();
  // }

  Future<void> downloadAnonymousInfo(User? user) async {
    // 익명 유저 정보 다운로드
    FirebaseFirestore.instance
        .collection('user')
        .doc(user!.uid)
        .get()
        .then((value) {
      _userInformation = UserInformation(
        email: "sumday@gmail.com",
        name: "sumone",
        statusMessage: value.data()!['status_message'] as String,
        uid: value.data()!['uid'] as String,
        profileUrl: "https://img.freepik.com/free-icon/user_318-749758.jpg",
      );
    });
    notifyListeners();
  }

  Future<UserCredential> signInWithGoogle() async {
    // 구글 로그인
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      User? user = userCredential.user;

      _userName = user!.displayName;

      addUserInfo(user);
      downloadUserInfo(user);
      // FirebaseAuth.instance.setPersistence(Persistence.LOCAL);
      notifyListeners();
      return userCredential;
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<void> signOut() async {
    // 로그아웃
    await GoogleSignIn().signOut();
    await FirebaseAuth.instance.signOut();
    notifyListeners();
  }

  Future<User?> signInWithAnonymous() async {
    // 익명 로그인
    try {
      UserCredential result = await FirebaseAuth.instance.signInAnonymously();
      User? user = result.user;
      addAnonymousInfo(user);
      downloadAnonymousInfo(user);
      _userName = "Guest";
      // FirebaseAuth.instance.setPersistence(Persistence.LOCAL);
      notifyListeners();
      return user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<void>? addUserInfo(User? user) async {
    // 새로운 구글 로그인 유저 등록
    var document = await FirebaseFirestore.instance
        .collection('user')
        .doc(user!.uid)
        .get()
        .then((doc) {
      if (doc.exists) {
        print('already exists'); // 이미 존재하는 유저이면 새로 추가 X
      } else {
        return FirebaseFirestore.instance
            .collection('user')
            .doc(user.uid)
            .set(<String, dynamic>{
          'email': user.email,
          'name': user.displayName,
          'status_message': "someday, someone",
          'uid': user.uid,
          'profileUrl': user.photoURL,
        });
      }
    });
    notifyListeners();
  }

  Future<void> addAnonymousInfo(User? user) {
    // 익명 유저 추가
    return FirebaseFirestore.instance
        .collection('user')
        .doc(user!.uid)
        .set(<String, dynamic>{
      'status_message': "sumday is all you need",
      'uid': user.uid,
    });
    // notifyListeners();
  }

  Future<void> updateAnonymousInfo(User? user) {
    // 익명 유저 추가
    return FirebaseFirestore.instance
        .collection('user')
        .doc(user!.uid)
        .update(<String, dynamic>{
      'status_message': "New sumday user.",
      'uid': user.uid,
    });
    // notifyListeners();
  }
}

class UserInformation {
  // 유저 정보 저장하는 구조체 (수정 필요)
  UserInformation(
      {required this.email,
      required this.name,
      required this.statusMessage,
      required this.uid,
      required this.profileUrl});
  final String email;
  final String name;
  final String statusMessage;
  final String uid;
  final String profileUrl;
}
