import 'package:flutter/material.dart';

class Background extends StatelessWidget {
  final Widget child;

  const Background({
    Key? key, required this.child,  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Stack(
      children: [

        Positioned(

          child: Image.asset(
            "assets/logos/logo_white.png",
            height: 40,
          ),
        ),
        Image.asset(
        "assets/background.png",
        height: size.height,
        width: size.width,
        ),




        ]

        );

  }
}
