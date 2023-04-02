import 'package:cvetovik/const/app_res.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AppErrorWidget extends StatelessWidget {
  const AppErrorWidget({Key? key, this.text, required this.tryAgain})
      : super(key: key);

  final String? text;
  final AsyncCallback tryAgain;

  @override
  Widget build(BuildContext context) {
    var mess = (text == null) ? AppRes.error : text;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              mess!,
              textAlign: TextAlign.center,
            ),
          ),
          ElevatedButton(
            child: Text(AppRes.tryAgain),
            onPressed: () async {
              //TODO fix it
              try {
                await tryAgain();
              } catch (e) {}
            },
          )
        ],
      ),
    );
  }
}
