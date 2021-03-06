import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:konnex_aerothon/providers/catalog_provider.dart';
import 'package:konnex_aerothon/screens/splash_screen.dart';

import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await GetStorage.init();
  await [Permission.microphone, Permission.speech].request();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<CatalogProvider>(
            create: (_) => CatalogProvider()),
      ],
      child: GetMaterialApp(
        title: 'Konnex Aerothon',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
          primaryColor: Color(0xff5B2C6F),
          accentColor: Color(0xffF1C40F),
          appBarTheme: AppBarTheme(
            color: Colors.white,
            foregroundColor: Color(0xff5B2C6F),
            iconTheme: IconThemeData(
              color: Color(0xff5B2C6F),
            ),
            actionsIconTheme: IconThemeData(
              color: Color(0xff5B2C6F),
            ),
          ),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              primary: Color(0xff5B2C6F),
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              onPrimary: Colors.white,
              primary: Color(0xff5B2C6F),
            ),
          ),
        ),
        defaultTransition: Transition.cupertino,
        home: SplashScreen(),
      ),
    );
  }
}
