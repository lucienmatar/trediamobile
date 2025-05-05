import 'package:ShapeCom/config/utils/my_color.dart';
import 'package:ShapeCom/config/utils/style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomDropdown extends StatelessWidget {
  final String hintText;
  final List<String> items;
  final Widget? prefixIcon;
  var selectedValue = ''.obs;
  final Function(String) onChanged;

  CustomDropdown({
    Key? key,
    required this.hintText,
    required this.items,
    this.prefixIcon,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadiusDirectional.circular(20)),
      child: Obx(
        () => DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            isExpanded: true,
            value: selectedValue.value.isEmpty ? null : selectedValue.value,
            hint: Row(
              children: [
                if (prefixIcon != null) prefixIcon!,
                if (prefixIcon != null) const SizedBox(width: 10),
                Text(hintText, style: regularLarge.copyWith(color: MyColor.secondaryTextColor)),
              ],
            ),
            icon: Icon(Icons.arrow_drop_down, color: MyColor.colorLightGrey),
            items: items.map((String item) {
              return DropdownMenuItem<String>(
                  value: item,
                  child: Text(hintText, style: regularLarge.copyWith(color: MyColor.secondaryTextColor)),
              );
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                selectedValue.value = value;
              }
              onChanged(value!); // Return the selected value
            },
          ),
        ),
      ),
    );
  }
}
