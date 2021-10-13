import 'dart:convert';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as Http;
import 'package:rentit_app/component/dri_custom_card.dart';
import 'package:rentit_app/component/no_data_display.dart';
import 'package:rentit_app/entities/constants.dart';
import 'package:rentit_app/helper%20classes/terminal.dart';
import 'package:rentit_app/helper%20classes/trip.dart';
import 'package:rentit_app/providers/terminal_provider.dart';
import 'package:rentit_app/providers/trip_provider.dart';
import 'package:rentit_app/screens/profile_screen.dart';

import 'login_screen.dart';

class DriWelcomeScreen extends StatefulWidget {
  @override
  _DriWelcomeScreenState createState() => _DriWelcomeScreenState();
}

class _DriWelcomeScreenState extends State<DriWelcomeScreen>
    with SingleTickerProviderStateMixin {
  final List<Tab> tab = <Tab>[
    Tab(text: 'Current Ride'),
    Tab(text: 'Completed'),
  ];

  late TabController tabController;

  List<Trip> listTrips = [];
  List<Trip> driverTrip = [];
  List<Trip> completedTrips = [];
  late Trip currentTrip;

  get vsync => this;

  List<String> terminalsList = [

  ];

  List<Terminal> listTerminal=[];
  String selectedTerminal = '';

  final TextEditingController meterController = TextEditingController();

  void getListTrips() async {
    User? u =   FirebaseAuth.instance.currentUser;

    listTrips =
        await Provider.of<TripProvider>(context, listen: false).getListTrip();

    if (listTrips.isNotEmpty) {
      for (var a in listTrips) {
        if (a.optionDriver == true) {
          if (a.driver!.email == u!.email) {
            print('0000000000000000000000000000000000000000000000000000000');
            print(a.driver!.name);
            print('0000000000000000000000000000000000000000000000000000000');

            driverTrip.add(a);
          }
        }
      }
    }

    if (driverTrip != null) {
      print('.....................................................');
      for (var ab in driverTrip) {
        if (ab.status == 'current') {
          setState(() {
            currentTrip = ab;
          });

          break;
        } else if (ab.status == 'accepted') {
          setState(() {
            currentTrip = ab;
          });
          break;
        } else if (ab.status == 'ending') {
          setState(() {
            currentTrip = ab;
          });
          break;
        } else if (ab.status == 'end') {
          setState(() {
            currentTrip = ab;
          });
          break;
        } else if (ab.status == 'completed') {
          setState(() {
            completedTrips.add(ab);
          });
        }
      }
    }

    if (currentTrip != null) {
      setState(() {
        getStartReading();
      });
    }
  }

  void getTerminals() {

    listTerminal= Provider.of<TerminalProvider>(context, listen: false).listTerminals;

    if(listTerminal.isNotEmpty)
      {
        for(var a in listTerminal)
          {
            terminalsList.add(a.name);
          }
      }
  }

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: tab.length, vsync: vsync);

    getTerminals();
    getListTrips();
  }

  bool isStarted = false;
  bool isCompleted = false;
  double startReading = -1;

  String fair = 'calculating...';

  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();

  void getStartReading() async {
    setState(() {
      startReading = currentTrip.readingAtStart;
    });
  }

  String? validateEndReading(String? value) {
    String patttern = r'([0-9]+(\.[0-9]+)?)';
    RegExp regExp = new RegExp(patttern);
    if (value!.length == 0) {
      return 'Please fill this field';
    } else if ((!regExp.hasMatch(value)) ||
        (double.parse(value) < startReading)) {
      return 'Please enter valid reading';
    }
    return null;
  }

  void updateDriver() async {
    currentTrip.driver!.driverOnTrip=false;
    Map<String, dynamic> mapUpdate = currentTrip.driver!.converttoJson();

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


  Future<void> saveReading() async {
    print(currentTrip.customer!.name);
    print(currentTrip.driver!.name);
    Map<String, dynamic> mapUpdate = currentTrip.converttoJson();

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

          actions: [
            Theme(
              data: Theme.of(context).copyWith(
                dividerColor: Colors.indigo,
                iconTheme: IconThemeData(color: Colors.white),
                textTheme: TextTheme().apply(bodyColor: Colors.indigo),
              ),
              child:  PopupMenuButton<int>(
                // color: Colors.deepPurple,
                onSelected: (item) => onSelected(context, item),
                itemBuilder: (context)=>[
                  const PopupMenuItem<int>(
                    value: 0,
                    child: Text('My Profile', style: TextStyle(color: Colors.indigo),),
                  ),
                  // const PopupMenuDivider(),
                  PopupMenuItem<int>(
                    value: 1,
                    child: Row(
                      children: const [
                        Icon(
                          Icons.logout, color: Colors.indigo,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text('Logout', style: TextStyle(color: Colors.indigo),)
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
          automaticallyImplyLeading: false,
          title: Text('My Dashboard'),
          // centerTitle: true,
          bottom: TabBar(
            controller: tabController,
            tabs: tab,
          ),
        ),
        body: Container(
          child: TabBarView(
            controller: tabController,
            children: [
              ((currentTrip==null) &&
                      ((currentTrip.status == 'accepted') ||
                          (currentTrip.status == 'current')))
                  ? SingleChildScrollView(
                      child: Column(
                        children: [
                          DriCustomCard(
                              category: currentTrip.vehicle!.category,
                              vehicle: currentTrip.vehicle!.vMake,
                              status: currentTrip.status,
                              fromTerminal: currentTrip.terminal!.name,
                              cusEmail: currentTrip.customer!.email,
                              text: 'Ride'),
                          isStarted
                              ? ElevatedButton(
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          content: Form(
                                            key: _globalKey,
                                            child: Column(
                                              children: [
                                                TextFormField(
                                                  controller: meterController,
                                                  decoration: kTextFormFieldDecoration
                                                      .copyWith(
                                                          labelText:
                                                              'Current Meter Reading',
                                                          hintText: ''),
                                                  validator: validateEndReading,
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                Container(
                                                  padding: EdgeInsets.all(8),
                                                  child: buildDropdownSearch(
                                                      'Select your nearest terminal',
                                                      terminalsList,
                                                      'Terminal'
                                                  ),
                                                ),
                                              ],
                                            ),

                                          ),
                                          actions: [
                                            ElevatedButton(
                                              onPressed: () async {
                                                if (_globalKey.currentState!
                                                    .validate()) {
                                                  currentTrip.readingAtEnd =
                                                      double.parse(
                                                          meterController.text
                                                              .trim());

                                                  setState(() {
                                                    currentTrip.status =
                                                        'ending';
                                                    fair = ((currentTrip
                                                                    .readingAtEnd -
                                                                currentTrip
                                                                    .readingAtStart) *
                                                            100)
                                                        .toString();
                                                    isCompleted = true;
                                                  });

                                                  updateDriver();
                                                  await saveReading();

                                                  Navigator.pop(context);
                                                }
                                              },
                                              child: const Text(
                                                'Proceed',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                              style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStateProperty.all(
                                                        Colors.blue),
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  child: const Text(
                                    'End Ride',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  style: ButtonStyle(
                                    padding: MaterialStateProperty.all(
                                        EdgeInsets.all(8)),
                                    backgroundColor:
                                        MaterialStateProperty.all(Colors.blue),
                                  ),
                                )
                              : ElevatedButton(
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          content: Form(
                                            key: _globalKey,
                                            child: TextFormField(
                                              controller: meterController,
                                              decoration: kTextFormFieldDecoration
                                                  .copyWith(
                                                      labelText:
                                                          'Current Meter Reading',
                                                      hintText: ''),
                                              validator: validateEndReading,
                                            ),
                                          ),
                                          actions: [
                                            ElevatedButton(
                                              onPressed: () async {
                                                if (_globalKey.currentState!
                                                    .validate()) {
                                                  setState(() {
                                                    startReading = double.parse(
                                                        meterController.text
                                                            .trim());
                                                    isStarted = true;
                                                  });

                                                  setState(() {
                                                    currentTrip.readingAtStart =
                                                        startReading;
                                                    currentTrip.status =
                                                        'current';
                                                  });

                                                  await saveReading();

                                                  Navigator.pop(context);
                                                }
                                              },
                                              child: const Text(
                                                'Go',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                              style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStateProperty.all(
                                                        Colors.green),
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  child: const Text(
                                    'Start',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  style: ButtonStyle(
                                    padding: MaterialStateProperty.all(
                                        EdgeInsets.all(8)),
                                    backgroundColor:
                                        MaterialStateProperty.all(Colors.green),
                                  ),
                                )
                        ],
                      ),
                    )
                  :
              isCompleted
                      ? Center(
                          child: ElevatedButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    content: Container(
                                      height: 50,
                                      // child: Padding(
                                      // padding: const EdgeInsets.all(8.0),
                                      child: Center(
                                          child: Text(
                                        fair,
                                        style: TextStyle(
                                            fontSize: 25,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.blue),
                                      )),
                                      // ),
                                    ),
                                    actions: [
                                      ElevatedButton(
                                        onPressed: () {
                                          setState(() {
                                            isCompleted = false;
                                          });

                                          Navigator.pop(context);
                                        },
                                        child: Text('Close'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            child: Text('Show Fair'),
                          ),
                        )
                      : NoDataDisplayWidget(),
              SingleChildScrollView(
                child: Container(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(8, 8, 0, 8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        completedTrips .isNotEmpty
                            ? getWidgets(completedTrips)
                            : NoDataDisplayWidget(),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  DropdownSearch<String> buildDropdownSearch(String hint, List<String> list, String label) {
    return DropdownSearch(
      validator: (value) {
        if (value == null) {
          return 'Field required';
        } else {
          return null;
        }

      },
      showSearchBox: true,
      autoFocusSearchBox: true,

      dropdownSearchDecoration: const InputDecoration(
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.lightBlueAccent,),
        ),
      ),
      hint: hint,
      mode: Mode.DIALOG,
      showSelectedItem: true,
      items: list,
      loadingBuilder: (context, searchEntry) => const Center(child: Text('Loading...',
        style: TextStyle(color: Colors.deepPurple, fontSize: 30, fontWeight: FontWeight.bold ),)),
      label: label,
      showClearButton: true,
      onChanged: (value) {
        setState(() {
          selectedTerminal = value!;
          print('selectedTerminal : $selectedTerminal');
        });
      },

      clearButtonSplashRadius: 20,
    );
  }

  onSelected(BuildContext context, int item) async {
    switch(item){
      case 0: {
        Navigator.push(context, MaterialPageRoute(builder: (context)=> const ProfileScreen()));
        break;
      }
      case 1:{
        await  FirebaseAuth.instance.signOut();
        Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginScreen()));
        break;
      }
    }
  }



}

Widget getWidgets(List<Trip> rides) {
  List<Widget> list = [];
  for (var i = 0; i < rides.length; i++) {
    var num = i + 1;
    list.add(new DriCustomCard(
        category: rides[i].vehicle!.category,
        vehicle: rides[i].vehicle!.vMake,
        status: rides[i].status,
        fromTerminal: rides[i].terminal!.name,
        cusEmail: rides[i].customer!.email,
        text: 'Ride $num'));
  }
  return new Column(children: list);
}
