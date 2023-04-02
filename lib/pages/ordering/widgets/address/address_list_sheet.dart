import 'package:cvetovik/const/app_res.dart';
import 'package:cvetovik/core/services/providers/db_provider.dart';
import 'package:cvetovik/pages/ordering/widgets/address/new_address_button.dart';
import 'package:cvetovik/widgets/share/line_sheet.dart';
import 'package:cvetovik/widgets/state/app_error_widget.dart';
import 'package:cvetovik/widgets/state/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'address_list_widget.dart';

class AddressListSheet extends StatefulWidget {
  const AddressListSheet({Key? key}) : super(key: key);

  @override
  _AddressListSheetState createState() => _AddressListSheetState();
}

class _AddressListSheetState extends State<AddressListSheet> {
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        var list = ref.watch(addressListProvider);
        return list.when(
            data: (data) {
              return ConstrainedBox(
                constraints: BoxConstraints(
                    minWidth: MediaQuery.of(context).size.width,
                    minHeight: MediaQuery.of(context).size.height * 0.2,
                    maxHeight: MediaQuery.of(context).size.height * 0.9),
                child: Padding(
                  padding: EdgeInsets.only(
                      left: 10.0.w, right: 10.0.w, top: 8.h, bottom: 20.h),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          LineSheet(),
                          SizedBox(
                            height: 31.h,
                          ),
                        ],
                      ),
                      Flexible(
                        child: AddressListWidget(
                          items: data,
                          refresh: true,
                        ),
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          NewAddressButton(
                            resizeAvoid: true,
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
            loading: () => LoadingWidget(),
            error: (error, stackTrace) => AppErrorWidget(
                  text: AppRes.error,
                  tryAgain: () async {},
                ));
      },
    );
  }
}
