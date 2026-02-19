import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'mobileModule00',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageSate();
}

class _MyHomePageSate extends State<MyHomePage>{
  void onPressHandler() {
    print("Button pressed");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,  
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(6),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Color.fromARGB(255, 99, 99, 44)
              ),
              child: Text(
                "A   simple text",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 33,
                  fontWeight: FontWeight.w500,
                )
              )
            ),
            ElevatedButton(
              onPressed: onPressHandler,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: Size(80, 40),
              ),
              child: Text(
                "Click me",
                style: TextStyle(
                  color: Color.fromARGB(255, 117, 118, 59),
                  fontWeight: FontWeight.w600,
                ),
              ),
            )
          ],
        ),
      )
    );
  }
}

