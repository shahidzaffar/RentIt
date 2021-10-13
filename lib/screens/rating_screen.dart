import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as Http;
import 'package:provider/provider.dart';
import 'package:rentit_app/component/rounded_button.dart';
import 'package:rentit_app/entities/constants.dart';
import 'package:rentit_app/helper%20classes/feedback.dart';
import 'package:rentit_app/helper%20classes/trip.dart';
import 'package:rentit_app/providers/current_variable_provider.dart';
import 'package:rentit_app/providers/trip_provider.dart';
import 'my_dashboard.dart';


class Ratings extends StatefulWidget {


  @override
  _RatingsState createState() => _RatingsState();
}

class _RatingsState extends State<Ratings> {

  bool busy = false;

  List<Trip> listTrips=[];
  late Trip trip;

  String feedback = '';

  IconData star1 = Icons.star_border_outlined,
      star2 = Icons.star_border_outlined,
      star3 = Icons.star_border_outlined,
      star4 = Icons.star_border_outlined,
      star5 = Icons.star_border_outlined;

  Color starColor = Colors.amber;
  int rate = 0;
  dynamic iconSize = 50.0;

  final _auth = FirebaseAuth.instance;




  void changeStatus() async {
    trip.status='completed';
    updateTrip();
  }


  void sendData(Map<String,dynamic> abc) async
  {


    return await Http.post(Uri.parse('$kIpAddress:7070/api/feedbacks'),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(abc))
        .then((value) {
      if (value.statusCode == 200) {
        final dataString = jsonDecode(value.body);
        final int val = dataString['id'];

        print('true');
        return val;
      } else {
        print(value.statusCode);
        print('-----------------------------------------------------------------------');
        print('eroor sending the whole Data');
        return -1;
      }
    });

  }



  void updateTrip() async {
    Map<String, dynamic> mapUpdate = trip.converttoJson();

    print('data');
    return await Http.put(Uri.parse('$kIpAddress:7070/api/trips'),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(mapUpdate))
        .then((value) {
      if (value.statusCode == 200) {
        print('true');
      } else {
        print(value.statusCode);
        print(value.body);
        print('error sending the whole Data');
      }
      return;
    });
  }


  void updateList() async
  {

    User? user = _auth.currentUser;

    listTrips= Provider.of<TripProvider>(context, listen : false).listTrips;

    print('---------------------Trips-----------------------------');
    print(listTrips);
    print('---------------------------------------------------');

    for(var a in listTrips)
    {
      if(a.customer!.email==user!.email)
      {
        if(a.status=='end')
          trip=a;
      }
    }
  }


  @override
  void initState() {

    updateList();
    super.initState();

  }
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: busy
          ? Center(
        child: CircularProgressIndicator(),
      )
          : SingleChildScrollView(
            child: Column(
            // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Center(child: Text('Give Rating',
                style: TextStyle(
                  fontSize: 30.0,
                  color: Colors.lightBlueAccent,
                  fontWeight: FontWeight.bold,
                ),
              )
              ),
              SizedBox(
                height: 20,
              ),
              Wrap(
                children: [
                  IconButton(
                      onPressed: () async {
                        oneStar();
                      },
                      icon: Icon(
                        star1,
                        size: iconSize,
                        color: starColor,
                      )),
                  IconButton(
                      onPressed: () async {
                        twoStars();
                      },
                      icon: Icon(
                        star2,
                        color: starColor,
                        size: iconSize,
                      )),
                  IconButton(
                      onPressed: () async {
                        threeStars();
                      },
                      icon: Icon(
                        star3,
                        color: starColor,
                        size: iconSize,
                      )),
                  IconButton(
                      onPressed: () async {
                        fourStars();
                      },
                      icon: Icon(
                        star4,
                        size: iconSize,
                        color: starColor,
                      )),
                  IconButton(
                      onPressed: () async {
                        fiveStars();
                      },
                      icon: Icon(
                        star5,
                        size: iconSize,
                        color: starColor,
                      )),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Divider(),
              SizedBox(
                height: 20,
              ),
              Text(
                'Give Feedback',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 30.0,
                  color: Colors.lightBlueAccent,
                  fontWeight: FontWeight.bold,
                ),
              ),

              SizedBox(
                height: 20,
              ),

              Padding(
                padding: const EdgeInsets.only(left: 25, right: 25),
                child: TextField(
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors.lightBlueAccent, width: 2.0),
                      borderRadius: BorderRadius.all(Radius.circular(32.0)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors.lightBlueAccent, width: 1.0),
                      borderRadius: BorderRadius.all(Radius.circular(32.0)),
                    ),
                  ),
                  onChanged: (value) {
                    feedback = value;
                  },
                ),
              ),

              SizedBox(
                height: 20,
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RoundedButton(

                    buttonPressed: () {
                      changeStatus();
                      Navigator.pop(context);
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) => MyDashboard(stat: 'done')));
                    },
                    buttonColor: Colors.deepOrangeAccent,
                    buttonText: 'Cancel',
                    minWidth: 100,
                  ),

                  SizedBox(
                    width: 30,
                  ),

                  RoundedButton(

                    buttonPressed: () async {
                      setState(() {
                        busy = true;
                      });



                      Feedbackk feedbac=Feedbackk(
                        description: feedback,
                        rating: rate,
                        customer: trip.customer,
                        vehicle: trip.vehicle, id: 1,

                      );

                      sendData(feedbac.converttoJson());
                      Provider.of<CurrentVariable>(context, listen: false).update('completed');

                      setState(() {
                        busy = false;
                      });
                      Navigator.pop(context);
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) => MyDashboard(stat: 'done')));
                    },
                    buttonText: 'Done',
                    buttonColor: Colors.lightBlueAccent,
                    minWidth: 100,
                  ),
                ],
              ),
            ]),
          ),
    );
  }
  

  void twoStars() async {
    setState(() {
      star1 = Icons.star;
      star2 = Icons.star;
      star3 = Icons.star_outline;
      star4 = Icons.star_outline;
      star5 = Icons.star_outline;
      rate = 2;
    });
  }

  void fourStars() {
    setState(() {
      star1 = Icons.star;
      star2 = Icons.star;
      star3 = Icons.star;
      star4 = Icons.star;
      star5 = Icons.star_outline;
      rate = 4;
    });
  }

  void oneStar() async {
    setState(() {
      star1 = Icons.star;
      star2 = Icons.star_outline;
      star3 = Icons.star_outline;
      star4 = Icons.star_outline;
      star5 = Icons.star_outline;
      rate = 1;
    });
  }

  void fiveStars() {
    setState(() {
      star1 = Icons.star;
      star2 = Icons.star;
      star3 = Icons.star;
      star4 = Icons.star;
      star5 = Icons.star;
      rate = 5;
    });
  }

  void threeStars() async {
    setState(() {
      star1 = Icons.star;
      star2 = Icons.star;
      star3 = Icons.star;
      star4 = Icons.star_outline;
      star5 = Icons.star_outline;
      rate = 3;
    });
  }

}