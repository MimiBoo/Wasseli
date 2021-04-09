import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:wasselli/Widgets/notice.dart';
import 'package:wasselli/tools/color.dart';
import 'package:wasselli/tools/wasseli_icons.dart';

import '../config.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: mainBlack,
        appBar: AppBar(
          backgroundColor: mainBlack,
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              Wasseli.close,
              color: Colors.white,
              size: 20,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          title: Text(
            'settings_title'.tr(),
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'NexaLight',
              fontSize: 30,
            ),
          ),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 47),
                child: Notice(),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 23, bottom: 47),
                child: Divider(
                  color: dviderColor,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'change_language'.tr(),
                    style: TextStyle(color: Colors.white, fontFamily: 'NexaLight', fontSize: 24),
                  ),
                  DropdownButton(
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
                      _changeLanguage(context, value);
                    },
                  ),
                ],
              ),
              SizedBox(height: 23),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Notification',
                    style: TextStyle(color: Colors.white, fontFamily: 'NexaLight', fontSize: 24),
                  ),
                  IconButton(
                      icon: RotationTransition(
                        turns: new AlwaysStoppedAnimation(180 / 360),
                        child: Icon(
                          Wasseli.previous,
                          color: Colors.white,
                          size: 40,
                        ),
                      ),
                      onPressed: () {})
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 47),
                child: Divider(
                  color: dviderColor,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'about'.tr(),
                    style: TextStyle(color: Colors.white, fontFamily: 'NexaLight', fontSize: 24),
                  ),
                  IconButton(
                      icon: RotationTransition(
                        turns: new AlwaysStoppedAnimation(180 / 360),
                        child: Icon(
                          Wasseli.previous,
                          color: Colors.white,
                          size: 40,
                        ),
                      ),
                      onPressed: () {})
                ],
              ),
              SizedBox(height: 23),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'contact'.tr(),
                    style: TextStyle(color: Colors.white, fontFamily: 'NexaLight', fontSize: 24),
                  ),
                  IconButton(
                      icon: RotationTransition(
                        turns: new AlwaysStoppedAnimation(180 / 360),
                        child: Icon(
                          Wasseli.previous,
                          color: Colors.white,
                          size: 40,
                        ),
                      ),
                      onPressed: () {})
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  _changeLanguage(BuildContext context, String languageCode) {
    switch (languageCode) {
      case 'en':
        context.locale = Locale('en', 'US');
        isLatin = true;
        break;
      case 'ar':
        context.locale = Locale('ar', 'DZ');
        isLatin = false;
        break;
    }
  }
}
