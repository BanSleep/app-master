import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SuggestionPage extends StatelessWidget {
  const SuggestionPage({Key? key}) : super(key: key);

  Widget sugItem(BuildContext context) {
    return Container(margin: EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Container(
            height: 32,
            width: 32,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                    blurRadius: 15,
                    offset: Offset(0, 4),
                    color: Color(0xff000000).withOpacity(0.06)),
              ],
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'Букет из 1 000 грузинских роз микс в розовой упаковке'*2,
              style: Theme.of(context).textTheme.displayLarge!.copyWith(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  color: Color(0xff333333)),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) => Container(
        child: ListView.builder(
          itemBuilder: (context, index) =>sugItem(context),
          itemCount: 10,
        ),
      );
}
