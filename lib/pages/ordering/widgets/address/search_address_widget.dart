import 'package:cvetovik/const/app_typedef.dart';
import 'package:cvetovik/core/ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'address_suggestion_widget.dart';

class SearchAddressWidget extends StatelessWidget {
  const SearchAddressWidget({Key? key, required this.selectedAddress})
      : super(key: key);
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
          height: 112.h,
          decoration: AppUi.roundedContainerDecoration,
          padding: EdgeInsets.symmetric(vertical: 18.h, horizontal: 24.w),
          child: AddressSuggestionWidget(
            onSelected: selectedAddress,
          ),
        ),
      ),
    );
  }
}
