import 'package:flutter/material.dart';
import 'package:wasseli/Widgets/divder.dart';

class CustomDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      width: 255,
      child: Drawer(
        child: ListView(
          children: [
            Container(
              height: 165,
              child: DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                child: Row(
                  children: [
                    Image.asset('assets/images/user_icon.png', height: 65, width: 65),
                    SizedBox(width: 16),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Profile Name', style: TextStyle(fontSize: 16, fontFamily: 'Brand-Bold')),
                        SizedBox(width: 16),
                        Text('View Profile', style: TextStyle())
                      ],
                    ),
                  ],
                ),
              ),
            ),
            DividerWidget(),
            SizedBox(height: 12),
            // Drawer body Conttlers

            ListTile(
              leading: Icon(Icons.history),
              title: Text('Delivery History', style: TextStyle(fontSize: 15)),
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Visit Profile', style: TextStyle(fontSize: 15)),
            ),
            ListTile(
              leading: Icon(Icons.info),
              title: Text('About', style: TextStyle(fontSize: 15)),
            ),
          ],
        ),
      ),
    );
  }
}
