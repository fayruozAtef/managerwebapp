import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'Background/homeback.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children:<Widget> [
        const HomeBack(),
        Home2(),
      ],
    );
  }
}

class Home2 extends StatefulWidget {
  @override
  _home createState() => _home();
}

class _home extends State<Home2> {
  @override
  Widget build(BuildContext context) =>Scaffold(
    appBar: AppBar(title:const Text('Home'),),
    backgroundColor: Colors.transparent,

  );
}