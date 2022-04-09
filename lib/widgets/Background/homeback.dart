import 'package:flutter/material.dart';
class HomeBack extends StatelessWidget {
  const HomeBack({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration:const  BoxDecoration(
        image:  DecorationImage(
          image: AssetImage('assets/images/backimage.jpg'),
          opacity: 0.9,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
