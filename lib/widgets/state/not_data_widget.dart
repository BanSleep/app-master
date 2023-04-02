import 'package:cvetovik/const/app_res.dart';
import 'package:flutter/material.dart';

class NotDataWidget extends StatelessWidget {
  const NotDataWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(child: Text(AppRes.notFound));
  }
}
