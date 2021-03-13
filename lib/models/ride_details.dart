class RideDetails {
  String driverName;
  String driverPhone;
  Map carInfo;
  //
  Map pickup;
  String pickUpAddress;
  //
  Map dropoff;
  String dropOffAddress;
  //
  String paymentMethod;
  String duration;
  String distence;
  int price;

  RideDetails({this.carInfo, this.distence, this.dropOffAddress, this.dropoff, this.duration, this.paymentMethod, this.pickUpAddress, this.pickup, this.price, this.driverName, this.driverPhone});

  RideDetails.fromMap(Map<dynamic, dynamic> rideInfo) {
    driverName = "${rideInfo['driver_first_name']} ${rideInfo['driver_last_name']}";
    driverPhone = rideInfo['driver_phone'];
    carInfo = rideInfo['car_info'];
    //
    pickup = rideInfo['pickup'];
    pickUpAddress = rideInfo['pickup_address'];
    //
    dropoff = rideInfo['dropoff'];
    dropOffAddress = rideInfo['dropoff_address'];
    //
    paymentMethod = rideInfo['payment_method'];
    duration = rideInfo['duration'];
    distence = rideInfo['distence'];
    price = rideInfo['price'];
  }
}
