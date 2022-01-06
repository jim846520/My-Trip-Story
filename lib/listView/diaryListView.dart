import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:team129_app/database_handler.dart';
import 'package:team129_app/database_handler_diary.dart';
import 'package:team129_app/write/addDiary.dart';

class DiaryListView extends StatefulWidget {
  const DiaryListView({Key? key}) : super(key: key);

  @override
  _DiaryListViewState createState() => _DiaryListViewState();
}

class _DiaryListViewState extends State<DiaryListView> {
 // All journals
  List<Map<String, dynamic>> _journals = [];

  bool _isLoading = true;

  // 데이터베이스에서 모든 데이터를 가져올 때 사용
  void _refreshJournals() async {
    final data = await SQLDiary.getDiary();
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
  PickedFile? _image;

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
    showModalBottomSheet(
        context: context,
        elevation: 5,
        isScrollControlled: true,
        builder: (_) => Container(
              padding: EdgeInsets.only(
                top: 15,
                left: 15,
                right: 15,
                // this will prevent the soft keyboard from covering the text fields
                bottom: MediaQuery.of(context).viewInsets.bottom + 120,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  TextField(
                    controller: _titleController,
                    decoration: const InputDecoration(hintText: '제목을 입력하세요.'),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    controller: _contentsController,
                    decoration:
                        const InputDecoration(hintText: '여행 일정을 기록하세요.'),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      // Save new journal
                      if (id == null) {
                        await _addDiary();
                      }

                      if (id != null) {
                        await _updateDiary(id);
                      }

                      // Clear the text fields
                      _titleController.text = '';
                      _contentsController.text = '';

                      // Close the bottom sheet
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      id == null ? '등록하기' : '수정하기',
                      style: const TextStyle(color: Colors.white),
                    ),
                  )
                ],
              ),
            ));
  }

// Insert a new journal to the database
  Future<void> _addDiary() async {
    await SQLDiary.createDiary(_titleController.text, _contentsController.text, _image);
    _refreshJournals();
  }

  // Update an existing journal
  Future<void> _updateDiary(int id) async {
    await SQLDiary.updateDiary(
        id, _titleController.text, _contentsController.text, _image);
    _refreshJournals();
  }

  // Delete an item
  void _deleteDiary(int id) async {
    await SQLDiary.deleteDiary(id);
    _showDialog(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Text('Diary'),
        elevation: 0, // appbar 밑에 그림자 제거
        actions: [
          IconButton(
            onPressed: () => _showForm(null),
            icon: const Icon(Icons.add),
          ),
          IconButton(
            onPressed: (){
              //-----
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: const [
            UserAccountsDrawerHeader(
              currentAccountPicture: CircleAvatar(
                backgroundImage: AssetImage('images/smile.png'),
              ),
              accountName: Text('129'),
              accountEmail: Text('team129@gmail.com'),
            ),
            ListTile(
              leading: Icon(
                Icons.airplanemode_active,
                color: Colors.black,
              ),
              title: Text('여행일정'),
            ),
            ListTile(
              leading: Icon(
                Icons.brush,
                color: Colors.black,
              ),
              title: Text('여행일기'),
            ),
            ListTile(
              leading: Icon(
                Icons.fmd_good_rounded,
                color: Colors.black,
              ),
              title: Text('세계지도 (추가 예정)'),
            ),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: _journals.length,
              itemBuilder: (context, index) => Card(
                color: Colors.white,
                margin: const EdgeInsets.all(15),
                child: ListTile(
                    title: Text(_journals[index]['title']),
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
                            onPressed: () => _showForm(_journals[index]['id']),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.redAccent,
                            ),
                            onPressed: () =>
                                _deleteDiary(_journals[index]['id']),
                          ),
                        ],
                      ),
                    )),
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
              child: const Text('확인'),
            ),
          ],
        );
      },
    );
  }
} // >>> END <<<