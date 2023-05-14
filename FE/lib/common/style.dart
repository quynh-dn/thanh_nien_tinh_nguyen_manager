import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Color backgroundPageColor = const Color(0xffF5F7FB);
Color mainColor = const Color(0xFF023E74);

TextStyle titleWidget = GoogleFonts.montserrat(color: const Color(0xff1C4281), fontSize: 20, fontWeight: FontWeight.bold, decoration: TextDecoration.none);
TextStyle textBtn = GoogleFonts.montserrat(
  letterSpacing: 0.1,
  wordSpacing: 1,
  height: 1.2,
  color: Colors.white,
  fontSize: 14,
  fontWeight: FontWeight.w600,
);
TextStyle titlePage = GoogleFonts.montserrat(fontSize: 30, fontWeight: FontWeight.w700, color: Colors.black);
TextStyle textNormal = GoogleFonts.montserrat(fontSize: 20, fontWeight: FontWeight.normal, color: Colors.black);
TextStyle textTitleNavbar = GoogleFonts.montserrat(fontSize: 24, fontWeight: FontWeight.w500, color: Colors.white);
TextStyle textTitleNavbarBlack = GoogleFonts.montserrat(fontSize: 24, fontWeight: FontWeight.w600, color: Colors.black);
TextStyle textDropdownTitle = GoogleFonts.montserrat(fontSize: 13, fontWeight: FontWeight.w500, color: Colors.black);
TextStyle textDropdownTitleRed = GoogleFonts.montserrat(fontSize: 13, fontWeight: FontWeight.w500, color: Color.fromARGB(255, 251, 8, 8));
TextStyle textDropdownTitleMain = GoogleFonts.montserrat(fontSize: 13, fontWeight: FontWeight.w500, color: mainColor);
TextStyle textDropdownTitleOrange = GoogleFonts.montserrat(fontSize: 13, fontWeight: FontWeight.w500, color: Color.fromARGB(255, 255, 181, 8));
TextStyle textDropdownTitleGreen = GoogleFonts.montserrat(fontSize: 13, fontWeight: FontWeight.w500, color: Color.fromARGB(255, 17, 252, 13));
TextStyle textCardContentBlack = GoogleFonts.montserrat(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black);
TextStyle textCardContentBlue = GoogleFonts.montserrat(fontSize: 13, fontWeight: FontWeight.normal, color: const Color.fromRGBO(2, 62, 116, 1));
TextStyle textCardTitle = GoogleFonts.montserrat(fontSize: 17, fontWeight: FontWeight.w600, color: const Color.fromRGBO(2, 62, 116, 1));
TextStyle titleContainerBox = GoogleFonts.montserrat(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black);
TextStyle titleContainerBoxRed = GoogleFonts.montserrat(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.red);
TextStyle titleContainerBoxBlue = GoogleFonts.montserrat(fontSize: 16, fontWeight: FontWeight.w600, color: const Color.fromRGBO(2, 62, 116, 1));
TextStyle titleContainerBoxOrange = GoogleFonts.montserrat(fontSize: 16, fontWeight: FontWeight.w600, color:  Color.fromARGB(255, 255, 181, 8));
TextStyle titleContainerBoxGreen = GoogleFonts.montserrat(fontSize: 16, fontWeight: FontWeight.w600, color: Color.fromARGB(255, 17, 252, 13));

TextStyle textBtnWhite = GoogleFonts.montserrat(fontSize: 13, fontWeight: FontWeight.normal, color: Colors.white);
TextStyle textBtnBlack = GoogleFonts.montserrat(fontSize: 13, fontWeight: FontWeight.normal, color: Colors.black);
TextStyle textDataColumn = GoogleFonts.montserrat(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.black);
TextStyle textDataRow = GoogleFonts.montserrat(fontSize: 13, fontWeight: FontWeight.w400, color: Colors.black);
TextStyle textBtnTopic = GoogleFonts.montserrat(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black);
TextStyle textBtnTopicWhite = GoogleFonts.montserrat(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white);
TextStyle textTitleAlertDialog = GoogleFonts.montserrat(fontSize: 24, fontWeight: FontWeight.w500, color: Colors.black);
double verticalPaddingPage = 35;
double horizontalPaddingPage = 50;

EdgeInsets paddingPage = EdgeInsets.symmetric(vertical: verticalPaddingPage, horizontal: horizontalPaddingPage);

BoxShadow containerShadow = BoxShadow(
  color: Colors.grey.withOpacity(0.1),
  spreadRadius: 4,
  blurRadius: 6,
  offset: const Offset(0, 3),
);
//margin box
double marginRight = 120;
double marginRightForm = 50;
BoxShadow boxShadowContainer = BoxShadow(
  color: Color.fromARGB(255, 224, 224, 224).withOpacity(0.5),
  spreadRadius: 2,
  blurRadius: 12,
  offset: Offset(4, 8), // changes position of shadow
);

const borderRadiusContainer = BorderRadius.all(
  Radius.elliptical(8, 8),
);
Border borderAllContainerBox = Border.all(width: 1, color: Color(0xffDADADA));

Color colorIconTitleBox = Color(0xff9aa5ce);
final double sizeIconTitleBox = 14;
const marginTopBottomHorizontalLine = EdgeInsets.only(
  top: 10,
  bottom: 20,
);
const ColorHorizontalLine = Color.fromARGB(255, 174, 174, 174);
