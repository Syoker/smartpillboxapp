//Application created by Lautaro Gómez Castro of the Ragtal group
//Any questions go to this email: lautarivan@hotmail.com

import 'package:flutter/material.dart';

import 'myColors.dart';
import 'homePage.dart';
import 'settings.dart';

main() {
  runApp(SmartPillbox());
}

class SmartPillbox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Pillbox',
      theme: ThemeData(
        cursorColor: MyColors.lightThemeAccent,
        brightness: Brightness.light,
        hintColor: MyColors.lightThemeButtonText,
        buttonColor: MyColors.lightThemeButtonDelete,
        accentColor: MyColors.lightThemeAccent,
        dividerColor: MyColors.lightThemeDividers,
        appBarTheme: AppBarTheme(
          color: MyColors.lightThemeAppBar,
          elevation: 4,
        ),
        backgroundColor: MyColors.lightThemeBackgroud,
        cardColor: MyColors.lightThemeCardsDialogs,
        dialogTheme: DialogTheme(
          backgroundColor: MyColors.lightThemeCardsDialogs,
        ),
        iconTheme: IconThemeData(
          color: MyColors.lightThemeIcons,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor:
                MaterialStateProperty.all(MyColors.lightThemeButtonSave),
            elevation: MaterialStateProperty.all(2),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: ButtonStyle(
            backgroundColor:
                MaterialStateProperty.all(MyColors.lightThemeButtonText),
            elevation: MaterialStateProperty.all(0),
          ),
        ),
        textTheme: TextTheme(
          bodyText1: TextStyle(
            color: MyColors.lightThemeBodyText1,
            fontFamily: 'SourceSansPro',
            fontWeight: FontWeight.w400,
            fontSize: 16,
          ),
          bodyText2: TextStyle(
            color: MyColors.lightThemeBodyText2,
            fontFamily: 'SourceSansPro',
            fontWeight: FontWeight.w400,
            fontSize: 16,
          ),
          overline: TextStyle(
            color: MyColors.lightThemeOverline,
            fontFamily: 'SourceSansPro',
            fontWeight: FontWeight.w400,
            fontSize: 12,
          ),
          headline6: TextStyle(
            color: MyColors.lightThemeHeadline6,
            fontFamily: 'SourceSansPro',
            fontWeight: FontWeight.w600,
            fontSize: 24,
          ),
          headline5: TextStyle(
            color: MyColors.lightThemeAccent,
            fontFamily: 'SourceSansPro',
            fontWeight: FontWeight.w600,
            fontSize: 40,
          ),
          headline4: TextStyle(
            color: MyColors.lightThemeHeadLine4,
            fontFamily: 'SourceSansPro',
            fontWeight: FontWeight.w400,
            fontSize: 28,
          ),
        ),
        fontFamily: 'SourceSansPro',
      ),
      darkTheme: ThemeData(
          brightness: Brightness.dark,
          hintColor: MyColors.darkThemeButtonText,
          buttonColor: MyColors.darkThemeButtonDelete,
          accentColor: MyColors.darkThemeAccent,
          dividerColor: MyColors.darkThemeDividers,
          appBarTheme: AppBarTheme(
            color: MyColors.darkThemeAppBar,
            elevation: 4,
          ),
          backgroundColor: MyColors.darkThemeBackgroud,
          cardColor: MyColors.darkThemeCardsDialogs,
          dialogTheme: DialogTheme(
            backgroundColor: MyColors.darkThemeCardsDialogs,
          ),
          iconTheme: IconThemeData(
            color: MyColors.darkThemeIcons,
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.all(MyColors.darkThemeButtonSave),
              elevation: MaterialStateProperty.all(8),
            ),
          ),
          textButtonTheme: TextButtonThemeData(
            style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.all(MyColors.darkThemeButtonText),
              elevation: MaterialStateProperty.all(0),
            ),
          ),
          textTheme: TextTheme(
            bodyText1: TextStyle(
              color: MyColors.darkThemeBodyText1,
              fontFamily: 'SourceSansPro',
              fontWeight: FontWeight.w400,
              fontSize: 16,
            ),
            bodyText2: TextStyle(
              color: MyColors.darkThemeBodyText2,
              fontFamily: 'SourceSansPro',
              fontWeight: FontWeight.w400,
              fontSize: 16,
            ),
            overline: TextStyle(
              color: MyColors.darkThemeOverline,
              fontFamily: 'SourceSansPro',
              fontWeight: FontWeight.w400,
              fontSize: 12,
            ),
            headline6: TextStyle(
              color: MyColors.darkThemeHeadline6,
              fontFamily: 'SourceSansPro',
              fontWeight: FontWeight.w600,
              fontSize: 24,
            ),
            headline5: TextStyle(
              color: MyColors.darkThemeAccent,
              fontFamily: 'SourceSansPro',
              fontWeight: FontWeight.w600,
              fontSize: 40,
            ),
            headline4: TextStyle(
              color: MyColors.darkThemeHeadLine4,
              fontFamily: 'SourceSansPro',
              fontWeight: FontWeight.w400,
              fontSize: 28,
            ),
          ),
          fontFamily: 'SourceSansPro'),
      routes: {
        '/': (context) => HomePage(),
        '/setting': (context) => Settings(),
      },
      initialRoute: '/',
    );
  }
}
