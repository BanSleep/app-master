import 'package:cvetovik/const/app_res.dart';
import 'package:cvetovik/core/ui/app_all_colors.dart';
import 'package:cvetovik/core/ui/app_text_styles.dart';
import 'package:cvetovik/core/ui/app_ui.dart';
import 'package:cvetovik/models/api/response/region/region_shops_response.dart';
import 'package:cvetovik/pages/ordering/widgets/shop_item/shop_info_item_widget.dart';
import 'package:cvetovik/widgets/app_back_button.dart';
import 'package:cvetovik/widgets/share/app_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ShopListPage extends StatefulWidget {
  const ShopListPage({Key? key, required this.items}) : super(key: key);
  final List<RegionShopInfo> items;

  @override
  _ShopListPageState createState() => _ShopListPageState();
}

class _ShopListPageState extends State<ShopListPage> {
  late List<RegionShopInfo> _items;

  @override
  void initState() {
    _items = widget.items;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: AppBackButton(
          tap: () => Navigator.pop(context),
        ),
        centerTitle: true,
        leadingWidth: AppUi.leadingWidth,
        titleSpacing: 0,
        automaticallyImplyLeading: false,
        title: Text(
          AppRes.shopsList,
          style:
              AppTextStyles.titleLarge.copyWith(color: AppAllColors.lightBlack),
        ),
      ),
      bottomNavigationBar: _getBottomNavBar(),
      body: Padding(
        padding:
            EdgeInsets.only(left: 10.w, right: 10.w, bottom: 10.h, top: 0.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            /*CheckBoxWidget(
              //key: keyExtractTime,
              title: AppRes.suburb,
            ),
            SizedBox(
              height: 12.h,
            ),*/
            AppTextField(
              //key: keyPostcard,
              //textFieldType: TextFieldType.phone,
              hint: 'г. Всеволожск, Октябрьский пр-кт, д 1',
              title: AppRes.inputAddress,
              onChange: _onSearchTextChanged,
              //maxLines: 8,
              //errorText: AppRes.pleaseInputPhone,
            ),
            SizedBox(
              height: 12.h,
            ),
            Expanded(
                child: ListView.builder(
              itemCount: _items.length,
              itemBuilder: _itemBuilder,
              shrinkWrap: true,
            ))
          ],
        ),
      ),
    );
  }

  int selectedIndex = -1;

  Widget _itemBuilder(BuildContext context, int index) {
    var curr = _items[index];
    return ShopInfoItemWidget(
      data: curr,
      onTab: () {
        setState(() {
          selectedIndex = index;
        });
      },
      selected: selectedIndex == index,
    );
  }

  Widget _getBottomNavBar() {
    return Padding(
      padding: EdgeInsets.only(left: 10.w, right: 10.w, bottom: 5.h, top: 5.h),
      child: SizedBox(
        height: 44.h,
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () async {
            if (selectedIndex >= 0) {
              var curr = _items[selectedIndex];
              Navigator.pop(context, curr);
            } else {
              AppUi.showToast(context, AppRes.selectShop);
            }
          },
          style: AppUi.buttonActionStyle,
          child: Text(
            AppRes.getHere,
            style: AppTextStyles.titleVerySmall.copyWith(color: Colors.white),
          ),
        ),
      ),
    );
  }

  _onSearchTextChanged(String text) {
    if (text.isNotEmpty) {
      List<RegionShopInfo> searchItems = [];
      widget.items.forEach((element) {
        if (element.title.toLowerCase().contains(text.toLowerCase()) ||
            element.metro.toLowerCase().contains(text.toLowerCase()) ||
            element.address.toLowerCase().contains(text.toLowerCase()) ||
            element.contacts.toLowerCase().contains(text.toLowerCase()) ||
            element.workTime.toLowerCase().contains(text.toLowerCase())) {
          searchItems.add(element);
        }
      });
      setState(() {
        _items = searchItems;
      });
    } else {
      setState(() {
        _items = widget.items;
      });
    }
  }
}
