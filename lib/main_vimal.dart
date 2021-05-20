import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:konnex_aerothon/screens/konnex_test_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await GetStorage.init();

  runApp(_MyApp());
}

class _MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Konnex Aerothon',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Color(0xffF4ECF7),
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
      home: KonnexTestScreen(),
    );
  }
}
