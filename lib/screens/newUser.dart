import 'package:flutter/material.dart';
class newUser extends StatefulWidget {
  const newUser({Key? key}) : super(key: key);

  @override
  State<newUser> createState() => _UserForm();
}

class _UserForm extends State<newUser> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.fromLTRB(30.0, 40.0, 30.0, 0.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
              Text('추가 정보를 입력해주시면 더 상세한 그림을 그릴 수 있어요!',
                  style: TextStyle(
                    color: Colors.black38,
                    letterSpacing: 2.0,
                    // + 폰트 설정
                  ),
              ),
            SizedBox(height: 20),
            Text('이름?',
            style: TextStyle(
              color: Colors.black38,
              letterSpacing: 2.0,
              ),
            ),

          ],
        ),
      )
    );
  }
}