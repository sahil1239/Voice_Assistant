import 'package:flutter/material.dart';
import 'package:voice_assistant/palette.dart';

class Featurebox extends StatelessWidget {
  final String heading;
  final String description;
  final Color color;
  const Featurebox(
      {required this.heading, required this.description, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 22, vertical: 20),
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Text(
              heading,
              style: TextStyle(
                fontFamily: 'Cera Pro',
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Pallete.mainFontColor,
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.only(right: 15),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                description,
                style: TextStyle(
                  fontFamily: 'Cera Pro',
                  fontSize: 14,
                  color: Pallete.mainFontColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
