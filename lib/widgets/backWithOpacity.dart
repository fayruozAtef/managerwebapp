import 'package:flutter/material.dart';
class BackWithOpacity extends StatelessWidget {
  const BackWithOpacity({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/background.jpg'),
          opacity: 0.6,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
