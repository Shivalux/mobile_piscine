import 'package:flutter/material.dart';
import 'dart:io' show Platform;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App',
      theme: ThemeData(),
      home: const WeatherApp(title: 'Weather App'),
    );
  }
}

class WeatherApp extends StatefulWidget {
  const WeatherApp({super.key, required this.title});
  final String title;

  @override
  State<WeatherApp> createState() => _WeatherAppState();
}

class _WeatherAppState extends State<WeatherApp> with TickerProviderStateMixin {
  late TabController _tabController;
  static const List<Map<String, dynamic>> _weatherTabs = [
    {'text': 'Currently', 'icon': Icons.settings, },
    {'text': 'Today', 'icon': Icons.today, },
    {'text': 'Weekly', 'icon': Icons.calendar_month, },
  ];
  
  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
  final bottomInset = MediaQuery.of(context).padding.bottom;
    return Scaffold(
      backgroundColor: const Color(0xFF000000),
      appBar: AppBar(
        backgroundColor: const Color(0xFF5b5d72),
        title: TextField(
          onTapUpOutside: (event) {
            FocusScope.of(context).unfocus();
          },
          keyboardType: TextInputType.text,
          onChanged: (text) {},
          cursorColor: Colors.white,
          maxLines: 1,
          decoration: InputDecoration(
            icon: const Icon(Icons.search),
            iconColor: const Color(0xFFb1b3bc),
            hintText: 'Search location...',
            hintStyle: TextStyle(
              color: const Color(0xFFb1b3bc),
            ),
          ),
          style: TextStyle(
            color: Color(0xFFFFFFFF),
            fontSize: 17,
          ),
        ),
        actions: <Widget>[
          Text(
            '|',
            style: TextStyle(
              color: Color(0xFFFFFFFF),
              fontSize: 35,
              fontWeight: FontWeight.w200
            )
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.near_me),
            color: Color(0xFFFFFFFF),
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: _weatherTabs.map((item) => Page(tabController: _tabController, pageName: item['text'])).toList(),
      ),
      bottomNavigationBar: MediaQuery(
        data: MediaQuery.of(context).removePadding(removeBottom: true, removeTop: true),
        child: Padding(
          padding: EdgeInsetsGeometry.only(bottom: Platform.isAndroid ? bottomInset: 0),
          child: BottomAppBar(
            child: TabBar(
              controller: _tabController,
              dividerColor: Colors.transparent,
              indicatorWeight: 3.0,
              tabs: _weatherTabs.asMap().entries.map((item) {
                final Map<String,dynamic> value = item.value;
                final int index = item.key;
                return BottomTab(
                  text: value['text'],
                  icon: value['icon'],
                  index: index,
                  tabController: _tabController
                );
              }).toList(),
            )
          )
        )
      ),
    );
  }
}

class BottomTab extends StatelessWidget {
  final String text;
  final IconData icon;
  final int index;
  final TabController tabController;
  const BottomTab({
    super.key,
    required this.text,
    required this.icon,
    required this.index,
    required this.tabController
  });

  @override
  Widget build(BuildContext context) {
    return Tab(
      text: text,
      icon: Icon(
        icon,
        color: index == tabController.index ? Color(0xFF607d8b) : Color(0xFF9e9e9e) ,
      ),
    );
  }
}

class Page extends StatelessWidget {
  final String pageName;
  final TabController tabController;
  const Page({super.key, required this.tabController, required this.pageName});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: Container(
            color: Color(0xFFFFFFFF),
            child: Center(
              child: Text(
                pageName,
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
