import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:google_fonts/google_fonts.dart';

class AppHtmlWidget extends StatelessWidget {
  final String value;

  const AppHtmlWidget(this.value, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HtmlWidget(
      value,
      textStyle: GoogleFonts.manrope(),
    );
  }
}
