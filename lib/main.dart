import 'package:flutter/material.dart';
import 'package:team129_app/listView/diaryListView.dart';
import 'package:team129_app/listView/planListView.dart';
import 'package:team129_app/tabbarPage.dart';
import 'package:team129_app/write/planWrite.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // 왼쪽 상단의 debug 뱃지 제거
      theme: ThemeData(
        primarySwatch: Colors.cyan,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) {
          return const TabbarPage();
        },
        '/planListView': (context) {
          return const PlanListView();
        },
        '/diaryListView': (context) {
          return const DiaryListView();
        },
        '/planWrite': (context) {
          return const PlanWrite();
        },
      },
    );
  }
}
