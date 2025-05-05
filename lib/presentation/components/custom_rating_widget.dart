import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../config/utils/my_color.dart';
import '../../config/utils/my_images.dart';
import '../../config/utils/style.dart';
class CustomRatingWidget extends StatelessWidget {

  final double size;

  const CustomRatingWidget({
    super.key,
    this.size = 17
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Row(
          children: List.generate(5, (index) => SvgPicture.asset(MyImages.star,width: size,height: size)),
        ),
        Text(" (10)",style: regularSmall.copyWith(color: MyColor.naturalDark2))
      ],
    );
  }
}
