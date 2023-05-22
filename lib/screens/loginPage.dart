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

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    LoginProvider loginProvider = Provider.of(context, listen: true);
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 200.0),
            Text(
              "SUMDAY",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 50,
                  color: Color(0xff326295)),
            ),
            SizedBox(height: 50.0),
            Image.asset("assets/day_night.png", width: 250, height: 250,),
            SizedBox(height: 80.0),
            OutlinedButton.icon(
              onPressed: () async {
                try {
                  await loginProvider.signInWithGoogle(); // 구글 로그인
                  print("Google Login Success!!");
                  //SignInController().signIn();
                  await signInWithGoogle();
                  print("Google Login Success!!");
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //       builder: (context) => Home()),
                  // );
                  Navigator.pushNamed(context, '/home');

                } catch(e) {
                  if (e is FirebaseAuthException) {
                    print(e.message!);
                  }
                }
                Navigator.pushNamed(context, '/home');
              },
              style: OutlinedButton.styleFrom(
                side: BorderSide(width: 2, color: Color(0xff326295)),
                fixedSize: const Size(300, 55),
                backgroundColor: Colors.white,
              ),
              label: Text(
                "Google로 로그인 하기",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Color(0xff326295)),
              ),
              icon: Image.asset(
                "assets/google.png",
                height: 30,
                width: 30,

                //color: Colors.white,
              ),
            ),

          ],
        ),
      ),
    );
  }
  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    //return await FirebaseAuth.instance.signInWithCredential(credential);
    UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
    User user = userCredential.user!;

    //assert(userCredential.user!.isAnonymous);
    assert(!user.isAnonymous);

    //assert(userCredential.user!.getIdToken() != null);
    return userCredential;
  }
}
