import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../config/utils/dimensions.dart';
import '../../config/utils/my_color.dart';
import '../../config/utils/my_images.dart';
import '../../config/utils/my_strings.dart';
import '../../config/utils/style.dart';
import 'buttons/rounded_button.dart';

class WarningAlertDialog {
  const WarningAlertDialog();
  void warningAlertDialog(BuildContext context, VoidCallback press, {String? titleMessage, String? subtitleMessage, bool isDelete = false}) {
    titleMessage = titleMessage;
    subtitleMessage = subtitleMessage;
    showDialog(
        context: context,
        builder: (context) => Dialog(
              backgroundColor: MyColor.getCardBgColor(),
              insetPadding: const EdgeInsets.symmetric(horizontal: Dimensions.space40),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      padding: const EdgeInsets.only(top: Dimensions.space40, bottom: Dimensions.space15, left: Dimensions.space15, right: Dimensions.space15),
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(color: MyColor.getCardBgColor(), borderRadius: BorderRadius.circular(5)),
                      child: Column(
                        children: [
                          isDelete
                              ? Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 10),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        MyStrings.deleteYourAccount,
                                        style: semiBoldLarge.copyWith(color: MyColor.colorRed),
                                        textAlign: TextAlign.center,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                      ),
                                      const SizedBox(height: Dimensions.space20),
                                      Text(
                                        MyStrings.deleteAccountMessage,
                                        style: regularSmall.copyWith(color: MyColor.getTextColor()),
                                        textAlign: TextAlign.center,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 4,
                                      ),
                                    ],
                                  ),
                                )
                              : Column(
                                  children: [
                                    Text(
                                      titleMessage!,
                                      style: semiBoldLarge.copyWith(color: MyColor.colorRed),
                                      textAlign: TextAlign.center,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                    ),
                                    const SizedBox(height: Dimensions.space8),
                                    Text(
                                      subtitleMessage!,
                                      style: regularSmall.copyWith(color: MyColor.getTextColor()),
                                      textAlign: TextAlign.center,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 4,
                                    ),
                                  ],
                                ),
                          const SizedBox(height: Dimensions.space15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: RoundedButton(
                                  text: MyStrings.no,
                                  press: () {
                                    Navigator.pop(context);
                                  },
                                  verticalPadding: 14,
                                  isColorChange: true,
                                  color: MyColor.naturalLight,
                                  textColor: MyColor.colorWhite,
                                ),
                              ),
                              const SizedBox(width: Dimensions.space10),
                              Expanded(
                                child: RoundedButton(text: MyStrings.yes, press: press, verticalPadding: 14, color: MyColor.redCancelTextColor, textColor: MyColor.colorWhite),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                    Positioned(
                      top: -30,
                      left: MediaQuery.of(context).padding.left,
                      right: MediaQuery.of(context).padding.right,
                      child: Image.asset(
                        MyImages.warning,
                        height: 60,
                        width: 60,
                      ),
                    )
                  ],
                ),
              ),
            ));
  }
}
