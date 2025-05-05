import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ShapeCom/config/utils/my_color.dart';

class RoundedButton extends StatelessWidget {

  final bool isColorChange;
  final String text;
  final VoidCallback press;
  final Color color;
  final Color? textColor;
  final Color outlineColor;
  final double width;
  final double horizontalPadding;
  final double verticalPadding;
  final double cornerRadius;
  final bool isOutlined;
  final Widget? child;
  final double? customSize;

  const RoundedButton({
    Key? key,
    this.isColorChange = false,
    this.width=1,
    this.child,
    this.cornerRadius=50,
    required this.text,
    this.outlineColor = MyColor.primaryButtonColor,
    required this.press,
    this.isOutlined=false,
    this.horizontalPadding=35,
    this.verticalPadding=18,
    this.color = MyColor.primaryColor,
    this.textColor = MyColor.colorWhite,
    this.customSize
  }):super(key: key) ;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return isOutlined? InkWell(
      onTap: press,
      splashColor: MyColor.getScreenBgColor(),
      child: Container(
          padding:  EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: verticalPadding - 3),
          width: size.width * width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(cornerRadius),
            color: MyColor.getScreenBgColor(),
            border: Border.all(width: 1,color: outlineColor)
          ),
          child: child ?? Center(child: Text(text.tr,style:TextStyle(color: isColorChange ? textColor : MyColor.getPrimaryColor(), fontSize: 14, fontWeight: FontWeight.w500)))),
    ): SizedBox(
      width: customSize ?? size.width * width,
      child: ElevatedButton(
        onPressed: press,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shadowColor: MyColor.transparentColor,
          padding:  EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: verticalPadding),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(cornerRadius)),
          textStyle: TextStyle(color: textColor, fontSize: 14, fontWeight: FontWeight.w500)
        ), child: Text(
          text.tr,
          style: TextStyle(color: textColor),
        ),
      ),
    );
  }
}