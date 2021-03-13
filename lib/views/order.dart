import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:wasselli/DataHandler/appData.dart';
import 'package:wasselli/config.dart';
import 'package:wasselli/helpers/helperMethods.dart';
import 'package:wasselli/main.dart';
import 'package:wasselli/models/directionDetails.dart';
import 'package:wasselli/models/ride_details.dart';
import 'package:wasselli/models/ride_types.dart';
import 'package:wasselli/tools/color.dart';
import 'package:wasselli/views/home.dart';
import 'package:wasselli/views/waiting.dart';
import 'package:wasselli/widgets/address_tile.dart';
import 'package:wasselli/widgets/ride_type_tile.dart';

class OrderScreen extends StatefulWidget {
  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  int price = 0;

  void getPrice() async {
    var dropOff = Provider.of<AppData>(context, listen: false).userDropOffLocation;

    var pickUpLatLng = LatLng(currentPosition.latitude, currentPosition.longitude);
    var dropOffLatLng = LatLng(dropOff.latitude, dropOff.longitude);
    var details = await HelperMethods.obtainDirectionsDetails(pickUpLatLng, dropOffLatLng);
    var prices = HelperMethods.calculateFares(details);
    setState(() {
      price = prices;
    });
  }

  Future<DirectionDetails> getDirectionDetails() async {
    var dropOff = Provider.of<AppData>(context, listen: false).userDropOffLocation;

    var pickUpLatLng = LatLng(currentPosition.latitude, currentPosition.longitude);
    var dropOffLatLng = LatLng(dropOff.latitude, dropOff.longitude);
    var details = await HelperMethods.obtainDirectionsDetails(pickUpLatLng, dropOffLatLng);
    return details;
  }

  void makeRideRequest() async {
    var prickUp = Provider.of<AppData>(context, listen: false).userPickUpLocation;
    var dropOff = Provider.of<AppData>(context, listen: false).userDropOffLocation;
    var driver = Provider.of<AppData>(context, listen: false).selecteDriver;

    Map pickUpLocation = {
      "latitude": prickUp.latitude,
      "longitude": prickUp.longitude,
    };
    Map dropOffLocation = {
      "latitude": dropOff.latitude,
      "longitude": dropOff.longitude,
    };

    var tripDirectionDetails = await getDirectionDetails();

    Map rideInfo = {
      "driver_id": driver.key,
      "driver_first_name": driver.firstName,
      "driver_last_name": driver.lastName,
      "driver_token": driver.token,
      "driver_phone": driver.phone,
      "car_info": driver.carInfo,
      'distence': tripDirectionDetails.distanceText,
      'duration': tripDirectionDetails.durationText,
      "price": price,
      "pickup": pickUpLocation,
      "dropoff": dropOffLocation,
      "rider_first_name": currentUserInfo.firstName,
      "rider_last_name": currentUserInfo.lastName,
      "rider_phone": currentUserInfo.phone,
      "pickup_address": prickUp.placeFormattedAddress,
      "dropoff_address": dropOff.placeFormattedAddress,
      "created_at": DateTime.now().toString(),
      "payment_method": 'cash',
      "status": "waiting"
    };
    rideDetails = RideDetails.fromMap(rideInfo);

    requestRef.set(rideInfo);
  }

  @override
  void initState() {
    super.initState();
    getPrice();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: mainBlack,
          elevation: 0,
          title: Text(
            'Create Trip',
            style: TextStyle(fontFamily: 'NexaLight', fontSize: 20),
          ),
          actions: [
            IconButton(
              icon: SvgPicture.asset(
                'assets/images/close.svg',
                fit: BoxFit.cover,
                color: Colors.white,
                width: 20,
                height: 20,
              ),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    actions: [
                      FlatButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('No'),
                      ),
                      FlatButton(
                        onPressed: () {
                          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (_) => HomeScreen()), (Route<dynamic> route) => false);
                        },
                        child: Text('Yes'),
                      )
                    ],
                    content: Container(
                      height: 100,
                      child: Center(
                        child: Text('Are you sure you want to cancel'),
                      ),
                    ),
                  ),
                );
              },
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              AddressTile(),
              SizedBox(height: MediaQuery.of(context).size.height * .05),
              RideTypeList(),
              Container(
                color: mainGrey,
                margin: EdgeInsets.symmetric(horizontal: 28),
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          FontAwesomeIcons.moneyCheckAlt,
                          size: 18,
                          color: mainBlack,
                        ),
                        SizedBox(width: 16),
                        Text(
                          'Cash',
                          style: TextStyle(fontSize: 16, fontFamily: 'NexaBold', color: mainBlack),
                        ),
                      ],
                    ),
                    SizedBox(width: 10),
                    Text(
                      '$price DA',
                      style: TextStyle(fontSize: 20, fontFamily: "NexaBold"),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: GestureDetector(
          onTap: () {
            makeRideRequest();
            Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (_) => RequestScreen()), (Route<dynamic> route) => false);
          },
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 28, vertical: 28),
            height: 80,
            decoration: BoxDecoration(color: mainBlack, borderRadius: BorderRadius.circular(20)),
            child: Row(
              children: [
                Expanded(
                  child: Center(
                    child: Text(
                      "Request Trip",
                      style: TextStyle(color: Colors.white, fontFamily: "NexaBold", fontSize: 25),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class RideTypeList extends StatefulWidget {
  @override
  _RideTypeListState createState() => _RideTypeListState();
}

class _RideTypeListState extends State<RideTypeList> {
  List<RideTypes> rideTypes = [
    RideTypes(
        icon: Image.asset(
          'assets/images/truck.png',
          width: 50,
          height: 50,
        ),
        title: "Mini Truck"),
  ];
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 28, vertical: 16),
      child: Container(
        height: 60,
        child: ListView.builder(
          physics: BouncingScrollPhysics(),
          itemCount: rideTypes.length,
          itemBuilder: (context, index) {
            return RideTypeTile(
              rideTypes: rideTypes[index],
              onTap: (state) {
                print('click $state');
              },
            );
          },
        ),
      ),
    );
  }
}
