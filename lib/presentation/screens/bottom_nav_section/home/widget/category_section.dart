import 'package:flutter/material.dart';
import 'package:ShapeCom/config/utils/util.dart';
import 'package:ShapeCom/domain/product/my_product.dart';
import 'package:ShapeCom/presentation/components/image/circle_shape_image.dart';
import 'package:get/get.dart';

import '../../../../../config/route/route.dart';
import '../../../../../config/utils/dimensions.dart';
import '../../../../../config/utils/my_color.dart';
import '../../../../../config/utils/my_images.dart';
import '../../../../../config/utils/my_strings.dart';
import '../../../../../config/utils/style.dart';
import 'custom_row_header.dart';

class CategorySection extends StatelessWidget {
  String? categoryType = MyStrings.category;

  CategorySection({super.key, this.categoryType});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomRowHeader(title: categoryType!, viewAllPress: () {}),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Row(
              children: List.generate(
                  MyProduct.categoryList.length,
                  (index) => InkWell(
                        onTap: () => Get.toNamed(RouteHelper.categoryDetailsScreen, arguments: MyProduct.categoryList[index]),
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 10),
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(color: MyColor.colorLightGrey, borderRadius: BorderRadius.circular(100), boxShadow: MyUtils.getBottomSheetShadow()),
                                child: Image.asset(
                                  MyProduct.categoryList[index].image,
                                  width: 50,
                                  height: 50,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                MyProduct.categoryList[index].title,
                                style: mediumDefault.copyWith(fontSize: 12),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              )
                            ],
                          ),
                        ),
                      )),
            ),
          ),
        ),
        const SizedBox(
          height: Dimensions.space20,
        ),
      ],
    );
  }
}
