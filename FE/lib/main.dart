import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:haivn/ui/app_quan_tri/tinh-nguyen-vien/lich-phong-van/lich-phong-van-screen.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:localstorage/localstorage.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'model/model.dart';
import 'package:go_router/go_router.dart';
import 'package:haivn/ui/home.dart';
import 'package:haivn/ui/login_page.dart';
import 'package:haivn/ui/unkown.dart';

import 'ui/app_quan_tri/phong_trao_su_kien/ptsk-screen.dart';
import 'ui/app_quan_tri/phong_trao_su_kien/quan-ly-tnv-tham-gia/tnv-tham-gia.dart';
import 'ui/app_quan_tri/quan_ly_he_thong/quan-ly-poster/quan-ly-poster.dart';
import 'ui/app_quan_tri/quan_ly_he_thong/quan-tri-vien/quan-tri-vien.dart';
import 'ui/app_quan_tri/quan_ly_he_thong/quan_ly_chuc_vu/quan_ly_chuc_vu_screen.dart';
import 'ui/app_quan_tri/quan_ly_he_thong/quan_ly_lop/quan-ly-lop.dart';
import 'ui/app_quan_tri/tinh-nguyen-vien/lich-phong-van/them-moi-lpv.dart';
import 'ui/app_quan_tri/tinh-nguyen-vien/quan-ly-dang-ky/quan-ly-dang-ky-screen.dart';
import 'ui/app_quan_tri/tinh-nguyen-vien/quan-ly-tnv/quan-ly-tnv-screen.dart';
import 'ui/app_tinh_nguyen_vien/lich-phong-van/lich-phong-van-tham-gia.dart';
import 'ui/app_tinh_nguyen_vien/lich_su_dang_ky/lich_su_dang_ky.dart';
import 'ui/app_tinh_nguyen_vien/phong_trao_su_kien/ptsk.dart';
import 'ui/form-dang-ky.dart';

Future<void> main() async {
  // setPathUrlStrategy();
  var securityModel = SecurityModel(LocalStorage('storage'));
  await Hive.initFlutter();
  // await Hive.openBox("loginData");
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => securityModel),
    ],
    child: const MyApp(),
  ));
}

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        // etc.
      };
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var securityModel = SecurityModel(LocalStorage('storage'));
  @override
  void initState() {
    super.initState();
    securityModel.storage.ready.then((value) {
      securityModel.reload();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => securityModel),
      ],
      child: Consumer<SecurityModel>(builder: (context, security, child) {
        bool isLogin = security.authenticated;
        final GoRouter router = GoRouter(
          errorBuilder: (context, state) => const UnkownPage(),
          routes: [
            GoRoute(
              path: "/login-page",
              builder: (context, state) => const LoginPage(),
            ),
            GoRoute(
              path: "/form-dang-ky",
              builder: (context, state) => const FormDangKy(),
            ),
            GoRoute(
              path: "/trang-chu",
              builder: (context, state) => const TrangChu(),
            ),
            GoRoute(
              path: "/phong-trao-su-kien",
              builder: (context, state) => const PTSKSceen(),
            ),
            GoRoute(
              path: "/quan-ly-dang-ky",
              builder: (context, state) => const QuanLyDangKySceen(),
            ),
            GoRoute(
              path: "/quan-ly-tnv",
              builder: (context, state) => const QuanLyTNVSceen(),
            ),
            GoRoute(
              path: "/quan-ly-chuc-vu",
              builder: (context, state) => const QuanLyChucVuSceen(),
            ),
            GoRoute(
              path: "/quan-ly-lop-hoc",
              builder: (context, state) => const QuanLyLopHocSceen(),
            ),
            GoRoute(
              path: "/lich-phong-van",
              builder: (context, state) => const LichPhongVanSceen(),
            ),
            GoRoute(
              path: "/them-lich-phong-van",
              builder: (context, state) => const ThemMoiLPVSceen(),
            ),
            GoRoute(
              path: "/tnv-tham-gia",
              builder: (context, state) => const QuanLyTNVThamGiaSceen(),
            ),
            GoRoute(
              path: "/phong-trao-su-kien-tnv",
              builder: (context, state) => const PTSKTNVSceen(),
            ),
             GoRoute(
              path: "/lich-su-dang-ky",
              builder: (context, state) => const LichSuDangKySceen(),
            ),
             GoRoute(
              path: "/lpv-tham-gia",
              builder: (context, state) => const LichPhongVanThamGiaSceen(),
            ),
              GoRoute(
              path: "/quan-ly-poster",
              builder: (context, state) => const QuanLyPosterSceen(),
            ),
              GoRoute(
              path: "/quan-tri-vien",
              builder: (context, state) =>  QuanTriVienSceen(),
            ),
            GoRoute(
              path: "/",
              builder: (context, state) => const TrangChu(),
              redirect: (context, state) {
                if (!isLogin) return '/form-dang-ky';
                return null;
              },
              // routes: [
              //   GoRoute(
              //     path: "trang-chu",
              //     builder: (context, state) => const TrangChu(),
              //   ),
              //   GoRoute(
              //     path: "phong-trao-su-kien",
              //     builder: (context, state) => const PTSKSceen(),
              //   ),
              //   GoRoute(
              //     path: "quan-ly-dang-ky",
              //     builder: (context, state) => const QuanLyDangKySceen(),
              //   ),
              //   GoRoute(
              //     path: "quan-ly-tnv",
              //     builder: (context, state) => const QuanLyTNVSceen(),
              //   ),
              //   GoRoute(
              //     path: "quan-ly-chuc-vu",
              //     builder: (context, state) => const QuanLyChucVuSceen(),
              //   ),
              //   GoRoute(
              //     path: "quan-ly-lop-hoc",
              //     builder: (context, state) => const QuanLyLopHocSceen(),
              //   ),
              //   GoRoute(
              //     path: "lich-phong-van",
              //     builder: (context, state) => const LichPhongVanSceen(),
              //   ),
              //   GoRoute(
              //     path: "them-lich-phong-van",
              //     builder: (context, state) => const ThemMoiLPVSceen(),
              //   ),
              //   GoRoute(
              //     path: "tnv-tham-gia",
              //     builder: (context, state) => const QuanLyTNVThamGiaSceen(),
              //   ),
              // ],
            ),
          ],
        );
        return MaterialApp.router(
          title: "QLTNV",
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          supportedLocales: const [Locale('vi'), Locale('en')],
          locale: const Locale('vi'),
          theme: ThemeData(
            scaffoldBackgroundColor: const Color.fromARGB(184, 233, 240, 246),
            // primarySwatch: Colors.red,
          ),
          scrollBehavior: MyCustomScrollBehavior(),
          routerConfig: router,
        );
      }),
    );
  }
}
