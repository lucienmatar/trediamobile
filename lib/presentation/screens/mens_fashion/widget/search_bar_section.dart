import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:ShapeCom/config/route/route.dart';

import '../../../../config/utils/dimensions.dart';
import '../../../../config/utils/my_color.dart';
import '../../../../config/utils/my_images.dart';
import '../../../../config/utils/my_strings.dart';
import '../../../../domain/controller/mens_fashion/mens_fashion_controller.dart';
import 'custom_search_field.dart';
class SearchBarSection extends StatelessWidget {

  final MensFashionController controller;

  const SearchBarSection({
    super.key,
    required this.controller
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.space16,vertical: Dimensions.space8),
      color: MyColor.colorWhite,
      child: Row(
        children: [
          Expanded(
            child: CustomSearchField(
              controller: controller.searchController,
              textInputType: TextInputType.name,
              hintText: "${MyStrings.searchIn.tr} ${MyStrings.appName}",
              focusNode: controller.searchFocusNode,
              labelText: MyStrings.searchIn.tr,
              onChanged: (value){},
              prefixIcon: MyImages.search,
              
              animatedLabel: false,
              needOutlineBorder: true,
              isSearch: true,
              validator: (value) {
                if(value.isEmpty){
                  return MyStrings.fieldErrorMsg.tr;
                }
                else{
                  return null;
                }
              },
            ),
          ),
          const SizedBox(width: Dimensions.space12,),
          InkWell(
            onTap: () {
              Get.toNamed(RouteHelper.filterScreen);
            },
            child: SvgPicture.asset(MyImages.filter)
          )
        ],
      ),
    );
  }
}