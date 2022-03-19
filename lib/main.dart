import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'locations.dart';
import 'meters/meters.dart';

void main() {
  runApp(const MeterTracker());
}

class MeterTracker extends StatelessWidget {
  const MeterTracker({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class PageListObject {
  String title;
  Widget page;

  PageListObject({required this.title, required this.page});
}

class _HomePageState extends State<HomePage> {
  int _selectedPage = 0;
  PageListObject _selectedWidget = _widgetOptions.elementAt(0);

  void _onItemTapped(int index) {
    setState(() {
      if (index == _widgetOptions.length) {
        index = 0;
      }
      _selectedPage = index;
      _selectedWidget = _widgetOptions.elementAt(_selectedPage);
    });
  }

  static final List<PageListObject> _widgetOptions = <PageListObject>[
    PageListObject(title: "Locations", page: const Locations()),
    PageListObject(title: "Meters", page: const Meters()),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_selectedWidget.title),
      ),
      body: Center(
        child: _selectedWidget.page,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Locations',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: 'Meters',
          ),
        ],
        currentIndex: _selectedPage,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}
