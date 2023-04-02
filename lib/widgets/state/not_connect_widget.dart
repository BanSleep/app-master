import 'package:cvetovik/const/app_res.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class NotConnectWidget extends StatelessWidget {
  const NotConnectWidget({Key? key, required this.tryAgain}) : super(key: key);
  final AsyncCallback tryAgain;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                AppRes.notConnect,
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
      ),
    );
  }
}
