import 'package:cvetovik/const/app_icons.dart';
import 'package:cvetovik/core/ui/app_all_colors.dart';
import 'package:cvetovik/core/ui/app_colors.dart';
import 'package:cvetovik/widgets/state/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

import '../../../core/services/providers/markets_provider.dart';

class InfoBasePage extends ConsumerStatefulWidget {
  final String title;
  final String pageName;

  const InfoBasePage({required this.pageName, required this.title, Key? key})
      : super(key: key);

  @override
  ConsumerState<InfoBasePage> createState() => _InfoBasePageState();
}

class _InfoBasePageState extends ConsumerState<InfoBasePage> {
  Future<String> getInfo() async {
    var markets = ref.read(marketsProvider);
    return await markets.getInfoText(widget.pageName);
  }

  @override
  void initState() {
    super.initState();
  }

  Widget infoRow(BuildContext context, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(top: 5),
          height: 5,
          width: 5,
          decoration:
              BoxDecoration(shape: BoxShape.circle, color: AppColors.primary),
        ),
        SizedBox(
          width: 10,
        ),
        Expanded(
          child: Text(
            text,
            style: Theme.of(context)
                .textTheme
                .displayLarge!
                .copyWith(fontWeight: FontWeight.w400, fontSize: 12),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Container(
          padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Column(
            children: [
              SizedBox(
                height: 16 + MediaQuery.of(context).padding.top,
              ),
              Stack(
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: SvgPicture.asset(
                          AppIcons.iArrowLeft,
                          width: 24,
                          height: 24,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(width: 36,),
                      Expanded(
                        child: Text(
                          widget.title,textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .displayMedium!
                              .copyWith(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 18,
                                  color: AppAllColors.black),
                        ),
                      ),
                      SizedBox(width: 36,),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 36,
              ),
              Expanded(
                child: FutureBuilder(
                    future: getInfo(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return SingleChildScrollView(
                            child: HtmlWidget(
                          snapshot.data as String,
                          enableCaching: true,
                        ));
                      } else {
                        return LoadingWidget();
                      }
                    }),
              )
            ],
          ),
        ),
      );
}
