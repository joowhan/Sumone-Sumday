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
          padding: const EdgeInsets.fromLTRB(30.0, 40.0, 30.0, 0.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text(
                '추가 정보를 입력해주시면 더 상세한 그림을 그릴 수 있어요!',
                style: TextStyle(
                  color: Colors.black38,
                  letterSpacing: 2.0,
                  // + 폰트 설정
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                '이름?',
                style: TextStyle(
                  color: Colors.black38,
                  letterSpacing: 2.0,
                ),
              ),
              Form(
                child: ListView(
                  children: <Widget>[
                    TextFormField(
                      decoration: const InputDecoration(labelText: '이름'),
                      textInputAction: TextInputAction.next,
                    ),
                    TextFormField(
                      decoration: const InputDecoration(labelText: '성별'),
                      textInputAction: TextInputAction.next,
                    ),
                    TextFormField(
                      decoration: const InputDecoration(labelText: '생일'),
                      textInputAction: TextInputAction.next,
                    )
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
