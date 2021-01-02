import 'package:flutter/material.dart';

class CollectEarningDialog extends StatelessWidget {
  final int price;

  const CollectEarningDialog({this.price});
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      backgroundColor: Colors.transparent,
      child: Container(
        margin: EdgeInsets.all(5),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 22),
            Text('Cash Payment'),
            SizedBox(height: 22),
            Divider(height: 2, thickness: 2),
            SizedBox(height: 16),
            Text("$price DA", style: TextStyle(fontSize: 55, fontFamily: 'Brand-Bold')),
            SizedBox(height: 16),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text('This is the trip price.', textAlign: TextAlign.center),
            ),
            SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context, 'close');
                      },
                      child: Container(
                        height: 60,
                        width: 60,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(26),
                          border: Border.all(width: 2, color: Colors.green[500]),
                        ),
                        child: Icon(
                          Icons.check,
                          color: Colors.green[500],
                          size: 26,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    child: Text(
                      'Pay cash',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14.0, fontFamily: "Brand-Regular"),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
