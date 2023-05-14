import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class DatePickerBox extends StatefulWidget {
  double? width;
  DateTime? selectedDate;
  BoxDecoration? decoration;
  Function callBack;
  bool? isHourl;
  Function? callBackHuor;
  String? selectedHour;
  DatePickerBox({super.key, this.width, this.decoration, required this.selectedDate, required this.callBack, this.isHourl, this.callBackHuor, this.selectedHour});

  @override
  State<DatePickerBox> createState() => _DatePickerBoxState();
}

class _DatePickerBoxState extends State<DatePickerBox> {
  DateTime selectedDate = DateTime.now();
  bool checkShow = false;
  String? timeDisplay;

  _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime(3000),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  TimeOfDay _time = TimeOfDay(hour: 7, minute: 15);
  void _selectTime() async {
    final TimeOfDay? newTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
        builder: (context, childWidget) {
          return MediaQuery(
              data: MediaQuery.of(context).copyWith(
                  // Using 24-Hour format
                  alwaysUse24HourFormat: true),
              child: childWidget!);
        });
    if (newTime != null) {
      setState(() {
        _time = newTime;
        if (_time.hour > 9) {
          if (_time.minute > 9) {
            timeDisplay = "${_time.hour}:${_time.minute}";
          } else {
            timeDisplay = "${_time.hour}:0${_time.minute}";
          }
        } else {
          if (_time.minute > 9) {
            timeDisplay = "0${_time.hour}:${_time.minute}";
          } else {
            timeDisplay = "0${_time.hour}:0${_time.minute}";
          }
        }
        widget.callBackHuor!(timeDisplay);
      });
    }
  }

  @override
  void initState() {
    // selectedDate = widget.selectedDate ?? DateTime.now();
    if (widget.selectedDate == null) {
      checkShow = false;
    } else {
      checkShow = true;
      selectedDate = widget.selectedDate!;
    }
    if (widget.selectedHour != null) {
      timeDisplay = widget.selectedHour;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      decoration: widget.decoration,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                // margin: const EdgeInsets.only(right: 20),
                child: (!checkShow)
                    ? IconButton(
                        onPressed: () async {
                          await _selectDate(context);
                          widget.callBack(selectedDate);
                          checkShow = true;
                        },
                        icon: const Icon(Icons.date_range_outlined))
                    : IconButton(
                        onPressed: () {
                          setState(() {
                            selectedDate = DateTime.now();
                            widget.callBack(null);
                            checkShow = false;
                          });
                        },
                        icon: const Icon(Icons.close),
                      ),
              ),
              Text(
                (checkShow) ? DateFormat('dd-MM-yyyy').format(selectedDate) : "Chọn ngày",
                style: GoogleFonts.montserrat(fontSize: 14, fontWeight: FontWeight.normal, color: Colors.black),
              ),
            ],
          ),
          (widget.isHourl == true)
              ? Container(
                  width: 120,
                  margin: const EdgeInsets.only(left: 5),
                  height: 40,
                  padding: const EdgeInsets.only(left: 10),
                  decoration: widget.decoration,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      timeDisplay == null
                          ? IconButton(onPressed: () => _selectTime(), icon: Icon(Icons.schedule), color: Color.fromARGB(255, 0, 0, 0))
                          : IconButton(
                              onPressed: () {
                                setState(() {
                                  timeDisplay = null;
                                  widget.callBackHuor!(timeDisplay);
                                });
                              },
                              icon: Icon(Icons.close)),
                      Text(timeDisplay ?? 'Chọn giờ', style: GoogleFonts.montserrat(fontSize: 14, fontWeight: FontWeight.normal, color: Colors.black)),
                      const SizedBox(width: 5),
                    ],
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}
