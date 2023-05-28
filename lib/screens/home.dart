import 'package:flutter/material.dart';
import 'package:sumday/screens/get_place_test.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        children: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PlaceTest(),
                ),
              );
            },
            icon: const Icon(Icons.navigation),
          ),
        ],
      ),
    ));
  }
}
