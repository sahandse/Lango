import 'package:flutter/material.dart';

ThemeData langoTheme(Brightness brightness) {
  final dark=brightness==Brightness.dark;
  final colors=ColorScheme.fromSeed(seedColor:const Color(0xff7051ed),brightness:brightness);
  return ThemeData(
    useMaterial3:true,
    fontFamily:'Vazirmatn',
    colorScheme:colors,
    scaffoldBackgroundColor:dark?const Color(0xff11121a):const Color(0xfff5f6fa),
    appBarTheme:AppBarTheme(backgroundColor:Colors.transparent,elevation:0,centerTitle:false),
    cardTheme:CardThemeData(elevation:0,margin:const EdgeInsets.symmetric(vertical:5),shape:RoundedRectangleBorder(borderRadius:BorderRadius.circular(22))),
    navigationBarTheme:NavigationBarThemeData(elevation:0,height:70,indicatorColor:colors.primaryContainer),
    inputDecorationTheme:InputDecorationTheme(filled:true,border:OutlineInputBorder(borderRadius:BorderRadius.circular(18),borderSide:BorderSide.none)),
    filledButtonTheme:FilledButtonThemeData(style:FilledButton.styleFrom(minimumSize:const Size(0,48),shape:RoundedRectangleBorder(borderRadius:BorderRadius.circular(16)))),
    outlinedButtonTheme:OutlinedButtonThemeData(style:OutlinedButton.styleFrom(minimumSize:const Size(0,46),shape:RoundedRectangleBorder(borderRadius:BorderRadius.circular(16)))),
  );
}
