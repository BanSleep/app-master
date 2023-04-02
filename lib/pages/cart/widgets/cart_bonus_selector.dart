import 'package:cvetovik/core/ui/app_colors.dart';
import 'package:cvetovik/pages/user/personal/personal_start_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CartBonusSelector extends ConsumerStatefulWidget {
  final Function(int bonus) onChangedBonus;
  final int maxPrice;

  const CartBonusSelector(
      {required this.onChangedBonus, required this.maxPrice, Key? key})
      : super(key: key);

  @override
  ConsumerState<CartBonusSelector> createState() => _CartBonusSelectorState();
}

class _CartBonusSelectorState extends ConsumerState<CartBonusSelector> {
  double value = 0;

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(personalStartModelProvider);
    return state.when(
        initializing: () => Center(
              child: CircularProgressIndicator(),
            ),
        loaded: (data, info) {
          return (info.data != null &&
                  info.data!.bonusCard != null &&
                  info.data!.bonusCard!.balance != null)
              ? Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Использовать бонусы',
                        style: TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 16),
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                  blurRadius: 15,
                                  offset: Offset(0, 4),
                                  color: Color(0xff000000).withOpacity(0.06))
                            ]),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'У вас есть',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12),
                                ),
                                Text(
                                  '${info.data!.bonusCard!.balance} бонусов',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 12,
                                      color: AppColors.primary),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Использовать',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12),
                                ),
                                Text(
                                  '${value.toInt()} бонусов',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 12,
                                      color: AppColors.primary),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              '* До 50% от стоимости',
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 10,
                                  color: Color(0xffB0B0B0)),
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            info.data!.bonusCard!.balance == 0
                                ? SizedBox()
                                : Slider(
                                    max:(widget.maxPrice / 2)>info!.data!.bonusCard!.balance!.toDouble()?info!.data!.bonusCard!.balance!.toDouble(): (widget.maxPrice / 2).toDouble(),
                                    min: 0,
                                    value: value,
                                    onChanged: (newValue) {
                                      setState(() {
                                        widget.onChangedBonus(newValue.toInt());
                                        value = newValue;
                                      });
                                    },
                                    activeColor: AppColors.primary,
                                  ),
                            // SizedBox(
                            //   height: 7,
                            // ),
                            // Row(
                            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            //   children: [
                            //     Text(
                            //       'Использовать',
                            //       style: TextStyle(
                            //           fontWeight: FontWeight.w400,
                            //           fontSize: 12),
                            //     ),
                            //     Text(
                            //       '${value.toInt()} бонусов',
                            //       style: TextStyle(
                            //           fontWeight: FontWeight.w700,
                            //           fontSize: 12,
                            //           color: AppColors.primary),
                            //     )
                            //   ],
                            // ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              : SizedBox();
        },
        error: (String? text) {
          return SizedBox();
        });
  }
}
