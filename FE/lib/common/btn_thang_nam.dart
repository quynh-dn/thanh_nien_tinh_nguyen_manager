import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

enum Time { thang, nam }

// ignore: must_be_immutable
class ThangNamBtn extends StatefulWidget {
  Time time;
  Function function;
  ThangNamBtn({super.key, required this.time, required this.function});

  @override
  State<ThangNamBtn> createState() => _ThangNamBtnState();
}

class _ThangNamBtnState extends State<ThangNamBtn> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          decoration: BoxDecoration(
            color: widget.time == Time.thang
                ? const Color(0xffB3D5F1)
                : Colors.white,
            border: Border.all(color: const Color(0xffB3D5F1)),
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(15), bottomLeft: Radius.circular(15)),
          ),
          child: TextButton(
              onPressed: () {
                widget.time = Time.thang;
                widget.function(Time.thang);
                setState(() {});
              },
              style: ButtonStyle(
                padding: MaterialStateProperty.all<EdgeInsets>(
                    const EdgeInsets.all(0)),
                shape: MaterialStateProperty.all(
                  const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        bottomLeft: Radius.circular(15)),
                  ),
                ),
              ),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
                child: Text(
                  'Tháng',
                  style: GoogleFonts.montserrat(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.black),
                ),
              )),
        ),
        Container(
          decoration: BoxDecoration(
            color: widget.time == Time.nam
                ? const Color(0xffB3D5F1)
                : Colors.white,
            border: Border.all(color: const Color(0xffB3D5F1)),
            borderRadius: const BorderRadius.only(
                topRight: Radius.circular(15),
                bottomRight: Radius.circular(15)),
          ),
          child: TextButton(
              onPressed: () {
                widget.time = Time.nam;
                widget.function(Time.nam);
                setState(() {});
              },
              style: ButtonStyle(
                padding: MaterialStateProperty.all<EdgeInsets>(
                    const EdgeInsets.all(0)),
                shape: MaterialStateProperty.all(
                  const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(15),
                        bottomRight: Radius.circular(15)),
                  ),
                ),
              ),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
                child: Text(
                  'Năm',
                  style: GoogleFonts.montserrat(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xff023E74)),
                ),
              )),
        )
      ],
    );
  }
}
