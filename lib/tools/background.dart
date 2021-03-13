import 'dart:ui';
import 'package:flutter/material.dart';

class BackgroundBlur extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage(
              'assets/images/background.jpg',
            ),
            fit: BoxFit.fitHeight),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
        child: Container(
          decoration: BoxDecoration(color: Colors.white.withOpacity(0.0)),
        ),
      ),
    );
  }
}
