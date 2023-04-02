
import 'package:cvetovik/pages/profile/markets/models/regions.dart';
import 'package:flutter/material.dart';

class RegionDropDown extends StatefulWidget {
  final Function(RegionModel) onSelect;
  final List<RegionModel> items;

  const RegionDropDown({required this.items, required this.onSelect, Key? key}) : super(key: key);

  @override
  State<RegionDropDown> createState() => _RegionDropDownState();
}

class _RegionDropDownState extends State<RegionDropDown> {
  RegionModel? selectorModel;

  @override
  Widget build(BuildContext context) => Container(height: 55,
    padding: const EdgeInsets.symmetric(horizontal: 8),
    decoration: BoxDecoration(color: Colors.white,
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8)),
    child: Row(
      children: [
        const SizedBox(
          width: 12,
        ),
        Expanded(
            child: Text(
                selectorModel != null ? selectorModel!.title : 'Выберите')),
        DropdownButton<RegionModel>(
          underline: const SizedBox(),
          items: widget.items
              .map((RegionModel e) => DropdownMenuItem<RegionModel>(
            value: e,
            child: Text(
              e.title,
              style: const TextStyle(
                  fontSize: 14, fontWeight: FontWeight.w400),
            ),
          ))
              .toList(),
          onChanged: (value) {
            setState(() {
              selectorModel = value;
            });
            widget.onSelect(value!);
          },
        ),
      ],
    ),
  );
}
