// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:sumday/models/diary_model.dart';
// import 'package:intl/intl.dart';

// import 'package:sumday/models/diary_model.dart';
// import 'package:sumday/models/diary_data.dart';



// class DiaryListpage extends StatelessWidget {
//   const DiaryListpage({Key? key}) : super(key: key);

// // Replace this entire method
//   List<Card> _buildGridCards(BuildContext context) {
//     List<Diary> diaries = DiariesRepository.loadDiaries();

//     String _formattedDate(DateTime time) =>
//         DateFormat('yyyy-MM-dd').format(time);

//     String _joinWithHash(List<String> list) {
//       return list.map((item) => '#$item').join(' ');
//     }

//     if (diaries.isEmpty) {
//       return const <Card>[];
//     }

//     final ThemeData theme = Theme.of(context);

//     return diaries.map((diary) {
//       return Card(
//         clipBehavior: Clip.antiAlias,
//         child: Padding(
//           padding: const EdgeInsets.fromLTRB(0, 4, 0, 0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: <Widget>[
//               AspectRatio(
//                 aspectRatio: 18 / 11,
//                 child: Image.asset(
//                   'assets/${diary.assetName}',
//                 ),
//               ),
//               Expanded(
//                 child: Padding(
//                   padding: const EdgeInsets.fromLTRB(14.0, 12.0, 14.0, 8.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: <Widget>[
//                       Text(
//                         _joinWithHash(diary.tags),
//                         style: TextStyle(
//                             color: Colors.purple.shade400,
//                             fontSize: 14,
//                             fontWeight: FontWeight.w600),
//                         maxLines: 1,
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                       const SizedBox(height: 12.0),
//                       Text(
//                         _formattedDate(diary.date),
//                         style: theme.textTheme.titleSmall,
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       );
//     }).toList();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: GridView.count(
//         crossAxisCount: 2,
//         crossAxisSpacing: 10,
//         mainAxisSpacing: 10,
//         padding: const EdgeInsets.all(16.0),
//         childAspectRatio: 8.0 / 9.0,
//         children: _buildGridCards(context),
//       ),
//       resizeToAvoidBottomInset: false,
//     );
//   }
// }
