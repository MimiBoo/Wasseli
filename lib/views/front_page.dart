import 'package:flutter/material.dart';
import 'package:wasselli/Widgets/button.dart';
import 'package:wasselli/tools/background.dart';
import 'package:wasselli/tools/color.dart';
import 'package:wasselli/tools/wasseli_icons.dart';
import 'package:wasselli/views/login.dart';
import 'package:easy_localization/easy_localization.dart';

import '../config.dart';

class FrontPage extends StatefulWidget {
  @override
  _FrontPageState createState() => _FrontPageState();
}

class _FrontPageState extends State<FrontPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        child: Stack(
          children: [
            BackgroundBlur(),
            //App title
            Positioned(
              top: 30,
              left: isLatin ? 25 : null,
              right: isLatin ? null : 25,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'welcome'.tr(),
                    style: TextStyle(color: Colors.white, fontFamily: "Nirmala", fontSize: 30),
                  ),
                  Text(
                    'app_name'.tr(),
                    style: TextStyle(color: Colors.white, fontFamily: "MS", fontSize: 85),
                  ),
                ],
              ),
            ),
            //Authenticate button
            Positioned(
              bottom: 160,
              left: 96.5,
              child: Column(
                children: [
                  CustomButton(
                    title: 'authenticate'.tr(),
                    titleColor: mainTeal,
                    color: Colors.white,
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (_) => LoginScreen()));
                    },
                  )
                ],
              ),
            ),
            //Language dropdown button
            Positioned(
              left: isLatin ? 100.5 : null,
              right: isLatin ? null : 100.5,
              bottom: 86,
              child: DropdownButton(
                underline: SizedBox(),
                icon: Icon(
                  Wasseli.language,
                  color: Colors.white,
                  size: 40,
                ),
                items: [
                  DropdownMenuItem(
                    value: "en",
                    child: Row(
                      children: [
                        Text('🇺🇸'),
                        Text('English'),
                      ],
                    ),
                  ),
                  DropdownMenuItem(
                    value: "ar",
                    child: Row(
                      children: [
                        Text('🇩🇿'),
                        Text('العربية'),
                      ],
                    ),
                  ),
                ],
                onChanged: (value) {
                  print("VALUE: $value");
                  _changeLanguage(context, value);
                },
              ),
            ),
            //copyright
            Positioned(
              bottom: 2,
              left: 149,
              child: Text(
                'wasseli©2021',
                style: TextStyle(color: Colors.white, fontFamily: 'NexaLight', fontSize: 14),
              ),
            )
          ],
        ),
      ),
    );
  }

  _changeLanguage(BuildContext context, String languageCode) {
    print("CODE: $languageCode");
    switch (languageCode) {
      case 'en':
        setState(() {
          context.locale = Locale('en', 'US');
          isLatin = true;
        });
        break;
      case 'ar':
        setState(() {
          context.locale = Locale('ar', 'DZ');
          isLatin = false;
        });
        break;
    }
  }
}
