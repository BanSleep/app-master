import 'package:cvetovik/const/app_const.dart';
import 'package:cvetovik/const/app_res.dart';
import 'package:cvetovik/core/api/api_base.dart';
import 'package:cvetovik/core/services/settings_services.dart';
import 'package:cvetovik/core/ui/app_all_colors.dart';
import 'package:cvetovik/core/ui/app_text_styles.dart';
import 'package:cvetovik/core/ui/app_ui.dart';
import 'package:cvetovik/pages/ordering/order_result_page.dart';
import 'package:cvetovik/pages/ordering/providers/ordering/ordering_bloc.dart';
import 'package:cvetovik/widgets/app_back_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PaymentPage extends ConsumerStatefulWidget {
  const PaymentPage({Key? key, required this.paymentWidget, this.price})
      : super(key: key);
  final String paymentWidget;
  final int? price;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _PaymentPageState();
  }
}

class _PaymentPageState extends ConsumerState<PaymentPage> {
  @override
  Widget build(BuildContext context) {
    //final String startUrl = 'https://app.cvetovik.com/cloudpayments.html';
    //var str = widget.paymentWidget; //.replaceAll('\n', '');
    //var str ="<!DOCTYPE html>   <html>    <body>    <h1>My First Heading</h1>    <p>My first paragraph.</p>    </body>    </html>";
    //var uriFromStr = Uri.dataFromString(str);

    var orderId = ref.read(orderingBlocProvider).orderId;
    var set = ref.read(settingsProvider);
    var deviceRegister = set.getDeviceRegisterWithRegion();
    var clientInfo = set.getLocalClientInfo();

    var headers = deviceRegister.toJson();
    if (clientInfo.clientToken != null) {
      headers.addAll(clientInfo.toJson().cast<String, String>());
    }

    var price = widget.price;

    String startUrl = '${ApiBase.getBaseUtl()}cabinet/payment/$orderId/';
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          leading: AppBackButton(
            tap: () => Navigator.pop(context),
          ),
          title: Text(
            AppRes.payment,
            style: AppTextStyles.titleLarge
                .copyWith(color: AppAllColors.lightBlack),
          ),
          centerTitle: true,
          leadingWidth: AppUi.leadingWidth,
          titleSpacing: 0,
          automaticallyImplyLeading: false,
        ),
        body: Column(
          children: [
            /*ElevatedButton(
                onPressed: () async {
                  var bloc = ref.read(orderingBlocProvider);
                  await bloc.paymentCompleted(context);
                },
                child: Text('ok')),*/
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(10.0),
                child: InAppWebView(
                    initialOptions: InAppWebViewGroupOptions(
                      ios: IOSInAppWebViewOptions(
                        applePayAPIEnabled: true,
                      ),
                      crossPlatform: InAppWebViewOptions(
                          userAgent: AppConst.uAgent,
                          javaScriptEnabled: true,
                          useOnDownloadStart: true,
                          useOnLoadResource: true,
                          javaScriptCanOpenWindowsAutomatically: true,
                          useShouldOverrideUrlLoading: true),
                    ),
                    initialUrlRequest:
                        URLRequest(headers: headers, url: Uri.parse(startUrl)),
                    //initialData:InAppWebViewInitialData(data: str) ,
                    onConsoleMessage: (controller, consoleMessage) async {
                      print(consoleMessage.message);
                      if (consoleMessage.message == 'payment complete') {
                        var bloc = ref.read(orderingBlocProvider);
                        await bloc.paymentCompleted(context);
                      } else {
                        if (consoleMessage.message == 'fail payment') {
                          Navigator.pop(context);
                        }
                      }
                    }),
              ),
            ),
          ],
        ));
  }
}
