import 'package:ShapeCom/config/utils/my_color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../config/utils/my_images.dart';

class TopShape extends StatelessWidget {
  final double top;
  const TopShape({super.key, this.top = 0});

  @override
  Widget build(BuildContext context) {
    return Positioned(top: top, child: SizedBox(width: context.width, child: Image.asset(MyImages.topShape, fit: BoxFit.fill, color: MyColor.primaryColor)));
  }
}
