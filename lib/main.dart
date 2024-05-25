import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_viewer/domain/token/login_token.dart';
import 'package:photo_viewer/presentation/gallery/gallery_page.dart';
import 'package:photo_viewer/presentation/gallery/gallery_view_model.dart';
import 'package:photo_viewer/presentation/login/login_page.dart';
import 'package:photo_viewer/presentation/login/login_view_model.dart';
import 'package:photo_viewer/presentation/main_page.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:photo_viewer/presentation/signup/signup_view_model.dart';
import 'package:provider/provider.dart';

import 'http_overrides.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  HttpOverrides.global = CustomHttpOverrides();

  await Permission.camera.request();
  if (Platform.isAndroid) {
    final androidInfo = await DeviceInfoPlugin().androidInfo;
    if (androidInfo.version.sdkInt <= 32) {
      Permission.storage.request();
    } else {
      Permission.photos.request();
    }
  }

  await dotenv.load(fileName: 'assets/.env');
  await LoginToken().login();
  runApp(const MyApp());
  FlutterNativeSplash.remove();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      splitScreenMode: true,
      useInheritedMediaQuery: true,
      builder: (context, child) {
        return MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => GalleryViewModel()),
            ChangeNotifierProvider(create: (_) => LoginViewModel()),
            ChangeNotifierProvider(create: (_) => SignupViewModel())
          ],
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('ko', 'KO'),
              Locale('en', 'US'),
            ],
            title: 'camerai',
            themeMode: ThemeMode.dark,
            darkTheme: ThemeData(
              brightness: Brightness.dark,
              useMaterial3: true,
            ),
            home: (LoginToken().accessToken == null && LoginToken().refreshToken == null)
            ? const LoginPage()
            : GalleryPage()
          ),
        );
      }
    );
  }
}