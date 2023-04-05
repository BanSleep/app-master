import 'dart:async';

import 'package:cvetovik/const/app_icons.dart';
import 'package:cvetovik/const/app_images.dart';
import 'package:cvetovik/pages/app_startup/app_startup_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

class HelloScreen extends StatefulWidget {
  const HelloScreen({Key? key}) : super(key: key);

  @override
  State<HelloScreen> createState() => _HelloScreenState();
}

class _HelloScreenState extends State<HelloScreen> {
  String getIcon(int time) {
    if (time > 6 && time < 11) {
      return AppImages.sun;
    } else if (time > 11 && time < 16) {
      return AppImages.dawn;
    } else {
      return AppImages.moon;
    }
  }

  String getText(int time) {
    if (time > 6 && time < 11) {
      return 'Доброе утро';
    } else if (time >= 11 && time <= 16) {
      return 'Добрый день';
    } else {
      return 'Добрый вечер';
    }
  }

  Color getColor(int time) {
    if (time > 6 && time < 11) {
      return Color(0xff33DF59);
    } else if (time > 11 && time < 16) {
      return Color(0xff2BCB4E);
    } else {
      return Color(0xff27B546);
    }
  }


  @override
  void initState() {
   Timer(Duration(seconds: 2), () {
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (c)=>AppStartupPage()), (route) => false);
   });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var time = int.parse(DateFormat('HH').format(DateTime.now()));

    return Scaffold(
      backgroundColor: getColor(time),
      body: Stack(
        children: [
          Column(
            children: [
              SizedBox(
                height: 50 + MediaQuery.of(context).padding.top,
              ),
              Row(mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    AppIcons.svetovikWhite,
                    width: 40,
                    height: 40,
                  )
                ],
              )
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    getIcon(time),
                    width: 110,
                    height: 110,
                    fit: BoxFit.cover,
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                getText(time),textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 24,
                    color: Colors.white),
              )
            ],
          )
        ],
      ),
    );
  }
}
