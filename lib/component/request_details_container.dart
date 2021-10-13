import 'package:flutter/material.dart';

class RequestDetailsContainer extends StatelessWidget {
  const RequestDetailsContainer({
     required this.terminal, required this.vehicle, required this.category, required this.isDriver, required this.status

  }) ;

  final String terminal;
  final String vehicle;
  final String category;
  final bool isDriver;
  final String status;



  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          boxShadow: [BoxShadow(
              blurRadius: 20,
              color: Colors.black38
          ),],
          color: Color(0xFFF7F6F2),
          border: Border(
              bottom: BorderSide(
                color: Color(0xFFC8C6C6),
              )
          )
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 25,
                ),

                Text(
                  'Terminal',
                  style: TextStyle(
                    fontSize: 12.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                Text(
                  'Vehicle',
                  style: TextStyle(
                    fontSize: 12.0,
                    fontWeight: FontWeight.bold,

                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                Text(
                  'Category  ',
                  style: TextStyle(
                    fontSize: 12.0,
                    fontWeight: FontWeight.bold,

                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                Text(
                  'Driver ',
                  style: TextStyle(
                    fontSize: 12.0,
                    fontWeight: FontWeight.bold,

                  ),
                ),
                SizedBox(
                  height: 25,
                ),

                Text(
                  'Trip Status ',
                  style: TextStyle(
                    fontSize: 12.0,
                    fontWeight: FontWeight.bold,

                  ),
                ),
                SizedBox(
                  height: 25,
                ),
              ],
            ),
          ),
          SizedBox(
            width: 55,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 25,
              ),
              Text(
                terminal,
                style: TextStyle(
                  fontSize: 12.0,
                ),
              ),
              SizedBox(
                height: 25,
              ),
              Text(
                vehicle,
                style: TextStyle(
                  fontSize: 12.0,
                ),
              ),
              SizedBox(
                height: 25,
              ),
              Text(
                category,
                style: TextStyle(
                  fontSize: 12.0,
                ),
              ),
              SizedBox(
                height: 25,
              ),
              Text(
                isDriver ? 'Yes' : 'No',
                style: TextStyle(
                  fontSize: 12.0,
                ),
              ),
              SizedBox(
                height: 25,
              ),

              // Text(
              //   status,
              //   style: TextStyle(
              //     fontSize: 12.0,
              //   ),
              // ),
              SizedBox(
                height: 25,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
