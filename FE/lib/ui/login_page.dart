// ignore_for_file: use_full_hex_values_for_flutter_colors, use_build_context_synchronously

import 'dart:convert';
import 'dart:html';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:localstorage/localstorage.dart';
import 'package:provider/provider.dart';

import '../api.dart';
import '../common/style.dart';
import '../common/toast.dart';
import '../model/model.dart';
import 'form-dang-ky.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();
  late bool _passwordVisible;
  late EdgeInsets paddingPageLogin;
  bool rememberMe = false;
  late Box box;
  createOpenBox() async {
    box = await Hive.openBox("loginData");
    getdata();
  }

  void getdata() async {
    // await Hive.initFlutter();

    if (box.get('username') != null) {
      // print(box.get('username'));
      username.text = box.get('username');
      rememberMe = true;
      setState(() {});
    }
    if (box.get('password') != null) {
      password.text = box.get('password');
      rememberMe = true;
      setState(() {});
    }
  }

  LocalStorage storage = LocalStorage("storage");
  @override
  void initState() {
    _passwordVisible = true;
    createOpenBox();

    super.initState();
  }

  @override
  void dispose() {
    Hive.close();
    super.dispose();
  }

  double sizedBoxHeight = 0;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    if (width < 1000) {
      paddingPageLogin = const EdgeInsets.all(0);
    } else {
      paddingPageLogin = const EdgeInsets.symmetric(horizontal: 50, vertical: 35);
    }
    if (height < 500) {
      sizedBoxHeight = 50;
    } else {
      sizedBoxHeight = 100;
    }
    return Material(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 50),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [containerShadow],
          image: DecorationImage(
            image: const AssetImage(
              "images/background-login.jpeg",
            ),
            opacity: 0.8,
            colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.7), BlendMode.dstATop),

            // colorFilter: ColorFilter.mode(
            //   Colors.black.withOpacity(0.3),
            //   BlendMode.overlay,
            // ),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Container(
            width: 400,
            height: 600,
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 236, 249, 251),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.withOpacity(0.3),
                  spreadRadius: 1,
                  blurRadius: 2,
                  offset: Offset(1, 1), // changes position of shadow
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ClipOval(
                  child: Image.asset("images/logo.png", width: 250),
                ),
                SizedBox(height: 20),
                TextFormField(
                  enableSuggestions: true,
                  // maxLines: 1,
                  controller: username,
                  autofillHints: const [AutofillHints.username],
                  style: GoogleFonts.montserrat(color: Colors.black),
                  decoration: InputDecoration(
                    labelText: 'Tên đăng nhập',
                    labelStyle: GoogleFonts.montserrat(color: Colors.black),
                    hintStyle: GoogleFonts.montserrat(color: Colors.black),
                    border: OutlineInputBorder(borderSide: BorderSide(width: 0.5, color: Colors.black), borderRadius: BorderRadius.all(Radius.circular(10))),
                    enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 0.5,
                          color: Colors.black,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                    hintText: 'Email',
                  ),
                  validator: (String? value) {
                    if (value!.isEmpty) {
                      return null;
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 25,
                ),
                TextFormField(
                  enableSuggestions: true,
                  autofillHints: const [AutofillHints.password],
                  controller: password,
                  // maxLines: 1,
                  style: GoogleFonts.montserrat(color: Colors.black),
                  obscureText: _passwordVisible,

                  obscuringCharacter: '*',
                  decoration: InputDecoration(
                    labelText: 'Mật khẩu',
                    labelStyle: GoogleFonts.montserrat(color: Colors.black),
                    hintStyle: GoogleFonts.montserrat(color: Colors.black),
                    border: OutlineInputBorder(borderSide: BorderSide(width: 0.5, color: Colors.black), borderRadius: BorderRadius.all(Radius.circular(10))),
                    enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 0.5,
                          color: Colors.black,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                    suffixIcon: IconButton(
                      icon: Icon(
                        // Based on passwordVisible state choose the icon
                        _passwordVisible ? Icons.visibility : Icons.visibility_off,
                        color: Theme.of(context).primaryColorDark,
                      ),
                      onPressed: () {
                        // Update the state i.e. toogle the state of passwordVisible variable
                        setState(() {
                          _passwordVisible = !_passwordVisible;
                        });
                      },
                    ),
                  ),
                  validator: (String? value) {
                    if (value!.isEmpty) {
                      return null;
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 25,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Theme(
                            data: ThemeData(
                              primarySwatch: Colors.blue,
                              unselectedWidgetColor: Colors.black, // Your color
                            ),
                            child: Checkbox(
                              value: rememberMe,
                              onChanged: (value) {
                                rememberMe = !rememberMe;
                                setState(() {});
                              },
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            'Ghi nhớ tài khoản',
                            style: textBtnBlack,
                          ),
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () {},
                      child: Text(
                        'Quên mật khẩu?',
                        style: textBtnBlack,
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 25,
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        decoration: BoxDecoration(color: const Color(0xff6C92D0), borderRadius: BorderRadius.circular(8)),
                        child: TextButton(
                          onPressed: () async {
                            processing();
                            if (password.text == "" || username.text == "") {
                              showToast(
                                context: context,
                                msg: "Cần nhập đủ thông tin",
                                color: Colors.orange,
                                icon: const Icon(Icons.warning),
                              );
                              Navigator.pop(context);
                            } else {
                              var userLogin = {"username": username.text, "password": password.text};
                              var responseLogin = await httpPost("/api/nguoi-dung/login", userLogin, context);
                              var bodyLogin = jsonDecode(responseLogin["body"]);
                              if (bodyLogin["success"] == true) {
                                if (bodyLogin["result"]['status'] == 1) {
                                  storage.setItem('id', bodyLogin["result"]['id'].toString());
                                  storage.setItem('role', bodyLogin["result"]['role'].toString());
                                  if (bodyLogin["result"]['role'].toString() == "0") {
                                    context.go("/trang-chu");
                                  } else {
                                    context.go("/phong-trao-su-kien-tnv");
                                  }
                                } else {
                                  showToast(
                                    context: context,
                                    msg: "Tài khoản không hoạt động",
                                    color: Colors.orange,
                                    icon: const Icon(Icons.warning),
                                  );
                                  Navigator.pop(context);
                                }
                              } else {
                                showToast(
                                  context: context,
                                  msg: "${bodyLogin["result"]}",
                                  color: Colors.orange,
                                  icon: const Icon(Icons.warning),
                                );
                                Navigator.pop(context);
                              }
                            }
                          },
                          child: Text(
                            'Đăng nhập',
                            style: textBtnTopicWhite,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      flex: 2,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        decoration: BoxDecoration(color: Color.fromARGB(255, 25, 187, 79), borderRadius: BorderRadius.circular(8)),
                        child: TextButton(
                          onPressed: () async {
                            context.go("/form-dang-ky");
                          },
                          child: Text(
                            'Đăng ký',
                            style: textBtnTopicWhite,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> processing() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
