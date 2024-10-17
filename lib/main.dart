import 'package:flutter/material.dart';

import 'product_presentation/product_view/product_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        dropdownMenuTheme:  DropdownMenuThemeData(
          menuStyle: MenuStyle(
           /// backgroundColor:WidgetStateProperty.all<Color>(Colors.black87) ,
        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
         const RoundedRectangleBorder(
          side: BorderSide.none,
          // Adjust the radius as needed
      ),
    ),
          ),
          inputDecorationTheme:  InputDecorationTheme(

            activeIndicatorBorder: BorderSide.none,
            enabledBorder: InputBorder.none,

            focusedBorder: InputBorder.none,
            border: MaterialStateUnderlineInputBorder.resolveWith((res){
              return InputBorder.none;
            }),
            filled: true,
            fillColor: Colors.yellow,
             outlineBorder: BorderSide.none,
          )
        ),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const ProductPage(),
    );
  }
}


