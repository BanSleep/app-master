import 'dart:io';

import 'package:cvetovik/core/ui/app_colors.dart';
import 'package:cvetovik/core/ui/app_text_styles.dart';
import 'package:cvetovik/core/ui/app_ui.dart';
import 'package:cvetovik/widgets/share/value_mixin.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

enum TextFieldType { normal, phone, url, email, number, cardNumber, cardCvc }

class AppTextField extends StatefulWidget {
  final String title;
  final String? hint;
  final String? errorText;
  final TextFieldType textFieldType;
  final int minLength;
  final int maxLines;
  final Function? onChange;
  final String? text;
  final bool? readOnly;
  final bool isVisibleText;

  const AppTextField({
    Key? key,
    required this.title,
    this.hint,
    this.minLength = 0,
    this.errorText,
    this.textFieldType = TextFieldType.normal,
    this.maxLines = 1,
    this.onChange,
    this.text,
    this.readOnly,
    this.isVisibleText = true,
  }) : super(key: key);

  @override
  _AppTextFieldState createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> with GetStrMixin {
  late MaskTextInputFormatter _phoneFormatter;
  late MaskTextInputFormatter _bonusCardNumberFormatter;
  late MaskTextInputFormatter _bonusCardCvcFormatter;

  String value() {
    //_phoneFormatter.getUnmaskedText();
    var text = _controller.text;
    if (text.isEmpty || text.length < widget.minLength) {
      setState(() {
        isError = true;
      });
      return '';
    }
    if (widget.textFieldType == TextFieldType.url) {
      var url = Uri.tryParse(text);
      if (url == null) {
        setState(() {
          isError = true;
        });
        return '';
      }
    }

    if (widget.textFieldType == TextFieldType.email) {
      final bool isValid = EmailValidator.validate(text);
      if (!isValid) {
        setState(() {
          isError = true;
        });
        return '';
      }
    }

    return _controller.text;
  }

  @override
  void initState() {
    _controller.addListener(_onListener);
    if (widget.text != null) _controller.text = widget.text!;
    _phoneFormatter = MaskTextInputFormatter(
      mask: AppUi.phoneMask2,
    );
    _bonusCardNumberFormatter =
        MaskTextInputFormatter(mask: AppUi.bonusCardNumberMask);
    _bonusCardCvcFormatter = MaskTextInputFormatter(
      mask: AppUi.bonusCardCvcMask,
    );
    super.initState();
  }

  final _controller = TextEditingController();

  bool isError = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Visibility(
          visible: widget.title.isNotEmpty,
          child: Padding(
            padding: EdgeInsets.only(bottom: 8.0.h),
            child: Text(
              widget.title,
              textAlign: TextAlign.start,
              style: AppTextStyles.textField,
            ),
          ),
        ),
        Localizations(
          locale: Locale('en'),
          delegates: [
            GlobalMaterialLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            DefaultWidgetsLocalizations.delegate,
          ],
          child: TextFormField(
            readOnly: widget.readOnly == true,
            style: widget.isVisibleText ? AppTextStyles.textField : AppTextStyles.textDateTime.copyWith(fontSize: 12.r),
            controller: _controller,
            maxLines: widget.maxLines,
            inputFormatters: (widget.textFieldType == TextFieldType.phone)
                ? [_phoneFormatter]
                : (widget.textFieldType == TextFieldType.cardNumber
                    ? [_bonusCardNumberFormatter]
                    : (widget.textFieldType == TextFieldType.cardCvc
                        ? [_bonusCardCvcFormatter]
                        : null)),
            keyboardType: _getKeyboardType(),
            decoration: InputDecoration(
              errorText: (isError) ? widget.errorText : null,
              //prefixText: (widget.isPhone)? phoneCode: null,
              hintText: widget.hint,
              //(showHint)? widget.hint:null,
              hintStyle: AppTextStyles.textLarge.copyWith(fontSize: 12.sp),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.r),
                borderSide: BorderSide(
                  width: 0,
                  style: BorderStyle.none,
                ),
              ),
              filled: true,
              contentPadding: EdgeInsets.all(10.w),
              fillColor: AppColors.fillColor,
            ),
          ),
        ),
      ],
    );
  }

  TextInputType _getKeyboardType() {
    switch (widget.textFieldType) {
      case TextFieldType.normal:
      case TextFieldType.url:
        return TextInputType.name;
      case TextFieldType.email:
        return TextInputType.emailAddress;
      case TextFieldType.phone:
      case TextFieldType.cardNumber:
      case TextFieldType.cardCvc:
      case TextFieldType.number:
        return Platform.isAndroid
            ? TextInputType.number
            : TextInputType.numberWithOptions(signed: true, decimal: true);
    }
  }

  void _onListener() {
    if (widget.textFieldType == TextFieldType.phone) {
      if (_controller.text.length >= 2) {
        if (_controller.text[1] == '8') {
          var start = '+7';
          _controller.text = start + _controller.text.substring(2);
          _controller.selection = TextSelection.fromPosition(
              TextPosition(offset: _controller.text.length));
        } else {
          /*if (_controller.text[1] =='9' ){
            var start = '+79';
            var length = _controller.text.length;
            if(length>2){
              length = 3;
            }
            _controller.text = start + _controller.text.substring(length);
            _controller.selection = TextSelection.fromPosition(TextPosition(offset: _controller.text.length));
          }*/
        }
      }
    }
    if (widget.onChange != null) {
      widget.onChange!(_controller.text);
    }
    if (isError && _controller.text.isNotEmpty) {
      setState(() {
        isError = false;
      });
    }
  }
}
