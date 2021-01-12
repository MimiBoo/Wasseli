import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:wasseli/config.dart';

class RatingScreen extends StatefulWidget {
  final String driverId, rideId;

  const RatingScreen({this.driverId, this.rideId});

  @override
  _RatingScreenState createState() => _RatingScreenState();
}

class _RatingScreenState extends State<RatingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Dialog(
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
              Text(
                'Rate this driver',
                style: TextStyle(fontSize: 20, fontFamily: 'Brand-Bold', color: Colors.black54),
              ),
              SizedBox(height: 22),
              Divider(height: 2, thickness: 2),
              SizedBox(height: 16),
              SmoothStarRating(
                rating: starCounter,
                color: Colors.green,
                allowHalfRating: false,
                starCount: 5,
                size: 45,
                onRated: (double value) {
                  starCounter = value;

                  switch (starCounter.round()) {
                    case 1:
                      setState(() {
                        title = 'Very Bad';
                      });
                      break;
                    case 2:
                      setState(() {
                        title = 'Bad';
                      });
                      break;
                    case 3:
                      setState(() {
                        title = 'Good';
                      });
                      break;
                    case 4:
                      setState(() {
                        title = 'Very Good';
                      });
                      break;
                    case 5:
                      setState(() {
                        title = 'Excellent';
                      });
                      break;
                    default:
                  }
                },
              ),
              SizedBox(height: 14),
              Text(
                title,
                style: TextStyle(fontSize: 55.0, fontFamily: "Signatra", color: Colors.green),
              ),
              SizedBox(height: 14),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: GestureDetector(
                        onTap: () {
                          DatabaseReference driverRatingRef = FirebaseDatabase.instance.reference().child('drivers').child(widget.driverId).child('ratings');
                          DatabaseReference requestRef = FirebaseDatabase.instance.reference().child('rides').child(widget.rideId).child('rating');
                          driverRatingRef.once().then((DataSnapshot snap) {
                            if (snap.value != null) {
                              double oldRating = snap.value.toDouble();
                              double avgRating = (oldRating + starCounter) / 2;
                              driverRatingRef.set(avgRating);
                            } else {
                              driverRatingRef.set(starCounter);
                            }
                          });
                          requestRef.set(starCounter);
                          Navigator.pop(context);
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
                        'Submit',
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
      ),
    );
  }
}
