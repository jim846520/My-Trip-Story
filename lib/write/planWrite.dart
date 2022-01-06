import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PlanWrite extends StatefulWidget {
  const PlanWrite({Key? key}) : super(key: key);

  @override
  _PlanWriteState createState() => _PlanWriteState();
}

class _PlanWriteState extends State<PlanWrite> {
  TextEditingController inputTitleController =
      TextEditingController(); // 사용자가 입력하는 제목
  TextEditingController inputContentsController =
      TextEditingController(); // 사용자가 입력하는 내용

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.grey[300],
        appBar: AppBar(
          title: const Text('일정 메모'),
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                Container(
                  height: 50,
                  margin: const EdgeInsets.fromLTRB(20, 50, 20, 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: Colors.white,
                  ),
                  child: CupertinoTextField(
                    controller: inputTitleController,
                    placeholder: '제목을 입력하세요.',
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.text,
                  ),
                ),
                Container(
                  height: 500, 
                  margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                  decoration: BoxDecoration( 
                    borderRadius: BorderRadius.circular(100),
                    color: Colors.white,
                  ),
                  child: CupertinoTextField(
                    controller: inputContentsController,
                    placeholder: '여행 일정을 기록하세요.',
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.text,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    // -----
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.cyan,
                    shape: RoundedRectangleBorder(
                      // 모서리 모양
                      borderRadius: BorderRadius.circular(20.0), // 모서리 모양 둥글게
                    ),
                  ),
                  child: Container(
                    width: 160,
                    height: 40,
                    alignment: Alignment.center,
                    child: const Text(
                      '저장하기',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
