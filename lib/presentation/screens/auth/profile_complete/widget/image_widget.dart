import 'package:flutter/material.dart';
import 'package:ShapeCom/config/utils/my_color.dart';
import '../../../../../config/utils/my_images.dart';

class CustomImageWidget extends StatefulWidget {

  final String imagePath;
  final VoidCallback onClicked;
  final bool isEdit;
  final int listIndex;

  const CustomImageWidget({Key? key,
    required this.imagePath,
    this.listIndex = 0,
    required this.onClicked,
    this.isEdit = false
  }) : super(key: key);

  @override
  State<CustomImageWidget> createState() => _CustomImageWidgetState();
}

class _CustomImageWidgetState extends State<CustomImageWidget> {


  @override
  Widget build(BuildContext context) {

    return Center(
      child: Container(
        padding: EdgeInsets.zero,
        width: 90,
        height: 90,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(width: .5,color: MyColor.primaryColor.withOpacity(.1))
        ),
        child: ClipOval(
          child: Image.asset(
            MyImages.profileImage,
            fit: BoxFit.cover,
            width: 90,
            height: 90,
          ),
        ),
      ),
    );
  }
}