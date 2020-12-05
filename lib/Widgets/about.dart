import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:wasseli/Widgets/divder.dart';

class WasseliAboutDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 0,
      child: Container(
        margin: const EdgeInsets.all(15),
        width: double.infinity,
        height: 155,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              Text(
                'About Wasseli',
                style: TextStyle(fontFamily: 'Brand-Bold', fontSize: 20),
              ),
              DividerWidget(),
              Text(
                'Wasseli app is a service to make transporting packages much easier and afordable.',
                textAlign: TextAlign.justify,
                style: TextStyle(fontFamily: 'Brand-Regular', fontSize: 18),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    height: 30,
                    width: 60,
                    child: FlatButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      //color: Colors.amber,
                      child: Text(
                        'Ok',
                        style: TextStyle(fontFamily: 'Brand-Bold', fontSize: 18, color: Colors.blue),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
