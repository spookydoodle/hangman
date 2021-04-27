import 'package:flutter/material.dart';
import 'package:hangman/utils/hex_color.dart';

final ThemeData appTheme = _buildAppTheme();

final _primaryColorLight = HexColor('2C2234');
final _primaryColor = HexColor('16111A');
final _primaryColorDark = HexColor('000000');
final _secondaryColorLight = HexColor('FCD3DE');
final _secondaryColor = HexColor('FF5D73');
final _secondaryColorDark = HexColor('CC5A71');
final _light = HexColor('F7F7F7');

ThemeData _buildAppTheme() {
  // Get dark theme as a base and overwrite relevant elements
  final ThemeData base = ThemeData.light();

  return base.copyWith(
    brightness: Brightness.light,
    primaryColor: _primaryColor,
    primaryColorLight: _primaryColorLight,
    primaryColorDark: _primaryColorDark,
    accentColor: _secondaryColor,
    highlightColor: _secondaryColorLight,
    scaffoldBackgroundColor: _light,
    elevatedButtonTheme: _appElevatedButtonTheme(),
    textTheme: _appTextTheme(base.textTheme),
    outlinedButtonTheme: _appOutlinedButtonTheme(),
  );
}

OutlinedButtonThemeData _appOutlinedButtonTheme() => OutlinedButtonThemeData(
      style: TextButton.styleFrom(
        padding: EdgeInsets.all(6.0),
        minimumSize: Size(40, 20),
        primary: _secondaryColor,
      ),
    );

ElevatedButtonThemeData _appElevatedButtonTheme() => ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.all(6.0),
        minimumSize: Size(40, 20),
        primary: _secondaryColor,
      ),
    );

// Use https://type-scale.com/
// Below scale is generated for base size 20px (for body1) using 1.250 Major Third scale
TextTheme _appTextTheme(TextTheme base) => base
    .copyWith(
      // Headlines
      headline1: base.headline1.copyWith(
        fontSize: 95.37,
      ),
      headline2: base.headline2.copyWith(
        fontSize: 76.29,
      ),
      headline3: base.headline3.copyWith(
        fontSize: 61.04,
      ),
      headline4: base.headline4.copyWith(
        fontSize: 48.83,
      ),
      headline5: base.headline5.copyWith(
        fontSize: 39.06,
      ),
      headline6: base.headline6.copyWith(
        fontSize: 31.25,
      ),
      // Subtitles
      subtitle1: base.subtitle1.copyWith(
        fontSize: 25.0,
      ),
      subtitle2: base.subtitle2.copyWith(
        fontSize: 20.0,
      ),
      // Body
      bodyText1: base.bodyText1.copyWith(
        fontSize: 20.0,
      ),
      bodyText2: base.bodyText2.copyWith(
        fontSize: 20.0,
      ),
      // Caption
      caption: base.caption.copyWith(
        fontSize: 16.0,
      ),
      // Overline
      overline: base.overline.copyWith(
        fontSize: 12.8,
      ),
      // Button
      button: base.button.copyWith(
        // letterSpacing: 3.0,
        fontSize: 20.0,
        // color: Colors.white
      ),
    )
    .apply(
      // Apply to all elements
      fontFamily: 'Architects Daughter',
      // fontFamily: 'Orelega One',  // Looks like a newspaper
      // fontFamily: 'Original Surfer',
    );
