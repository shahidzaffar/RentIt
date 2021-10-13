

import 'package:flutter/material.dart';

class DriDetailsContainer extends StatelessWidget {
  const DriDetailsContainer({
      required this.vehicle,  required this.category,  required this.cusEmail,
    required this.fromTerminal,

  }) ;


  final String fromTerminal;
  final String vehicle;
  final String category;
  final String cusEmail;




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
              ),
            top: BorderSide(
              color: Color(0xFFC8C6c1),
            ),
            right: BorderSide(
              color: Color(0xFFC8C6c1),
            ),
            left: BorderSide(
              color: Color(0xFFC8C6c1),
            ),
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
                  'From',
                  style: TextStyle(
                    fontSize: 12.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 25,
                ),

                Text(
                  'Customer',
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

              SizedBox(
                height: 25,
              ),
              Text(
                fromTerminal,
                style: TextStyle(
                  fontSize: 12.0,
                ),
              ),
              SizedBox(
                height: 25,
              ),
              Text(
                cusEmail,
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

            ],
          ),
        ],
      ),
    );
  }
}
