import 'package:flutter/material.dart';
import 'package:tarot_africain/widgets/board_widget.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tarot Africain',
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
      home: const MyHomePage(title: 'Tarot Africain'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    final double appBarHeight = kToolbarHeight; // default AppBar height
    final double footerHeight = kToolbarHeight;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [

          BoardWidget(
            appBarHeight: appBarHeight,
            footerHeight: footerHeight,
          ),
          
          Container(
            height: kToolbarHeight,
            width: double.infinity,
            color: Colors.grey.shade300,
          ),
        ],
      ),
    );
  }
}
