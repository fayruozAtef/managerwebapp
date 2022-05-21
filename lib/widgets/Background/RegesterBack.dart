import 'package:flutter/material.dart';
class RegesterBack extends StatelessWidget {
  const RegesterBack({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: NetworkImage("https://img.freepik.com/free-photo/old-black-background-grunge-texture-dark-wallpaper-blackboard-chalkboard-room-wall_1258-28312.jpg?t=st=1653118372~exp=1653118972~hmac=1587f002ac344688a848dd770eca6de6edeaf3f47b44953409746b980e068f64&w=826"),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
