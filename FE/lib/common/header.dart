// ignore_for_file: curly_braces_in_flow_control_structures, unused_local_variable, prefer_const_constructors, await_only_futures

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:haivn/api.dart';
import 'package:haivn/common/common_app/common_app.dart';
import 'package:localstorage/localstorage.dart';
import 'package:provider/provider.dart';
import '../model/model.dart';
import '../model/model_qltvn/tinh-nguyen-vien.dart';
import '../ui/change-password.dart';
import '../ui/info-user.dart';
import '../web_config.dart';
import 'style.dart';

ScrollController scrollControllerHideMenu = ScrollController();

// ignore: must_be_immutable
class Header extends StatefulWidget {
  Header({super.key, required this.content});
  Widget content;
  @override
  State<Header> createState() => _HeaderState();
}

class _HeaderState extends State<Header> {
  List<GlobalKey> btn = [
    GlobalKey(),
    GlobalKey(),
    GlobalKey(),
    GlobalKey(),
    GlobalKey(),
    GlobalKey(),
    GlobalKey(),
    GlobalKey(),
  ];
  dynamic listMenuAdmin = [
    [
      {'title': 'QUẢN LÝ TNV', 'url': '/quan-ly-tnv'},
      {'title': 'QUẢN LÝ ĐĂNG KÝ', 'url': '/quan-ly-dang-ky'},
      {'title': 'LỊCH PHỎNG VẤN', 'url': '/lich-phong-van'},
    ],
    [
      {'title': 'QUẢN LÝ CHỨC VỤ', 'url': "/quan-ly-chuc-vu"},
      {'title': 'QUẢN LÝ LỚP', 'url': '/quan-ly-lop-hoc'},
      {'title': 'QUẢN LÝ POSTER', 'url': "/quan-ly-poster"},
      {'title': 'QUẢN TRỊ VIÊN', 'url': '/quan-tri-vien'},
    ],
    [
      {'title': 'QUẢN LÝ', 'url': "/phong-trao-su-kien"},
      {'title': 'TNV THAM GIA', 'url': '/tnv-tham-gia'},
    ],
    [
      {'title': 'TÌM KIẾM', 'url': "/phong-trao-su-kien-tnv"},
      {'title': 'LỊCH SỬ ĐĂNG KÝ', 'url': '/lich-su-dang-ky'},
    ],
  ];
  final textButtonFocusNode = FocusNode();
  bool showMenuCheck = false;
  GlobalKey menu = GlobalKey();
  double xMenu = 0;
  double yMenu = 0;
  double offset = 0.0;
  LocalStorage storage = LocalStorage("storage");
  late bool statusShow;
  TinhNguyenVien userLogin = TinhNguyenVien();
  String name = "";

  late int responseSVDK;
  late int countTNVTG;

  callTongSVDangKy() async {
    var responseSVDKCall = await httpGet("/api/sinh-vien-dang-ky/get/stt0", context);
    var bodySDK = jsonDecode(responseSVDKCall["body"]);
    responseSVDK = await bodySDK;
  }

  callTongTNVTG() async {
    var responseCall = await httpGet("/api/tnv-ptsk/get/page?filter=status:0", context);
    var bodySDK = jsonDecode(responseCall["body"]);
    countTNVTG = bodySDK['result']['totalElements'];
  }

  callNguoiDung() async {
    var responseNguoiDung = await httpGet("/api/nguoi-dung/get/$id", context);
    var bodyNguoiDung = jsonDecode(responseNguoiDung["body"]);
    userLogin = TinhNguyenVien.fromJson(bodyNguoiDung['result']);
    List<String> listName = userLogin.fullName!.split(" ");
    name = listName.last;
  }

  String? role;
  String? id;

  void callAPI() async {
    setState(() {
      statusShow = false;
      countTNVTG = 0;
      responseSVDK = 0;
    });
    role = storage.getItem("role");
    id = storage.getItem("id");
    await callNguoiDung();
    await callTongSVDangKy();
    await callTongTNVTG();
    setState(() {
      statusShow = true;
    });
  }

  @override
  void initState() {
    super.initState();
    callAPI();
  }

  @override
  void dispose() {
    scrollControllerHideMenu.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        backgroundColor: backgroundPageColor,
        body: (statusShow == true)
            ? Column(
                children: [
                  Container(
                    height: 85,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Expanded(
                          flex: 7,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 20, top: 5, bottom: 5),
                                  child: Image.asset('images/logo.png'),
                                ),
                                const Text(
                                  'QUẢN LÝ ĐỘI THANH NIÊN TÌNH NGUYỆN',
                                  style: TextStyle(color: Color(0xff1C4281), fontSize: 25, fontWeight: FontWeight.bold, decoration: TextDecoration.none),
                                )
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                            flex: 3,
                            child: Padding(
                              padding: const EdgeInsets.only(right: 50),
                              child: PopupMenuButton(
                                tooltip: 'Thông tin cá nhân',
                                offset: const Offset(0.0, 85),
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 20),
                                  child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                                    Padding(
                                      padding: const EdgeInsets.only(right: 15),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            name,
                                            style: TextStyle(fontSize: 16),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            (role == "0") ? 'ADMIN' : "${userLogin.chucVu!.name}",
                                            style: TextStyle(fontSize: 12),
                                          )
                                        ],
                                      ),
                                    ),
                                    CircleAvatar(
                                        child: Container(
                                      width: 100,
                                      height: 100,
                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(50)),
                                      child: (userLogin.avatar == null || userLogin.avatar == "")
                                          ? Image.asset(
                                              "/images/noavatar.png",
                                              width: 100,
                                              height: 100,
                                              fit: BoxFit.cover,
                                            )
                                          : Image.network(
                                              "$baseUrl/api/files/${userLogin.avatar}",
                                              width: 100,
                                              height: 100,
                                              fit: BoxFit.cover,
                                            ),
                                    ))
                                  ]),
                                ),
                                itemBuilder: (BuildContext context) => [
                                  const PopupMenuItem(
                                    enabled: false,
                                    padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
                                    child: Text(
                                      'Cài đặt',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.blueGrey,
                                      ),
                                    ),
                                  ),
                                  PopupMenuItem(
                                    padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                                    child: ListTile(
                                      leading: Container(width: 30, height: 30, alignment: Alignment.center, decoration: BoxDecoration(borderRadius: BorderRadius.circular(40), color: const Color.fromARGB(235, 209, 209, 209)), child: const Icon(Icons.person)),
                                      contentPadding: const EdgeInsets.all(0),
                                      hoverColor: Colors.transparent,
                                      title: const Text(
                                        'Thông tin',
                                        style: TextStyle(
                                          color: Colors.black,
                                        ),
                                      ),
                                      onTap: (() {
                                        showDialog(
                                            context: context,
                                            builder: (BuildContext context) => InforUser(
                                                  data: userLogin,
                                                  callBack: (value) {
                                                    setState(() {
                                                      userLogin = value;
                                                      List<String> listName = userLogin.fullName!.split(" ");
                                                      name = listName.last;
                                                    });
                                                  },
                                                ));
                                      }),
                                    ),
                                  ),
                                  PopupMenuItem(
                                    padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                                    child: ListTile(
                                      leading: Container(width: 30, height: 30, alignment: Alignment.center, decoration: BoxDecoration(borderRadius: BorderRadius.circular(40), color: const Color.fromARGB(235, 209, 209, 209)), child: const Icon(Icons.key)),
                                      contentPadding: const EdgeInsets.all(0),
                                      hoverColor: Colors.transparent,
                                      title: const Text(
                                        'Đổi mật khẩu',
                                        style: TextStyle(
                                          color: Colors.black,
                                        ),
                                      ),
                                      onTap: (() {
                                        showDialog(context: context, builder: (BuildContext context) => ChangePassword());
                                      }),
                                    ),
                                  ),
                                  PopupMenuItem(
                                    padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                                    child: ListTile(
                                      leading: Container(width: 30, height: 30, alignment: Alignment.center, decoration: BoxDecoration(borderRadius: BorderRadius.circular(40), color: const Color.fromARGB(235, 209, 209, 209)), child: const Icon(Icons.logout)),
                                      contentPadding: const EdgeInsets.all(0),
                                      hoverColor: Colors.transparent,
                                      title: const Text(
                                        'Đăng xuất',
                                        style: TextStyle(
                                          color: Colors.black,
                                        ),
                                      ),
                                      onTap: (() {
                                        context.go('/login-page');
                                        storage.deleteItem("id");
                                        storage.deleteItem("role");
                                      }),
                                    ),
                                  ),
                                ],
                              ),
                            ))
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          key: menu,
                          // height: 70,
                          decoration: const BoxDecoration(
                              color: Color(0xff1C4281),
                              border: Border(
                                right: BorderSide(width: 0.5, color: Colors.white),
                                left: BorderSide(width: 0.5, color: Colors.white),
                              )),
                          child: (role == "0")
                              ? Row(
                                  children: [
                                    Expanded(
                                      flex: 3,
                                      child: Container(
                                        decoration: const BoxDecoration(
                                            border: Border(
                                          right: BorderSide(width: 0.5, color: Colors.white),
                                          bottom: BorderSide(width: 0.5, color: Colors.white),
                                        )),
                                        key: btn[0],
                                        child: TextButton(
                                          focusNode: textButtonFocusNode,
                                          onHover: (val) {},
                                          style: TextButton.styleFrom(
                                            foregroundColor: Theme.of(context).iconTheme.color,
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 30.0,
                                              horizontal: 10.0,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(5.0),
                                            ),
                                            // backgroundColor: const Color.fromRGBO(85, 134, 175, 1),
                                            textStyle: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 20.0, letterSpacing: 2.0),
                                          ),
                                          onPressed: () {
                                            context.go("/trang-chu");
                                          },
                                          child: Text(
                                            'TRANG CHỦ',
                                            style: textBtn,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 4,
                                      child: Container(
                                        width: MediaQuery.of(context).size.width * 4 / 15,
                                        decoration: const BoxDecoration(
                                            border: Border(
                                          right: BorderSide(width: 0.5, color: Colors.white),
                                          bottom: BorderSide(width: 0.5, color: Colors.white),
                                        )),
                                        key: btn[1],
                                        child: TextButton(
                                          style: TextButton.styleFrom(
                                            foregroundColor: Theme.of(context).iconTheme.color,
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 30.0,
                                              horizontal: 10.0,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(5.0),
                                            ),
                                            // backgroundColor: const Color.fromRGBO(git 85, 134, 175, 1),
                                            textStyle: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 20.0, letterSpacing: 2.0),
                                          ),
                                          onPressed: () async {
                                            RenderBox box = btn[1].currentContext?.findRenderObject() as RenderBox;
                                            Offset position = box.localToGlobal(Offset.zero); //this is global position
                                            double y = position.dy;
                                            double x = position.dx;
                                            await showMenu(
                                              color: const Color(0xff1C4281),
                                              constraints: BoxConstraints(
                                                minWidth: MediaQuery.of(context).size.width * 4 / 15,
                                                maxWidth: MediaQuery.of(context).size.width * 4 / 15,
                                              ),
                                              context: context,
                                              elevation: 0,
                                              position: RelativeRect.fromLTRB(x, y + btn[1].currentContext!.size!.height, x, y + btn[1].currentContext!.size!.height),
                                              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(bottomLeft: Radius.circular(5.0), bottomRight: Radius.circular(5.0))),
                                              items: [
                                                for (var row in listMenuAdmin[2])
                                                  PopupMenuItem(
                                                      onTap: () {
                                                        context.go(row['url']);
                                                      },
                                                      child: SizedBox(
                                                        width: MediaQuery.of(context).size.width * 4 / 15 - 10,
                                                        child: Center(
                                                            child: (row['title'] != "TNV THAM GIA")
                                                                ? Text(
                                                                    "${row['title']} ",
                                                                    style: textBtn,
                                                                  )
                                                                : Row(
                                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                                    children: [
                                                                      Text(
                                                                        "${row['title']} ",
                                                                        style: textBtn,
                                                                      ),
                                                                      (countTNVTG != 0)
                                                                          ? Text(
                                                                              "($countTNVTG)",
                                                                              style: GoogleFonts.montserrat(fontSize: 17, fontWeight: FontWeight.w600, color: const Color.fromARGB(255, 255, 0, 0)),
                                                                            )
                                                                          : Row()
                                                                    ],
                                                                  )),
                                                      )),
                                              ],
                                              // elevation: 8.0,
                                            );
                                          },
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                'PHONG TRÀO SỰ KIỆN ',
                                                style: textBtn,
                                              ),
                                              (countTNVTG != 0)
                                                  ? const Icon(
                                                      Icons.notifications_active,
                                                      size: 15,
                                                      color: Colors.red,
                                                    )
                                                  : Row()
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 4,
                                      child: Container(
                                        width: MediaQuery.of(context).size.width * 4 / 15,
                                        decoration: const BoxDecoration(
                                            border: Border(
                                          right: BorderSide(width: 0.5, color: Colors.white),
                                          bottom: BorderSide(width: 0.5, color: Colors.white),
                                        )),
                                        key: btn[3],
                                        child: TextButton(
                                          style: TextButton.styleFrom(
                                            foregroundColor: Theme.of(context).iconTheme.color,
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 30.0,
                                              horizontal: 10.0,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(5.0),
                                            ),
                                            // backgroundColor: const Color.fromRGBO(85, 134, 175, 1),
                                            textStyle: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 20.0, letterSpacing: 2.0),
                                          ),
                                          onPressed: () async {
                                            RenderBox box = btn[3].currentContext?.findRenderObject() as RenderBox;
                                            Offset position = box.localToGlobal(Offset.zero); //this is global position
                                            double y = position.dy;
                                            double x = position.dx;
                                            await showMenu(
                                              color: const Color(0xff1C4281),
                                              constraints: BoxConstraints(
                                                minWidth: MediaQuery.of(context).size.width * 4 / 15,
                                                maxWidth: MediaQuery.of(context).size.width * 4 / 15,
                                              ),
                                              context: context,
                                              elevation: 0,
                                              position: RelativeRect.fromLTRB(x, y + btn[3].currentContext!.size!.height, x, y + btn[3].currentContext!.size!.height),
                                              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(bottomLeft: Radius.circular(5.0), bottomRight: Radius.circular(5.0))),
                                              items: [
                                                for (var row in listMenuAdmin[0])
                                                  PopupMenuItem(
                                                      onTap: () {
                                                        context.go(row['url']);
                                                      },
                                                      padding: const EdgeInsets.all(0),
                                                      child: SizedBox(
                                                        width: MediaQuery.of(context).size.width * 4 / 15,
                                                        child: Center(
                                                            child: (row['title'] != "QUẢN LÝ ĐĂNG KÝ")
                                                                ? Text(
                                                                    "${row['title']}",
                                                                    style: textBtn,
                                                                  )
                                                                : Row(
                                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                                    children: [
                                                                      Text(
                                                                        "${row['title']}",
                                                                        style: textBtn,
                                                                      ),
                                                                      (responseSVDK != 0)
                                                                          ? Text(
                                                                              " ($responseSVDK)",
                                                                              style: GoogleFonts.montserrat(fontSize: 17, fontWeight: FontWeight.w600, color: const Color.fromARGB(255, 255, 0, 0)),
                                                                            )
                                                                          : Row()
                                                                    ],
                                                                  )),
                                                      ))
                                              ],
                                              // elevation: 8.0,
                                            );
                                          },
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                'TÌNH NGUYỆN VIÊN ',
                                                style: textBtn,
                                              ),
                                              (responseSVDK != 0)
                                                  ? const Icon(
                                                      Icons.notifications_active,
                                                      size: 15,
                                                      color: Colors.red,
                                                    )
                                                  : Row()
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 4,
                                      child: Container(
                                        width: MediaQuery.of(context).size.width * 4 / 15,
                                        decoration: const BoxDecoration(
                                            border: Border(
                                          bottom: BorderSide(width: 0.5, color: Colors.white),
                                        )),
                                        key: btn[4],
                                        child: TextButton(
                                          style: TextButton.styleFrom(
                                            foregroundColor: Theme.of(context).iconTheme.color,
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 30.0,
                                              horizontal: 10.0,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(5.0),
                                            ),
                                            // backgroundColor: const Color.fromRGBO(git 85, 134, 175, 1),
                                            textStyle: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 20.0, letterSpacing: 2.0),
                                          ),
                                          onPressed: () async {
                                            RenderBox box = btn[4].currentContext?.findRenderObject() as RenderBox;
                                            Offset position = box.localToGlobal(Offset.zero); //this is global position
                                            double y = position.dy;
                                            double x = position.dx;
                                            await showMenu(
                                              color: const Color(0xff1C4281),
                                              constraints: BoxConstraints(
                                                minWidth: MediaQuery.of(context).size.width * 4 / 15 - 10,
                                                maxWidth: MediaQuery.of(context).size.width * 4 / 15 - 10,
                                              ),
                                              context: context,
                                              elevation: 0,
                                              position: RelativeRect.fromLTRB(x, y + btn[4].currentContext!.size!.height, x, y + btn[4].currentContext!.size!.height),
                                              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(bottomLeft: Radius.circular(5.0), bottomRight: Radius.circular(5.0))),
                                              items: [
                                                for (var row in listMenuAdmin[1])
                                                  PopupMenuItem(
                                                      onTap: () {
                                                        context.go(row['url']);
                                                      },
                                                      child: SizedBox(
                                                        width: MediaQuery.of(context).size.width * 4 / 15 - 10,
                                                        child: Center(
                                                            child: Text(
                                                          "${row['title']}",
                                                          style: textBtn,
                                                        )),
                                                      )),
                                              ],
                                              // elevation: 8.0,
                                            );
                                          },
                                          child: Text(
                                            'QUẢN TRỊ HỆ THỐNG',
                                            style: textBtn,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              : Row(
                                  children: [
                                    Expanded(
                                      flex: 4,
                                      child: Container(
                                        decoration: const BoxDecoration(
                                            border: Border(
                                          right: BorderSide(width: 0.5, color: Colors.white),
                                          bottom: BorderSide(width: 0.5, color: Colors.white),
                                        )),
                                        // key: btn[0],
                                        child: TextButton(
                                          focusNode: textButtonFocusNode,
                                          onHover: (val) {},
                                          style: TextButton.styleFrom(
                                            foregroundColor: Theme.of(context).iconTheme.color,
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 30.0,
                                              horizontal: 10.0,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(5.0),
                                            ),
                                            // backgroundColor: const Color.fromRGBO(85, 134, 175, 1),
                                            textStyle: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 20.0, letterSpacing: 2.0),
                                          ),
                                          onPressed: () {
                                            context.go(listMenuAdmin[3][0]['url']);
                                          },
                                          child: Text(
                                            'PHONG TRÀO SỰ KIỆN',
                                            style: textBtn,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 4,
                                      child: Container(
                                        decoration: const BoxDecoration(
                                            border: Border(
                                          right: BorderSide(width: 0.5, color: Colors.white),
                                          bottom: BorderSide(width: 0.5, color: Colors.white),
                                        )),
                                        // key: btn[0],
                                        child: TextButton(
                                          focusNode: textButtonFocusNode,
                                          onHover: (val) {},
                                          style: TextButton.styleFrom(
                                            foregroundColor: Theme.of(context).iconTheme.color,
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 30.0,
                                              horizontal: 10.0,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(5.0),
                                            ),
                                            // backgroundColor: const Color.fromRGBO(85, 134, 175, 1),
                                            textStyle: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 20.0, letterSpacing: 2.0),
                                          ),
                                          onPressed: () {
                                            context.go(listMenuAdmin[3][1]['url']);
                                          },
                                          child: Text(
                                            'LỊCH SỬ ĐĂNG KÝ',
                                            style: textBtn,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 4,
                                      child: Container(
                                        decoration: const BoxDecoration(
                                            border: Border(
                                          right: BorderSide(width: 0.5, color: Colors.white),
                                          bottom: BorderSide(width: 0.5, color: Colors.white),
                                        )),
                                        // key: btn[0],
                                        child: TextButton(
                                          focusNode: textButtonFocusNode,
                                          onHover: (val) {},
                                          style: TextButton.styleFrom(
                                            foregroundColor: Theme.of(context).iconTheme.color,
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 30.0,
                                              horizontal: 10.0,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(5.0),
                                            ),
                                            // backgroundColor: const Color.fromRGBO(85, 134, 175, 1),
                                            textStyle: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 20.0, letterSpacing: 2.0),
                                          ),
                                          onPressed: () {
                                            context.go("/lpv-tham-gia");
                                          },
                                          child: Text(
                                            'LỊCH PHỎNG VẤN',
                                            style: textBtn,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                        Expanded(child: widget.content),
                        // const FooterApp()
                      ],
                    ),
                  )
                ],
              )
            : CommonApp().loadingCallAPi(),
      ),
    );
  }
}

// ignore: must_be_immutable
class PopUpMenuTile extends StatefulWidget {
  String text = 'Button';
  Function function;
  PopUpMenuTile({super.key, required this.text, required this.function});

  @override
  State<PopUpMenuTile> createState() => _PopUpMenuTileState();
}

class _PopUpMenuTileState extends State<PopUpMenuTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(0),
      height: 60,
      width: MediaQuery.of(context).size.width,
      child: TextButton(
        onPressed: null,
        child: Align(alignment: Alignment.centerLeft, child: Text(widget.text, style: textBtn, textAlign: TextAlign.start)),
      ),
    );
  }
}
