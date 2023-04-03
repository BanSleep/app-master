import 'package:cvetovik/const/app_res.dart';
import 'package:cvetovik/core/ui/app_all_colors.dart';
import 'package:cvetovik/core/ui/app_text_styles.dart';
import 'package:cvetovik/core/ui/app_ui.dart';
import 'package:cvetovik/widgets/share/value_mixin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

typedef AsyncSearchCallback = Future<void> Function(String text);

class SearchBarWidget extends StatefulWidget {
  const SearchBarWidget({Key? key, this.action, this.onTap, this.onChanged}) : super(key: key);
  final AsyncSearchCallback? action;
  final Function()? onTap;
  final Function(String)? onChanged;
  @override
  _SearchBarWidgetState createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget>
    with ClearValueMixin {
  late TextEditingController _textSearchController;
  bool _clearVisible = false;
  @override
  void initState() {
    _textSearchController = TextEditingController();
    _textSearchController.addListener(() async {
      setState(() {
        _clearVisible = _textSearchController.text.length > 0;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _textSearchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppUi.appBarPadding,
      child: TextField(
        onChanged: widget.onChanged,
        onTap: widget.onTap,
        onSubmitted: (text) async {
          if (widget.action != null) {
            await widget.action!(text);
          }
        },
        textInputAction: TextInputAction.search,
        readOnly: false,
        textAlign: TextAlign.left,
        controller: _textSearchController,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          suffixIcon: Visibility(
            visible: _clearVisible,
            child: IconButton(
              onPressed: _onClear,
              icon: Icon(
                Icons.close,
                color: Colors.grey,
                size: 20.w,
              ),
            ),
          ),
          prefixIcon: Icon(
            Icons.search,
            color: Colors.grey,
            size: 20.w,
          ),
          hintText: AppRes.hintSearch,
          hintStyle: AppTextStyles.textLarge,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide(
              width: 0,
              style: BorderStyle.none,
            ),
          ),
          filled: true,
          contentPadding: EdgeInsets.all(10.w),
          fillColor: AppAllColors.lightGrey,
        ),
      ),
    );
  }

  Future<void> _onClear() async {
    _textSearchController.text = '';
    if (widget.action != null) {
      await widget.action!('');
    }
  }

  @override
  Future<void> clear() async {
    await _onClear();
  }
}
