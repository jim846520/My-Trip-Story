import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddDiary extends StatefulWidget {
  const AddDiary({ Key? key }) : super(key: key);

  @override
  _AddDiaryState createState() => _AddDiaryState();
}

class _AddDiaryState extends State<AddDiary> {
  TextEditingController inputTitleController =
      TextEditingController(); // 사용자가 입력하는 제목
  TextEditingController inputContentsController =
      TextEditingController(); // 사용자가 입력하는 내용
  PickedFile? picture; // 이미지를 가져오기

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
          actions: [
            ElevatedButton(
              onPressed: getImageFromGallery, 
              child: Icon(Icons.add_a_photo))
          ],
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                SizedBox(
                  height: 50,
                ),
                    Container(
                  height: 150,
                  margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.white,
                    ),
                    child: Center(
                      child: picture == null
                      ? const Text('사진을 등록해 주세요')
                      : Image.file(File(picture!.path)),
                    ),
                ),
                Container(
                  height: 50,
                  margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
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
                  height: 300,
                  margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: Colors.white,
                  ),
                  child: CupertinoTextField(
                    controller: inputContentsController,
                    placeholder: '입력',
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.multiline, // 줄 바꾸기
                    maxLines: null, // 글자 수 제한 조건
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
  Future getImageFromGallery() async{
    var image = await ImagePicker.platform.pickImage(source: ImageSource.gallery);
    setState(() {
      picture = image;
    });
  }
}
