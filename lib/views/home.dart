import 'package:flutter/material.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:wasselli/DataHandler/appData.dart';
import 'package:wasselli/config.dart';
import 'package:wasselli/helpers/geofireHelperMethod.dart';
import 'package:wasselli/helpers/helperMethods.dart';
import 'package:wasselli/main.dart';
import 'package:wasselli/models/directionDetails.dart';
import 'package:wasselli/models/driver.dart';
import 'package:wasselli/tools/color.dart';
import 'package:wasselli/tools/wasseli_icons.dart';
import 'package:wasselli/views/profile.dart';
import 'package:wasselli/widgets/driver_card.dart';
import 'package:easy_localization/easy_localization.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool nearbyDriverKeysLoaded = false;
  DirectionDetails tripDirectionDetails;

  void locateUser() async {
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.bestForNavigation);
    currentPosition = position;
    var userPickUpAddress = await HelperMethods.searchCoordinateAddress(position, context);
    Provider.of<AppData>(context, listen: false).updatePickUpLocationAddress(userPickUpAddress);
    initializeGeoFire();
  }

  void initializeGeoFire() async {
    Geofire.initialize('availableDrivers');
    GeoFireHelper.nearByDriversList.clear();
    Geofire.queryAtLocation(currentPosition.latitude, currentPosition.longitude, 5).listen((map) {
      if (map != null) {
        var callBack = map['callBack'];

        switch (callBack) {
          case Geofire.onKeyEntered:
            addDriver(map['key'], map['latitude'], map['longitude']);
            if (nearbyDriverKeysLoaded) {
              updateAvailabeDriver(map['key'], map['latitude'], map['longitude']);
            }
            break;
          case Geofire.onKeyExited:
            removeDriver(map['key']);
            break;
          case Geofire.onKeyMoved:
            updateAvailabeDriver(map['key'], map['latitude'], map['longitude']);

            break;

          case Geofire.onGeoQueryReady:
            updateAvailabeDriver(map['key'], map['latitude'], map['longitude']);

            break;
        }
      }
    });
  }

  void removeDriver(String key) {
    setState(() {
      GeoFireHelper.removeDriverFromList(key);
    });
  }

  void updateAvailabeDriver(String key, double latitude, double longitude) {
    if (GeoFireHelper.nearByDriversList.length != 0) {
      for (var i = 0; i >= GeoFireHelper.nearByDriversList.length; i++) {
        if (GeoFireHelper.nearByDriversList[i].key == key) {
          Driver drivers = Driver(
            key: GeoFireHelper.nearByDriversList[i].key,
            lastName: GeoFireHelper.nearByDriversList[i].lastName,
            firstName: GeoFireHelper.nearByDriversList[i].lastName,
            phone: GeoFireHelper.nearByDriversList[i].phone,
            carInfo: GeoFireHelper.nearByDriversList[i].carInfo,
            token: GeoFireHelper.nearByDriversList[i].token,
            latitude: latitude,
            longitude: longitude,
            rating: GeoFireHelper.nearByDriversList[i].rating,
          );
          setState(() {
            GeoFireHelper.nearByDriversList.removeAt(i);
            GeoFireHelper.nearByDriversList.add(drivers);
          });
        }
      }
    }
  }

  addDriver(String key, double latitude, double longitude) async {
    if (key != null) {
      var snap = await driverRef.child(key).once();

      if (snap != null) {
        Driver driver = Driver.fromSnapshot(snap, latitude, longitude);
        setState(() {
          GeoFireHelper.nearByDriversList.add(driver);
        });
      }
    } else {
      return;
    }
  }

  @override
  void initState() {
    super.initState();
    locateUser();
    HelperMethods.getCurrentOnlineUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('${"near_by_drivers".tr()} ${GeoFireHelper.nearByDriversList.length}'),
          backgroundColor: mainBlack,
          centerTitle: true,
          elevation: 0,
        ),
        body: GeoFireHelper.nearByDriversList.length == 0
            ? Center(
                child: Text("no_drivers".tr()),
              )
            : ListView.builder(
                itemCount: GeoFireHelper.nearByDriversList.length,
                itemBuilder: (context, index) {
                  return DriverCard(GeoFireHelper.nearByDriversList[index]);
                },
              ),
        bottomNavigationBar: BottomAppBar(
          child: Container(
            height: 50,
            color: mainBlack,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: IconButton(
                    icon: Icon(
                      Wasseli.menu,
                      color: Colors.white,
                      size: 40,
                    ),
                    onPressed: () {},
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: IconButton(
                    icon: Icon(
                      Wasseli.profile,
                      color: Colors.white,
                      size: 40,
                    ),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (_) => ProfileScreen()));
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
