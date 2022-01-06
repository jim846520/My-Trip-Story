import 'package:flutter/material.dart';

class DiaryListView extends StatefulWidget {
  const DiaryListView({Key? key}) : super(key: key);

  @override
  _DiaryListViewState createState() => _DiaryListViewState();
}

class _DiaryListViewState extends State<DiaryListView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('일기'),
      ),
      body: Center(
        child: Column(),
      ),
    );
  }
}
