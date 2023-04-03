import 'package:cvetovik/const/app_res.dart';
import 'package:cvetovik/core/ui/app_colors.dart';
import 'package:cvetovik/core/ui/app_text_styles.dart';
import 'package:cvetovik/models/api/response/order/dadata_response.dart';
import 'package:cvetovik/models/api/response/suggestions_response.dart';
import 'package:flutter/material.dart';

class SuggestionsPage extends StatefulWidget {
  final List<SuggestionsData>? model;
  final List<dynamic>? suggestions;
  final Function(String) onTap;
  const SuggestionsPage({Key? key, this.model, this.suggestions, required this.onTap}) : super(key: key);

  @override
  _SuggestionsPageState createState() => _SuggestionsPageState();
}

class _SuggestionsPageState extends State<SuggestionsPage> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 30,),
          Text(AppRes.mostPopular, style: AppTextStyles.titleSmall,),
          Expanded(
            child: ListView.builder(itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  widget.onTap(widget.model != null ? widget.model![index].title : widget.suggestions![index]);
                },
                child: Container(
                  margin: EdgeInsets.only(bottom: 12),
                  child: Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(offset: Offset(0, 4), blurRadius: 15, spreadRadius: 0, color: Colors.black.withOpacity(0.06))
                          ]
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(5),
                          child: Image.asset('assets/images/flowers.png', width: 32, height: 32,),
                        ),
                      ),
                      SizedBox(width: 10,),
                      Expanded(child: Text('${widget.model != null ? widget.model![index].title : widget.suggestions![index]}', style: AppTextStyles.textDateTime.copyWith(color: AppColors.itemTitle),))
                    ],
                  ),
                ),
              );
            }, itemCount: widget.model != null ? widget.model!.length : widget.suggestions!.length, padding: EdgeInsets.only(top: 20),),
          )
        ],
      ),
    );
  }
}
