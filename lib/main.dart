import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:voice_assistant_chat_gpt/home_page.dart';
import 'package:voice_assistant_chat_gpt/palette.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    //Set the fit size (Find your UI design, look at the dimensions of the device screen and fill it in,unit in dp)
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          title: 'Voice Assistant',
          debugShowCheckedModeBanner: false,
          theme: ThemeData.light(useMaterial3: true).copyWith(
              scaffoldBackgroundColor: Palette.whiteColor,
              colorScheme: const ColorScheme.light(),
              appBarTheme: const AppBarTheme(
                backgroundColor: Palette.whiteColor,
                centerTitle: true,
              )),
          home: const HomePage(),
        );
      },
    );
  }
}
