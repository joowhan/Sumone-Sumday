import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';

enum SignInState {
  signedIn,
  signedOut,
  start,
}

class SignInController extends GetxController {
  final FirebaseAuth fAuth = FirebaseAuth.instance;

  SignInState signInState = SignInState.start;

  late int num;

  late String id;
  late String pw;

  // 비밀번호 재설정 시 필요한 변수
  late String email;

  // 자동 로그인 시 필요한 변수
  String? userInfo = "";
  static final storage = new FlutterSecureStorage();

  void signedStart() {
    signInState = SignInState.start;
    update();
  }

  void signedInState() {
    signInState = SignInState.signedIn;
    update();
  }

  void signedOutState() {
    signInState = SignInState.signedOut;
    update();
  }

  @override
  onInit() {
    super.onInit();
    num = 5;
    WidgetsBinding.instance.addPostFrameCallback(
          (_) {
        _asyncMethod();
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  void reset() {
    id = "";
    pw = "";
    fAuth.signOut();
  }

  _asyncMethod() async {
    // 데이터 없을 경우 null 반환
    userInfo = await storage.read(key: "login");
    // UserInfo 값 확인

    // user 정보가 있을 경우 바로 main으로 넘어가게 함
    if (userInfo != null) {
      id = userInfo!.split(" ")[1];
      pw = userInfo!.split(" ")[3];
      signIn();
    } else {
      signedOutState();
      update();
    }
  }

  Future<void> signIn() async {
    num = 5;
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(
          email: id, password: pw) //아이디와 비밀번호로 로그인 시도
          .then((value) {
        value.user!.emailVerified == true //이메일 인증 여부
            ? {
          signedInState(),
          update(),
        }
            : {
          num = 0,
          update(),
        };
        // : throw Exception('이메일 확인 안됨');
        return value;
      });
    } on FirebaseAuthException catch (e) {
      //로그인 예외처리
      if (e.code == 'user-not-found') {
        num = 1;
        update();
        // throw Exception('등록되지 않은 이메일입니다');
      } else if (e.code == 'wrong-password') {
        num = 2;
        update();
        // throw Exception('비밀번호가 틀렸습니다');
      } else if (e.code == 'network-request-failed') {
        num = 3;
        update();
      } else {
        print(e.code);
        num = 4;
        update();
        // throw Exception(e.code);
      }
    }
  }

  // 사용자에게 비밀번호 재설정 메일을 한글로 전송 시도
  sendPasswordResetEmailByKorean() async {
    await FirebaseAuth.instance.setLanguageCode("ko");
    sendPasswordResetEmail();
  }

  // 사용자에게 비밀번호 재설정 메일을 전송
  sendPasswordResetEmail() async {
    FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  }

  // 회원탈퇴
  deleteUser() async {
    User? user = FirebaseAuth.instance.currentUser;
    user!.delete();
    signedOutState();
    update();
  }

}