import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:sumday/screens/mainPage.dart';
import 'package:sumday/signIn.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sumday/main.dart';
import 'package:sumday/signIn.dart';
import 'package:sign_button/sign_button.dart';
import 'package:provider/provider.dart';
import 'package:sumday/providers/loginProvider.dart';
import 'package:google_sign_in/google_sign_in.dart';
// import 'home.dart';
import 'package:sumday/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:permission_handler/permission_handler.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  Future<bool> permission() async {
    Map<Permission, PermissionStatus> status =
    await [Permission.location].request(); // [] 권한배열에 권한을 작성

    if (await Permission.location.isGranted) {
      return Future.value(true);
    } else {
      return Future.value(false);
    }
  }


  @override
  Widget build(BuildContext context) {
    LoginProvider loginProvider = Provider.of(context, listen: true);
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 200.0),
            Image.asset(
              "assets/main_logo.png",
              width: 300,
              height: 300,
            ),
            SizedBox(height: 10.0),
            OutlinedButton.icon(
              onPressed: () async {
                bool hasPermission = await permission(); // 위치 권한 요청

                if (hasPermission) {
                  try {
                    await loginProvider.signInWithGoogle(); // 구글 로그인
                    print("Google Login Success!!");
                    Navigator.pushNamed(context, '/home');
                  } catch (e) {
                    if (e is FirebaseAuthException) {
                      print(e.message!);
                    }
                  }
                } else {
                  print('위치 권한이 필요합니다.');
                }
              },
              style: OutlinedButton.styleFrom(
                side: BorderSide(width: 2, color: Color(0xFFF4C54F)),
                fixedSize: const Size(300, 55),
                backgroundColor: Colors.white,
              ),
              label: Text(
                "Google로 로그인 하기",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Color(0xFFF4C54F),
                ),
              ),
              icon: Image.asset(
                "assets/google.png",
                height: 30,
                width: 30,
              ),
            ),
            OutlinedButton(
              onPressed: () async {
                bool hasPermission = await permission(); // 위치 권한 요청
                if (hasPermission) {
                  try {
                    await loginProvider.signInWithAnonymous(); // 익명 로그인
                    print("Anonymous Login Success!!");
                    Navigator.pushNamed(context, '/home');
                  } catch (e) {
                    if (e is FirebaseAuthException) {
                      print(e.message!);
                    }
                  }
                } else {
                  print("위치 권한이 필요합니다."); // 위치 권한이 없는 경우 처리
                }
              },
              child: Text(
                '익명 로그인',
                style: TextStyle(
                  color: Color(0xFFF4C54F),
                ),
              ),
            ),
            // OutlinedButton(onPressed: () async{
            //   try {
            //     await loginProvider.signInWithAnonymous(); // 구글 로그인
            //     print("Anonymous Login Success!!");
            //
            //     Navigator.pushNamed(context, '/home');
            //   } catch (e) {
            //     if (e is FirebaseAuthException) {
            //       print(e.message!);
            //     }
            //   }
            //   Navigator.pushNamed(context, '/home');
            // },
            //     child: Text('익명 로그인',
            //       style: TextStyle(
            //         color: Color(0xFFF4C54F), // 여기에 색상을 추가하세요
            //       ),
            //     ),
            // ),
          ],
        ),
      ),
    );
  }

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    //return await FirebaseAuth.instance.signInWithCredential(credential);
    UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);
    User user = userCredential.user!;

    //assert(userCredential.user!.isAnonymous);
    assert(!user.isAnonymous);

    //assert(userCredential.user!.getIdToken() != null);
    return userCredential;
  }
}