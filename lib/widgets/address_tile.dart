import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:steps_indicator/steps_indicator.dart';
import 'package:wasselli/DataHandler/appData.dart';
import 'package:wasselli/tools/color.dart';

class AddressTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 28, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Address',
            style: TextStyle(fontFamily: 'NexaBold', fontSize: 20),
          ),
          SizedBox(height: 28),
          Row(
            //mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              StepsIndicator(
                selectedStep: 2,
                doneLineColor: mainBlack,
                doneStepColor: mainBlack,
                nbSteps: 2,
                isHorizontal: false,
                lineLengthCustomStep: [
                  StepsIndicatorCustomLine(nbStep: 2, length: 100)
                ],
              ),
              SizedBox(width: 6),
              Container(
                height: 120,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'From',
                          style: TextStyle(fontFamily: 'NexaLight', fontSize: 14, color: Colors.grey),
                        ),
                        SizedBox(height: 5),
                        Text(
                          Provider.of<AppData>(context, listen: false).userPickUpLocation.placeFormattedAddress,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontFamily: 'NexaBold',
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'To',
                          style: TextStyle(fontFamily: 'NexaLight', fontSize: 14, color: Colors.grey),
                        ),
                        SizedBox(height: 5),
                        Text(
                          Provider.of<AppData>(context, listen: false).userDropOffLocation.placeFormattedAddress,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontFamily: 'NexaBold',
                            fontSize: 18,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
