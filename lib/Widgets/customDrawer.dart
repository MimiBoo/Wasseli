import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wasseli/DataHandler/appData.dart';
import 'package:wasseli/Screens/login.dart';
import 'package:wasseli/Screens/profile.dart';
import 'package:wasseli/Screens/settings.dart';
import 'package:wasseli/Widgets/about.dart';
import 'package:wasseli/Widgets/divder.dart';
import 'package:wasseli/localization/localization.dart';

class CustomDrawer extends StatelessWidget {
  final AppData appData;

  const CustomDrawer(this.appData);
  @override
  Widget build(BuildContext context) {
    var lang = DemoLocalization.of(context);
    return Container(
      color: Colors.white,
      width: 255,
      child: Drawer(
        child: Column(
          children: [
            Container(
              height: 160,
              child: DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.of(context).pushNamed(ProfilePage.idScreen);
                  },
                  child: Row(
                    children: [
                      Image.asset('assets/images/user_icon.png', height: 50, width: 50),
                      SizedBox(width: 16),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(appData.fullName != null ? appData.fullName : '', style: TextStyle(fontSize: 16, fontFamily: 'Brand-Bold')),
                          //SizedBox(height: 16),
                          Text(
                            'View Profile',
                            style: TextStyle(
                              fontSize: 12,
                              decorationStyle: TextDecorationStyle.solid,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            DividerWidget(),
            SizedBox(height: 12),
            // Drawer body Conttlers

            ListTile(
              leading: Icon(Icons.history),
              title: Text(lang.getTranslatedValue('delivery_history'), style: TextStyle(fontSize: 15)),
            ),

            GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return WasseliAboutDialog();
                  },
                );
              },
              child: ListTile(
                leading: Icon(Icons.info),
                title: Text(lang.getTranslatedValue('about'), style: TextStyle(fontSize: 15)),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, SettingScreen.idScreen);
              },
              child: ListTile(
                leading: Icon(Icons.settings),
                title: Text(lang.getTranslatedValue('settings_title'), style: TextStyle(fontSize: 15)),
              ),
            ),
            Expanded(
              child: Container(),
            ),

            GestureDetector(
              onTap: () {
                FirebaseAuth.instance.signOut();
                Navigator.pushNamedAndRemoveUntil(context, LoginScreen.idScreen, (route) => false);
              },
              child: ListTile(
                leading: Icon(Icons.logout),
                title: Text(lang.getTranslatedValue('logout'), style: TextStyle(fontSize: 15)),
              ),
            ),
            Text('V0.1.0 Beta', style: TextStyle(fontSize: 15)),
          ],
        ),
      ),
    );
  }
}
