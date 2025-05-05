import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../config/utils/my_color.dart';
class StatusBarColorWidget extends StatelessWidget {

  final Widget child;
  final Color color;
  final Brightness iconBrightness;

  const StatusBarColorWidget({super.key,required this.child, this.color = MyColor.colorWhite, this.iconBrightness = Brightness.light });

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
          statusBarColor: color,
          statusBarBrightness: Brightness.light,
          statusBarIconBrightness: iconBrightness,
          systemNavigationBarColor: MyColor.colorWhite,
      ),
      child: child,
    );
  }
}
