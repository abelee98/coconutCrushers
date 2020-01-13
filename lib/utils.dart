import 'dart:io' show Platform;

import 'package:flutter/material.dart';

import 'powerups.dart';
import 'bosses.dart';
import 'dart:math';

class Pair<K,V> {
  K key;
  V value;

  Pair(this.key, this.value);
}

class Utils {

  static String colorTest(String hex, double lum) {
    RegExp hexColor = RegExp(r'^#?([0-9a-fA-F]{3}|[0-9a-fA-F]{6})$');
    Iterable<Match> matches = hexColor.allMatches(hex);
    String values = "";
    matches.toList()[0].group(1).runes.forEach((int rune) {
      var character = String.fromCharCode(rune);
      if (character != null) {
       values += character;
      }
    });
    if (values.length < 6) {
      values = values[0] + values[0] + values[1] + values[1] + values[2] + values[2];
    }
    var rgb = "";
    for (int i = 0; i < 3; i++) {
      var value = values.substring(i * 2, 2 * (i + 1));
      var parse = int.tryParse(value, radix: 16);
      var string = min(max(0, parse + (parse * lum)), 255).round().toRadixString(16);

      rgb += ("00" + string).substring(string.length);
    }

    return rgb.toUpperCase();
  }

  static int hexToInt({String color, double lum = 0.0}) {
    var value = "0xFF${Utils.colorTest(color, lum ?? 0)}";
    return int.parse(value);
  }

  static List<PowerUps> getPowerUps() {
    var list = List<PowerUps>();
    list.add(PowerUps("Master Sword", 2.15, false, 50));
    list.add(PowerUps("Lengendary Sword", 2.45, false, 180));
    list.add(PowerUps("Keyblade", 3.75, false, 300));
    list.add(PowerUps("Lightsaber", 4.95, false, 520));
    list.add(PowerUps("Buster Sword", 6.15, false, 1700));
    list.add(PowerUps("Soul Edge", 8.65, false, 2400));
    return list;
  }

  static List<Bosses> getBosses() {
    var list = List<Bosses>();
    list.add(Bosses("Two Cheeks", 450, "assets/coconut/Brown.flr"));
    list.add(Bosses("Pina", 450, "assets/coconut/Drink.flr"));
    list.add(Bosses("Hotshot", 450, "assets/coconut/Fire.flr"));
    list.add(Bosses("CocoNa", 450, "assets/coconut/Starfish.flr"));
    list.add(Bosses("Eggie", 450, "assets/coconut/Egg.flr"));
    list.add(Bosses("Baby Shark", 450, "assets/coconut/Shark.flr"));
    return list;
  }

  static TextStyle textStyle(double size, {Color color = Colors.white}) {
    return TextStyle(
      color: color,
      fontFamily: "Gameplay",
      fontSize: size,
    );
  }

  static Pair mapToPair(Map<int, bool> map) {
    return Pair(map.keys.toList()[0], map.values.toList()[0]);
  }

  static bool isDesktop() {
    return Platform.isMacOS || Platform.isWindows || Platform.isLinux;
  }
}

class StrokeText extends StatelessWidget {
  final String text;
  final double fontSize;
  final FontWeight fontWeight;
  final Color color;
  final Color strokeColor;
  final double strokeWidth;
  final String fontFamily;

  const StrokeText(this.text,
      {Key key,
      this.fontSize,
      this.fontWeight,
      this.color,
      this.strokeColor,
      this.strokeWidth,
      this.fontFamily})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Text(
          text,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: fontWeight,
            fontFamily: fontFamily,
            color: color,
          ),
        ),
        Text(
          text,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: fontWeight,
            fontFamily: fontFamily,
            foreground: Paint()
              ..strokeWidth = strokeWidth
              ..color = strokeColor
              ..style = PaintingStyle.stroke,
          ),
        ),
      ],
    );
  }
}

class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = new Path();
    path.lineTo(0.0, 20.0);

    var firstControlPoint = Offset(size.width / 4, 0.0);
    var firstEndPoint = Offset(size.width / 2.25, 30.0);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);

    var secondControlPoint = Offset(size.width - (size.width / 3.25), 65.0);
    var secondEndPoint = Offset(size.width, size.height - 40.0);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);

    path.lineTo(size.width, 40.0);
    path.lineTo(size.width, 0.0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
