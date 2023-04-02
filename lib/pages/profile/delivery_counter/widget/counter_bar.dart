import 'package:cvetovik/const/app_typedef.dart';
import 'package:cvetovik/core/ui/app_colors.dart';
import 'package:cvetovik/core/ui/app_text_styles.dart';
import 'package:cvetovik/core/ui/app_ui.dart';
import 'package:cvetovik/core/ui/w_textfield.dart';
import 'package:cvetovik/pages/ordering/widgets/address/address_suggestion_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CounterBar extends StatelessWidget {
  const CounterBar({Key? key, required this.selectedAddress}) : super(key: key);
  final OnSelectedAddressAsync selectedAddress;

  @override
  Widget build(BuildContext context) {
    //bottom: MediaQuery.of(context).viewInsets.bottom),
    return SizedBox(
      width: 300.w,
      child: Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
          decoration: AppUi.roundedContainerDecoration,
          child: Column(crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 5,
              ),
              Text(
                'Стоимость заказа',
                style: AppTextStyles.textField,
              ),
              SizedBox(
                height: 8,
              ),
              WTextField(hintText: '5 000 ₽',hintTextStyle:AppTextStyles.textField.copyWith(color: AppColors.grey) ,
                onChanged: (text) {},
                height: 44,
                borderRadius: 6,
              ),
              Container(
                height: 112.h,
                child: AddressSuggestionWidget(
                  onSelected: selectedAddress,
                ),
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
