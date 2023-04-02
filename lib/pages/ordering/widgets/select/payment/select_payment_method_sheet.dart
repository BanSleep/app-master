import 'package:cvetovik/const/app_res.dart';
import 'package:cvetovik/core/ui/app_text_styles.dart';
import 'package:cvetovik/core/ui/app_ui.dart';
import 'package:cvetovik/pages/ordering/mixin/payment_data_mixin.dart';
import 'package:cvetovik/pages/ordering/models/payment_method_data.dart';
import 'package:cvetovik/pages/ordering/widgets/select/payment/select_payment_item_widget.dart';
import 'package:cvetovik/widgets/app_divider.dart';
import 'package:cvetovik/widgets/share/line_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SelectPaymentMethodSheet extends StatefulWidget with PaymentMixinData {
  final List<String> payments;
  const SelectPaymentMethodSheet({
    required this.payments,
    Key? key}) : super(key: key);

  @override
  State<SelectPaymentMethodSheet> createState() => _SelectPaymentMethodSheetState();
}

class _SelectPaymentMethodSheetState extends State<SelectPaymentMethodSheet> {

  List<PaymentMethodData> items = [];


  getItems (){
    for (var i in widget.payments){
      if(i=='cash'){
        items.add(PaymentMethodData(method: PaymentMethod.cash, title: AppRes.cash,value: i));
      }else if(i=='yoomoney'){
        items.add(PaymentMethodData(method: PaymentMethod.youMoney, title: 'YouMoney',value: i));
      }else if(i=='cards'){
        items.add(PaymentMethodData(method: PaymentMethod.card, title: AppRes.byCard,value: i));
      }
    }
  }



  @override
  void initState() {
    getItems();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(
            top: 8.h,
            bottom: 17.h,
          ),
          child: LineSheet(),
        ),
        Center(
          child: Text(
            AppRes.paymentMethod,
            textAlign: TextAlign.center,
            style: AppTextStyles.titleLarge,
          ),
        ),
        Padding(
          padding:
              EdgeInsets.only(left: 10.w, right: 10.w, top: 26.h, bottom: 16.h),
          child: Container(
            margin: EdgeInsets.only(bottom: 24.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.r),
              boxShadow: [
                AppUi.baseShadow,
              ],
            ),
            child: ListView.separated(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: items.length,
                separatorBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: EdgeInsets.only(left: 40.w, right: 40.w),
                    child: AppDivider(),
                  );
                },
                itemBuilder: (BuildContext context, int index) {
                  var item = items[index];
                  return SelectPaymentItemWidget(
                    data: item,
                    onTap: (data) async {
                      Navigator.pop(context, data);
                    },
                  );
                }),
          ),
        ),
      ],
    );
  }
}
