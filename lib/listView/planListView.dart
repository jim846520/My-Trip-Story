import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:team129_app/database_handler.dart';

class PlanListView extends StatefulWidget {
  const PlanListView({Key? key}) : super(key: key);

  @override
  _PlanListViewState createState() => _PlanListViewState();
}

class _PlanListViewState extends State<PlanListView> {
// All journals
  List<Map<String, dynamic>> _journals = [];

  bool _isLoading = true;

  // 데이터베이스에서 모든 데이터를 가져올 때 사용
  void _refreshJournals() async {
    final data = await SQLHelper.getItems();
    setState(() {
      _journals = data;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _refreshJournals(); // 앱 시작 시 모든 데이터를 가져옴
  }

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentsController = TextEditingController();

// 플러스 버튼 누를 때 실행
  void _showForm(int? id) async {
    if (id != null) {
      // id == null -> 새로운 항목을 만듦
      // id != null -> 기존에 있는 항목 업데이트함
      final existingJournal =
          _journals.firstWhere((element) => element['id'] == id);
      _titleController.text = existingJournal['title'];
      _contentsController.text = existingJournal['contents'];
    }

    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        // 여기 ctx(context)는 Alert부분
        return AlertDialog(
          title: const Text('일정'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _titleController,
                decoration: InputDecoration(labelText: '제목을 입력하세요.'),
                textAlign: TextAlign.center,
                keyboardType: TextInputType.text,
              ),
              TextField(
                controller: _contentsController,
                decoration: InputDecoration(labelText: '내용을 입력하세요.'),
                textAlign: TextAlign.center,
                keyboardType: TextInputType.multiline, // 줄 바꾸기
                maxLines: null, // 글자 수 제한 조건
              ),
            ],
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
              child: ElevatedButton(
                onPressed: () async {
                  // Save new journal
                  if (id == null) {
                    await _addItem();
                  }

                  if (id != null) {
                    await _updateItem(id);
                  }

                  // Clear the text fields
                  _titleController.text = '';
                  _contentsController.text = '';

                  // Close the bottom sheet
                  Navigator.of(context).pop();
                },
                child: Text(
                  id == null ? '저장' : '수정',
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w500),
                ),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.cyan),
                ),
              ),
            )
          ],
        );
      },
    );
  }

// Insert a new journal to the database
  Future<void> _addItem() async {
    await SQLHelper.createItem(_titleController.text, _contentsController.text);
    _refreshJournals();
  }

  // Update an existing journal
  Future<void> _updateItem(int id) async {
    await SQLHelper.updateItem(
        id, _titleController.text, _contentsController.text);
    _refreshJournals();
  }

  // Delete an item
  void _deleteItem(int id) async {
    await SQLHelper.deleteItem(id);
    _showDialog(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Text('My Trip Story'),
        elevation: 0, // appbar 밑에 그림자 제거
        actions: [
          IconButton(
            onPressed: () => _showForm(null),
            icon: Image(
              image: AssetImage('images/add1.png'),
              width: 25,
              height: 25,
            ),
          ),
        ],
      ),
      // drawer: Drawer(
      //   child: ListView(
      //     children: const [
      //       UserAccountsDrawerHeader(
      //         currentAccountPicture: CircleAvatar(
      //           backgroundImage: AssetImage('images/smile.png'),
      //         ),
      //         accountName: Text('129'),
      //         accountEmail: Text('team129@gmail.com'),
      //       ),
      //       ListTile(
      //         leading: Icon(
      //           Icons.airplanemode_active,
      //           color: Colors.black,
      //         ),
      //         title: Text('여행일정'),
      //       ),
      //       ListTile(
      //         leading: Icon(
      //           Icons.brush,
      //           color: Colors.black,
      //         ),
      //         title: Text('여행일기'),
      //       ),
      //       ListTile(
      //         leading: Icon(
      //           Icons.fmd_good_rounded,
      //           color: Colors.black,
      //         ),
      //         title: Text('세계지도 (추가 예정)'),
      //       ),
      //     ],
      //   ),
      // ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: _journals.length,
              itemBuilder: (context, index) => Card(
                color: Colors.white,
                margin: const EdgeInsets.fromLTRB(15, 15, 15, 0),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: ListTile(
                      title: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                        child: Text(
                          _journals[index]['title'],
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.bold),
                        ),
                      ),
                      subtitle: Text(_journals[index]['contents']),
                      trailing: SizedBox(
                        width: 100,
                        child: Row(
                          children: [
                            IconButton(
                              icon: const Icon(
                                Icons.edit,
                                color: Colors.blueAccent,
                              ),
                              onPressed: () =>
                                  _showForm(_journals[index]['id']),
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.redAccent,
                              ),
                              onPressed: () =>
                                  _deleteItem(_journals[index]['id']),
                            ),
                          ],
                        ),
                      )),
                ),
              ),
            ),
    );
  }

// 일정 삭제 눌렀을 때 Dialog
  _showDialog(BuildContext context) {
    // 여기 context는 메인
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        // 여기 ctx(context)는 Alert부분
        return AlertDialog(
          title: const Text('삭제'),
          content: const Text('해당 일정을 삭제하시겠습니까?'),
          actions: [
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  backgroundColor: Colors.redAccent,
                  content: Text('삭제가 완료 되었습니다.'),
                ));
                _refreshJournals();
                Navigator.of(ctx).pop();
              },
              child: const Text(
                '확인',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }
} // >>> END <<<
