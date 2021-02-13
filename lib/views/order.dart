import 'package:flutter/material.dart';
import 'package:wasseli/tools/color.dart';

class OrderScreen extends StatefulWidget {
  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: mainBlack,
      child: TabBar(
        tabs: [
          Container(),
          Container(),
        ],
      ),
    );
  }
}
