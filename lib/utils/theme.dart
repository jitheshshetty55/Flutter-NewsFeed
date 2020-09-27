import 'package:flutter/material.dart';
import 'color_constants.dart';

mixin FeedReaderTheme{

 static const FONT_NAME =  "Nunito";
 static final ThemeData feedReaderTheme = _buildLightTheme();

static ThemeData _buildLightTheme() {
  final ThemeData base = ThemeData.light();
  return base.copyWith(
    backgroundColor: ColorConstants.appBackgroundWhite,
    primaryColor: ColorConstants.primaryColorBlue,
    accentColor: ColorConstants.accentColorBlack,
    appBarTheme: base.appBarTheme.copyWith(
      iconTheme: base.iconTheme.copyWith(color: ColorConstants.appBarMenuBlack),
      textTheme: base.textTheme.copyWith(
        title: TextStyle(
        fontFamily: FONT_NAME,
        fontSize: 26,
        fontWeight: FontWeight.bold,
        color: ColorConstants.appBarTitleWhite
        ),
      ),
    ),

    iconTheme: base.iconTheme.copyWith(
      color: ColorConstants.bottomBarGrey,
    ),

    textTheme: _buildTextTheme(base.textTheme),
    primaryTextTheme: _buildTextTheme(base.primaryTextTheme),
    accentTextTheme: _buildTextTheme(base.accentTextTheme),

  );
}

static TextTheme _buildTextTheme(TextTheme base) {
  return base.copyWith(
  caption: base.caption.copyWith(
    fontWeight: FontWeight.normal,
    fontSize: 14.0,
    color: ColorConstants.textLightGrey
  ),
    headline: base.headline.copyWith(
      fontSize: 84.0,
      fontWeight: FontWeight.w200,
      color:  ColorConstants.textBlack

    ),
     subhead: base.subhead.copyWith(
         fontSize: 24.0,
         fontWeight: FontWeight.normal,
         color:  ColorConstants.textLightBlack
     ),
    button: base.button.copyWith(
        fontSize: 18.0,
        fontWeight: FontWeight.normal,
        color:  ColorConstants.textWhite
    ),
    body2: base.body2.copyWith(
        fontSize: 16.0,
        fontWeight: FontWeight.bold,
        color:  ColorConstants.textWhite
    ),
    display1: base.display1.copyWith(
        fontSize: 16.0,
        fontWeight: FontWeight.normal,
        color:  ColorConstants.textLightGrey1
    ),
    display2: base.display2.copyWith(
        fontSize: 16.0,
        fontWeight: FontWeight.w800,
        color:  ColorConstants.textWhite
    ),
    display3: base.display3.copyWith(
        fontSize: 16.0,
        fontWeight: FontWeight.w800,
        color:  ColorConstants.textBlack
    ),
    display4: base.display4.copyWith(
        fontSize: 16.0,
        fontStyle: FontStyle.italic,
        color:  ColorConstants.textGrey
    ),
    body1:base.body1.copyWith(
        fontSize: 16.0,
        fontWeight: FontWeight.normal,
        color:  ColorConstants.textBlack
    ),
    overline: base.overline.copyWith(
        fontSize: 16.0,
        fontWeight: FontWeight.bold,
        color:  ColorConstants.textLightGrey1,
        decoration: TextDecoration.underline,
    ),

    title: base.title.copyWith(
        fontSize: 26.0,
        color: ColorConstants.appBarTitleWhite
    ),
    subtitle:  base.subtitle.copyWith(
        fontSize: 24.0,
        fontWeight: FontWeight.bold,
        color: ColorConstants.textBlack
    ),


  ).apply(
    fontFamily: FONT_NAME,
  );
}

}





