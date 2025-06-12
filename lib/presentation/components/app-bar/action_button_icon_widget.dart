import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ShapeCom/config/utils/my_color.dart';
import 'package:ShapeCom/config/utils/my_images.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:badges/badges.dart' as badges;
import 'package:ShapeCom/domain/controller/cart_controller/cartController.dart';

import '../../../config/utils/style.dart';

class ActionButtonIconWidget extends StatelessWidget {
  final Color backgroundColor;
  final Color iconColor;
  final VoidCallback? pressed;
  final double size;
  final double spacing;
  final IconData? icon;
  final bool isImage;
  final String? imageSrc;
  final bool isLoading;
  CartCountController cartCountController = Get.put(CartCountController());

  ActionButtonIconWidget({
    Key? key,
    this.backgroundColor = MyColor.primaryColor,
    this.iconColor = MyColor.colorWhite,
    required this.pressed,
    this.size = 30,
    this.spacing = 15,
    this.icon,
    this.imageSrc,
    this.isImage = false,
    this.isLoading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: pressed,
      child: Container(
        height: size,
        width: size,
        alignment: Alignment.center,
        padding: EdgeInsets.all(isLoading ? 5 : 0),
        margin: EdgeInsets.only(right: spacing),
        child: isLoading
            ? SizedBox(height: size / 2, width: size / 2, child: const CircularProgressIndicator(color: MyColor.primaryColor))
            : isImage
                ? imageSrc == MyImages.card
                    ? badges.Badge(
                        showBadge: true,
                        badgeStyle: const badges.BadgeStyle(
                          shape: badges.BadgeShape.circle,
                          badgeColor: Colors.white,
                          padding: EdgeInsets.all(5),
                          elevation: 0,
                        ),
                        badgeContent: Text(
                          cartCountController.cartCount.toString(),
                          style: regularSmall.copyWith(fontSize: 8, color: MyColor.colorRed),
                        ),
                        child: SvgPicture.asset(
                          imageSrc ?? "",
                          width: 20,
                          height: 20,
                        ),
                      )
                    : SvgPicture.asset(imageSrc!, height: 20, width: 20)
                : Icon(icon, color: iconColor, size: size),
      ),
    );
  }
}
