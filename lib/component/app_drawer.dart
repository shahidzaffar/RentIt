import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rentit_app/screens/cus_welcome_screen.dart';
import 'package:rentit_app/screens/login_screen.dart';
import 'package:rentit_app/screens/my_dashboard.dart';

class AppDrawer extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(

        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: [
          _createHeader(),
          _createDrawerItem(icon: Icons.home, text: 'Home',
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context)=>CusWelcomeScreen()))),
          Divider(),
          _createDrawerItem(icon: Icons.category, text: 'My Dashboard',
              onTap: () => Navigator.push(context,MaterialPageRoute(builder: (context)=>MyDashboard(stat: '',)))),
          Divider(),

          ListTile(
            title: Row(
              children: const <Widget>[
                Icon(Icons.logout_rounded),
                Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: Text('Logout'),
                )
              ],
            ),
          onTap: ()  async {
            await  FirebaseAuth.instance.signOut();
            Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginScreen()));
          },
          ),

        ],
      ),
    );
  }
}


Widget _createHeader() {
  return DrawerHeader(
      margin: EdgeInsets.zero,
      padding: EdgeInsets.zero,
      decoration: BoxDecoration(
          image: DecorationImage(
              fit: BoxFit.fill,
              image:  AssetImage('images/drawer.png'))),
      child: Stack(children: <Widget>[
        Positioned(
            bottom: 12.0,
            left: 16.0,
            child: Text("RentIt : Car rental service",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                    fontWeight: FontWeight.w500))),
      ]));
}


Widget _createDrawerItem(
    { required IconData icon, required String text, required GestureTapCallback onTap}) {
  return ListTile(
    title: Row(
      children: <Widget>[
        Icon(icon),
        Padding(
          padding: EdgeInsets.only(left: 8.0),
          child: Text(text),
        )
      ],
    ),
    onTap: onTap,
  );
}