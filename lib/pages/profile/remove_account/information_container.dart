import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:cvetovik/const/app_icons.dart';
import 'package:cvetovik/core/ui/app_all_colors.dart';
import 'package:cvetovik/core/ui/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class InformationContainer extends StatefulWidget {
  final int index;

  const InformationContainer({
    Key? key,
    required this.index,
  }) : super(key: key);

  @override
  State<InformationContainer> createState() => _InformationContainerState();
}

class _InformationContainerState extends State<InformationContainer> {
  static const List<String> titles = [
    'Доставка в пригород по ценам города',
    'Доставка антивирус+',
    'Условия самовывоза из розничных магазинов',
    'Условия и стоимость доставки',
    'Повторная доставка',
  ];
  static const List<String> subtitles = [
    'Доставка в пригородные районы, обычно стоит дороже, чем по городу? Мы решили это исправить и сделали специальные условия доставки в пригород!',
    'Мы понимаем, что не можем оставаться в стороне и игнорировать сложившуюся ситуацию в стране. Сейчас особенно важно заботиться о собственном здоровье и здоровье своих близких.',
    'Если Вы выбрали букет или композицию в нашем розничном магазине, Вы можете заказать услугу доставки. ',
    'При оформлении заказа в розничных магазинах. Если Вы выбрали букет или композицию в нашем розничном магазине, Вы можете заказать услугу доставки.  ',
    'Если в заказе был указан неверный адрес или другие данные, а также если получатель отсутствует по указанному адресу или отказывается принять товар, по какой бы то ни было причине, заказ считается выполненным. ',
  ];
  static const List<String> text = [
    'Теперь вы можете заказать букет с доставкой из ближайшего салона по городским ценам. Доставка осуществляется от 1 часа после подтверждения заказа.\n\nРайоны на которые действует предложение:\nПарголово\nСертолово\nМурино\nНовое Девяткино\nВсеволожск\nШлиссельбург\nМеталлострой\nКолпино\nТельмана\nПушкин\nГатчина\nКрасное Село\nСтрельна\nПетергоф\nЛомоносов\nКронштадт\n\n*Предложение действует с 09:00 до 21:00 в радиусе 7км. от ближайшего к адресу доставки салона Цветовик. Свыше 7км. стоимость составит + 35 рублей за каждый км.',
    'В связи с последними событиями сообщаем о принятых мерах предосторожности. Чтобы свести риски к минимуму, необходима профилактика. При оформлении заказа Вы можете воспользоваться бесплатной услугой «Антивирус+». При выборе даты и времени доставки, поставьте галочку напротив данной услуги. Передача букета будет осуществляться курьером в одноразовой медицинской маске и гигиенических перчатках.',
    '• При оформлении заказа до 11:00 самовывоз доступен после 16:00 текущего дня\n• При оформлении заказа до 14:00 самовывоз доступен после 20:00 текущего дня\n• При оформлении заказа после 18:00 самовывоз доступен после 16:00 на следующий день.',
    'Доставка осуществляется при сумме заказа более 1000руб.\nДоставка по Санкт-Петербургу осуществляется круглосуточно в 2-х часовой интервал времени.\nДоставка заказов по области производится в соответствии с режимом работы магазина и осуществляется в 3-х часовой интервал времени.\nДоставка к точному времени обсуждается с продавцом отдельно.\n',
    'В следующие сутки покупатель сможет получить заказ в салоне, самостоятельно или заказать повторную доставку. Стоимость повторной доставки в черте города - 350 руб. Доставка в область рассчитывается индивидуально.'
  ];

  bool isOpen = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      //duration: Duration(milliseconds: 500),
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Color(0xff0000000F),
            offset: Offset(0, 4),
            blurRadius: 15,
          ),
        ],
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            titles[widget.index],
            style: AppTextStyles.descriptionMedium10
                .copyWith(color: AppAllColors.black),
          ),
          7.w.heightBox,
          Row(
            children: [
              SizedBox(
                width: 215.w,
                child: Text(
                  subtitles[widget.index],
                  style: AppTextStyles.descriptionMedium
                      .copyWith(color: AppAllColors.lightBlack),
                ),
              ),
              const Spacer(),
              GestureDetector(
                child: SvgPicture.asset(AppIcons.arrow_down),
                onTap: () {
                  setState(() {
                    isOpen = !isOpen;
                  });
                },
              ),
            ],
          ),
          if (isOpen)
            SizedBox(
              width: 215.w,
              child: Text(
                text[widget.index],
                style: AppTextStyles.descriptionMedium
                    .copyWith(color: AppAllColors.lightBlack),
              ),
            ),
        ],
      ),
    ).paddingSymmetric(horizontal: 9.w);
  }
}