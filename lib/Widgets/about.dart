import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:wasseli/Widgets/divder.dart';
import 'package:wasseli/localization/localization.dart';

class WasseliAboutDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var lang = DemoLocalization.of(context);
    return Dialog(
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 0,
      child: Container(
        margin: const EdgeInsets.all(15),
        width: double.infinity,
        height: 165,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              Text(
                lang.getTranslatedValue('about_title'),
                style: TextStyle(fontFamily: 'Brand-Bold', fontSize: 20, fontWeight: FontWeight.bold),
              ),
              DividerWidget(),
              Text(
                lang.getTranslatedValue('about_content'),
                textAlign: TextAlign.justify,
                style: TextStyle(fontFamily: 'Brand-Regular', fontSize: 18),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    height: 30,
                    width: 70,
                    child: FlatButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      //color: Colors.amber,
                      child: Text(
                        lang.getTranslatedValue('ok_button'),
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
