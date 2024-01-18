// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:disability_app/screens/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FeatureBox extends StatelessWidget {
  final Color color;
  final String headerText;
  final String descriptionText;
  const FeatureBox({
    Key? key,
    required this.color,
    required this.headerText,
    required this.descriptionText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: 35,
        vertical: 10
      ),
      decoration: BoxDecoration(
       color: color ,
       borderRadius: BorderRadius.all(
        Radius.circular(15)
       )

      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20,
         ).copyWith(left: 15),
        child: Column(children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(headerText,
            style: GoogleFonts.poppins(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Pallete.blackColor
            ),),
            
          ),
          SizedBox(height: 3,),
          Text(descriptionText,
          style: GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Pallete.blackColor
          ),)
        ]),
      ),
    );
  }
}
