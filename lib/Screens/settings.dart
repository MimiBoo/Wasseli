import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wasseli/localization/language.dart';
import 'package:wasseli/localization/localization.dart';
import 'package:wasseli/main.dart';

class SettingScreen extends StatefulWidget {
  static const String idScreen = 'setting';
  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  _changeLanguage(BuildContext context, Language language) async {
    Locale _temp;
    switch (language.languageCode) {
      case 'en':
        _temp = Locale(language.languageCode, 'US');
        break;
      case 'ar':
        _temp = Locale(language.languageCode, 'DZ');
        break;
      default:
        _temp = Locale(language.languageCode, 'DZ');
    }

    MyApp.setLocale(context, _temp);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("languageCode", language.languageCode);
  }

  @override
  Widget build(BuildContext context) {
    var lang = DemoLocalization.of(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          lang.getTranslatedValue('settings_title'),
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          children: [
            SizedBox(height: 15),
            Container(
              decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(20)),
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${lang.getTranslatedValue('change_language')}:',
                    style: TextStyle(fontSize: 22, fontFamily: 'Brand-Bold'),
                  ),
                  DropdownButton(
                    underline: SizedBox(width: 0),
                    icon: Icon(
                      Icons.language,
                      color: Colors.black,
                      size: 40,
                    ),
                    items: Language.languageList()
                        .map<DropdownMenuItem<Language>>(
                          (lang) => DropdownMenuItem<Language>(
                            value: lang,
                            child: Row(
                              children: [
                                Text(lang.flag),
                                Text(lang.name),
                              ],
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: (Language language) {
                      _changeLanguage(context, language);
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
