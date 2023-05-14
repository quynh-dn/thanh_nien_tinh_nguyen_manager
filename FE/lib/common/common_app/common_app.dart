import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:haivn/common/dropdown.dart';
import 'package:haivn/common/style.dart';

class CommonApp {
 
  //footer
  Widget footerApp() {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 50,
            decoration: const BoxDecoration(color: Color(0xff2B5378)),
            child: Center(
                child: Text(
                    "Hệ thống quản lý tình nguyện viên",
                    style: GoogleFonts.montserrat(fontSize: 18, fontWeight: FontWeight.w400, color: Colors.white))),
          ),
        ),
      ],
    );
  }

  //loading khi call api
  Widget loadingCallAPi({String? contentLoading}) {
    return Container(
      child: Column(
        // crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Center(child: CircularProgressIndicator()),
          CommonApp().sizeBoxWidget(height: 10),
          Center(
            child: Text(
              contentLoading ?? "Loading...",
              style: const TextStyle(color: Color.fromARGB(255, 78, 78, 78), fontSize: 16),
            ),
          )
        ],
      ),
    );
  }

  //Đường kẻ chân trang
  Widget dividerWidget({required double height}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Divider(
        height: height,
        thickness: 0.2,
        color: Colors.black,
      ),
    );
  }

  //sizeBox
  Widget sizeBoxWidget({double? width, double? height}) {
    return SizedBox(
      width: width ?? 0,
      height: height ?? 0,
    );
  }

  //dropdowWidget
  Widget dropdowBox({String? lable, dynamic functionCallBack, dynamic selectValue, List<dynamic>? listItems, String? hintext}) {
    return Container(
      margin: const EdgeInsets.only(left: 50),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            lable ?? '',
            style: textDropdownTitle,
          ),
          CommonApp().sizeBoxWidget(height: 10),
          DropdownBtn(
            function: functionCallBack,
            listItem: listItems,
            selectedValue: selectValue,
            hintText: hintext,
            width: 200,
            decoration: BoxDecoration(border: Border.all(width: 1 / 5, color: Colors.black45), borderRadius: BorderRadius.circular(5)),
          )
        ],
      ),
    );
  }
}
