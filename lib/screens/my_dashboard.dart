import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as Http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:rentit_app/component/app_drawer.dart';
import 'package:rentit_app/component/cus_custom_card.dart';
import 'package:rentit_app/component/db_methods.dart';
import 'package:rentit_app/component/no_data_display.dart';
import 'package:rentit_app/component/rounded_button.dart';
import 'package:rentit_app/entities/constants.dart';
import 'package:rentit_app/helper%20classes/trip.dart';
import 'package:rentit_app/providers/trip_provider.dart';
import 'package:rentit_app/screens/payment_screen.dart';
import 'package:rentit_app/screens/rating_screen.dart';

import 'chat_screen.dart';

class MyDashboard extends StatefulWidget {
  const MyDashboard({required this.stat});

  final String stat;

  @override
  _MyDashboardState createState() => _MyDashboardState();
}

class _MyDashboardState extends State<MyDashboard>
    with SingleTickerProviderStateMixin {
  final _auth = FirebaseAuth.instance;

  final List<Tab> tab = <Tab>[
    Tab(text: 'Current Ride'),
    Tab(text: 'Pending'),
    Tab(text: 'Completed'),
  ];

  late TabController tabController;
  List<Trip> completedAndCancelledRides = [];

  List<Trip> allTrips = [];
  late Trip currentTrip;
  late Trip pendingTrip;

  String current = 'loading';
  bool pending = false;

  void caller() async {
    allTrips =
        await Provider.of<TripProvider>(context, listen: false).getListTrip();
    if (allTrips.isNotEmpty) {
      setState(() {
        getCurrentUserRides();
      });
    }
  }

  @override
  void initState() {
    setState(() {
      caller();
    });

    super.initState();
    tabController = TabController(vsync: this, length: tab.length);
  }

  bool history = false;

  void getCurrentUserRides() {
    User? user = _auth.currentUser;

    print('-----------------------------');
    print('Inside Method');
    print(user!.email);
    print('-----------------------------');
    print(allTrips);

    for (var tripp in allTrips) {
      print(tripp.customer!.email);
      print(tripp.optionDriver);
      if (tripp.customer!.email == user.email) {
        if ((tripp.status == 'completed')) {
          completedAndCancelledRides.add(tripp);
          setState(() {
            history = true;
          });
        } else if (tripp.status == 'cancelled') {
          completedAndCancelledRides.add(tripp);
          setState(() {
            history = true;
          });
        } else if (tripp.status == 'accepted') {
          completedAndCancelledRides.add(tripp);
          setState(() {
            current = tripp.status;
          });
        } else if (tripp.status == 'current') {
          currentTrip = tripp;
          setState(() {
            current = tripp.status;
          });
        } else if (tripp.status == 'pending') {
          pendingTrip = tripp;
          setState(() {
            pending = true;
          });
        } else if (tripp.status == 'ending') {
          currentTrip = tripp;
          setState(() {
            current = tripp.status;
          });
        } else if (tripp.status == 'end') {
          currentTrip = tripp;
          setState(() {
            current = tripp.status;
          });
        }
      }
    }
  }

  void updateTrip() async {
    Map<String, dynamic> mapUpdate = pendingTrip.converttoJson();

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

  void updateDriver() async {
    Map<String, dynamic> mapUpdate = pendingTrip.driver!.converttoJson();

    print('data');
    return await Http.put(Uri.parse('$kIpAddress:7070/api/drivers'),
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

  void updateVehicle() async {

    pendingTrip.vehicle!.status=true;
    Map<String, dynamic> mapUpdate = pendingTrip.vehicle!.converttoJson();

    print('data');
    return await Http.put(Uri.parse('$kIpAddress:7070/api/vehicles'),
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

  void cancelRequest() {
    pendingTrip.status = 'cancelled';

    updateTrip();

    updateVehicle();

    if(pendingTrip.driver!=null)
      {
        pendingTrip.driver!.driverOnTrip=false;
        updateDriver();
      }

    setState(() {
      completedAndCancelledRides.add(pendingTrip);
    });
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('My Dashboard'),
          centerTitle: true,
          bottom: TabBar(
            controller: tabController,
            tabs: tab,
          ),
        ),
        body: Container(
          child: TabBarView(
            controller: tabController,
            children: [
              Container(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 45),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      current == 'loading'
                          ? CircularProgressIndicator()
                          : current == 'current'
                              ? CusCustomCard(
                                  terminal: currentTrip.customer!.name,
                                  vehicle: currentTrip.vehicle!.vMake,
                                  category: currentTrip.vehicle!.category,
                                  isDriver: currentTrip.optionDriver,
                                  text: 'Current Ride Info',
                                  status: currentTrip.status,
                                )
                              : current == 'accepted'
                                  ? Column(
                                      children: [
                                        CusCustomCard(
                                          terminal: currentTrip.customer!.name,
                                          vehicle: currentTrip.vehicle!.vMake,
                                          category:
                                              currentTrip.vehicle!.category,
                                          isDriver: currentTrip.optionDriver,
                                          text: 'Current Ride Info',
                                          status: current,
                                        ),
                                        if (currentTrip.optionDriver)
                                          RoundedButton(
                                            buttonPressed: () {
                                              createChatRoomAndStartConversation(
                                                  currentTrip.customer!.userName,
                                                  currentTrip.driver!.userName);
                                            },
                                            buttonText: 'Chat',
                                            buttonColor: Colors.lightBlueAccent,
                                            minWidth: 110,
                                          ),
                                      ],
                                    )
                                  : current == 'ending'
                                      ? PaymentScreen()
                                      : current == 'end'
                                          ? Ratings()
                                          : NoDataDisplayWidget(),
                    ],
                  ),
                ),
              ),
              Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    pending
                        ? CusCustomCard(
                            terminal: pendingTrip.terminal!.name,
                            vehicle: pendingTrip.vehicle!.vMake,
                            category: pendingTrip.vehicle!.category,
                            isDriver: pendingTrip.optionDriver,
                            text: 'Pending Ride Info',
                            status: current,
                          )
                        : NoDataDisplayWidget(),
                    pending
                        ? ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.red),
                              elevation: MaterialStateProperty.all(6),
                            ),
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: Text(
                                        'Alert',
                                        style: TextStyle(color: Colors.red),
                                      ),
                                      content: Text(
                                          'Are you sure you want to cancel the request?'),
                                      actions: [
                                        ElevatedButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: Text('No'),
                                        ),
                                        ElevatedButton(
                                          onPressed: () {
                                            cancelRequest();
                                            setState(() {
                                              pending = false;
                                            });
                                            Navigator.pop(context);
                                          },
                                          child: Text('Yes'),
                                        ),
                                      ],
                                    );
                                  });
                            },
                            child: Text('Cancel'),
                          )
                        : Text(''),
                  ],
                ),
              ),
              SingleChildScrollView(
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      history
                          ? getWidgets(completedAndCancelledRides)
                          : NoDataDisplayWidget(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        drawer: AppDrawer(),
      ),
    );
  }

  createChatRoomAndStartConversation(String secondUser, String firstUser) {
    DatabaseMethods databaseMethods = DatabaseMethods();

    String chatRoomId = getChatRoomId(secondUser, firstUser);
    List<String> users = [secondUser, firstUser];
    Map<String, dynamic> chatRoomMap = {
      'users': users,
      'chatroomId': chatRoomId
    };
    databaseMethods.createChatRoom(chatRoomId, chatRoomMap, firstUser);
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => ChattingScreen(
                  chatRoomId: chatRoomId,
                  driUserName: secondUser,
                  cusUserName: firstUser,
                  userType: 'customer',
                )));
  }

  getChatRoomId(String a, String b) {
    if (a.compareTo(b) == 1) {
      return '$b\_$a';
    } else {
      return '$a\_$b';
    }
  }

  Widget getWidgets(List<Trip> rides) {
    print('----------------------------------------------------------');
    print(rides.length);
    List<Widget> list = [];
    for (var i = 0; i < rides.length; i++) {
      var num = i + 1;
      list.add(
        new CusCustomCard(
          terminal: rides[i].terminal!.name,
          category: rides[i].vehicle!.category,
          vehicle: rides[i].vehicle!.vMake,
          isDriver: rides[i].optionDriver,
          text: 'Ride $num',
          status: rides[i].status,
        ),
      );
    }
    return new Column(children: list);
  }
}
