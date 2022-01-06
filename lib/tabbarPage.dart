import 'package:flutter/material.dart';
import 'package:team129_app/listView/diaryListView.dart';
import 'package:team129_app/listView/planListView.dart';

class TabbarPage extends StatefulWidget {
  const TabbarPage({Key? key}) : super(key: key);

  @override
  _TabbarPageState createState() => _TabbarPageState();
}

class _TabbarPageState extends State<TabbarPage>
    with SingleTickerProviderStateMixin {
  late TabController controller; 

  @override
  void initState() {
    super.initState();
    controller = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TabBarView(
        controller: controller,
        children: const [PlanListView(), DiaryListView()],
      ),
      bottomNavigationBar: Container(
        color: Colors.cyan, // 탭바 색깔
        height: 80,
        child: TabBar(
          indicatorColor: Colors.white, // 탭바 맨 밑에 이동 표시 막대 색깔
          indicatorWeight: 3, // 이동 표시 막대 두께
          indicatorSize: TabBarIndicatorSize.label, // 이동 표시 막대 사이즈 : 글씨 길이만큼
          labelColor: Colors.white, // 글자 색깔
          controller: controller,
          tabs: const [
            Tab(
              icon: Icon(
                Icons.airplanemode_active,
                color: Colors.white,
              ),
              text: '여행일정',
            ),
            Tab(
              icon: Icon(
                Icons.brush,
                color: Colors.white,
              ),
              text: '여행일기',
            ),
          ],
        ),
      ),
    );
  }
}
