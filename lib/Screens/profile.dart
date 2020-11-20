import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wasseli/DataHandler/appData.dart';

class ProfilePage extends StatelessWidget {
  static const String idScreen = 'profile';

  @override
  Widget build(BuildContext context) {
    var appData = Provider.of<AppData>(context, listen: false);
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 1,
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            color: Colors.black,
            icon: Icon(Icons.arrow_back_ios),
          ),
          title: Text(
            'My Profile',
            style: TextStyle(fontSize: 20, fontFamily: 'Brand-Bold', color: Colors.black),
          ),
          centerTitle: true,
        ),
        body: Container(
          //color: Colors.amber,
          child: Padding(
            padding: const EdgeInsets.only(left: 30, top: 30),
            child: Column(
              children: [
                Row(
                  children: [
                    Image.asset('assets/images/user_icon.png', height: 65, width: 65),
                    SizedBox(width: 16),
                    Text(appData.fullName, style: TextStyle(fontSize: 24, fontFamily: 'Brand-Bold')),
                  ],
                ),
                SizedBox(height: 25),
                Row(
                  children: [
                    Icon(
                      Icons.phone,
                      size: 40,
                    ),
                    SizedBox(width: 16),
                    Text('+213${appData.phoneNumber.replaceFirst('0', '')}', style: TextStyle(fontSize: 24, fontFamily: 'Brand-Bold')),
                  ],
                ),
                SizedBox(height: 25),
                Row(
                  children: [
                    Icon(
                      Icons.email,
                      size: 40,
                    ),
                    SizedBox(width: 16),
                    Text(appData.emailAddress, style: TextStyle(fontSize: 18, fontFamily: 'Brand-Bold')),
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
