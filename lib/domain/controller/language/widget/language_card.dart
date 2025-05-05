import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../config/utils/dimensions.dart';
import '../../../../config/utils/my_color.dart';
import '../../../../config/utils/style.dart';
import '../../../../config/utils/util.dart';
import '../../../../presentation/components/text/small_text.dart';

class LanguageCard extends StatelessWidget {
  final int index;
  final int selectedIndex;
  final bool isShowTopRight;
  final String langeName;
  final String imagePath;

  const LanguageCard({super.key, required this.index, required this.selectedIndex, this.isShowTopRight = false, required this.langeName, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Card(
          shadowColor: MyColor.naturalLight,
          child: Container(
            padding: const EdgeInsetsDirectional.symmetric(vertical: Dimensions.space25),
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: MyColor.getCardBgColor(),
                borderRadius: BorderRadius.circular(8),
                boxShadow: MyUtils.getCardShadow(),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment:MainAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Image.asset(imagePath,width: 50,height: 50,fit: BoxFit.cover)
                ),
                const SizedBox(height: Dimensions.space10),
                SmallText(
                  text: langeName.tr,
                  textStyle: semiBoldSmall.copyWith(color: MyColor.getTextColor()),
                )
              ],
            ),
          ),
        ),
        index == selectedIndex
            ? isShowTopRight
            ? Positioned(
          right: Dimensions.space12,
          top: Dimensions.space10,
          child: Container(
            height: 20,
            width: 20,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: MyColor.getPrimaryColor(),
              shape: BoxShape.circle,
            ),
            child:  const Icon(Icons.check, color: MyColor.colorWhite, size: 10),
          ),
        )
            : Positioned(
          left: 50,
          right: 50,
          top: 25,
          child: Container(
            height: 55,
            width: 55,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: MyColor.getPrimaryColor().withOpacity(0.6),
              shape: BoxShape.circle,
            ),
            child:  const Icon(Icons.check, color: MyColor.colorWhite, size: 22.5),
          ),
        )
            : const Positioned(
          top: Dimensions.space10,
          right: Dimensions.space12,
          child: SizedBox(),
        )
      ],
    );
  }
}
