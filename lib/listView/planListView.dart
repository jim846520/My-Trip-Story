import 'package:flutter/material.dart';

class PlanListView extends StatefulWidget {
  const PlanListView({Key? key}) : super(key: key);

  @override
  _PlanListViewState createState() => _PlanListViewState();
}

class _PlanListViewState extends State<PlanListView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('일정'),
      ),
      drawer: Drawer(
        child: ListView(
          children: const [
            UserAccountsDrawerHeader(
              // currentAccountPicture: CircleAvatar(
              //   backgroundImage: AssetImage('images/populationIcon.png'),
              // ),
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
      body: Center(
        child: Column(),
      ),
    );
  }
}
