import 'package:flutter/material.dart';
import 'package:wasseli/localization/localization.dart';

class NoDriverDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var lang = DemoLocalization.of(context);
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        margin: EdgeInsets.all(0),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 10),
                Text(lang.getTranslatedValue('no_driver_found'), style: TextStyle(fontSize: 22, fontFamily: 'Brand-Bold')),
                SizedBox(height: 25),
                Padding(
                  padding: EdgeInsets.all(8),
                  child: Text(lang.getTranslatedValue('no_driver_found_content')),
                ),
                SizedBox(height: 30),
                Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        height: 60,
                        width: 60,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(26),
                          border: Border.all(width: 2, color: Colors.black54),
                        ),
                        child: Icon(
                          Icons.close,
                          size: 26,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      width: double.infinity,
                      child: Text(
                        lang.getTranslatedValue('close_button'),
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 14.0, fontFamily: "Brand-Regular"),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
