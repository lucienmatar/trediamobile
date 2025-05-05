import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../config/utils/dimensions.dart';
import '../../../../config/utils/my_color.dart';
import '../../../../config/utils/my_strings.dart';
import '../../../../config/utils/style.dart';
import '../../../../domain/controller/mens_fashion/filter_controller.dart';
import '../model/category_model.dart';

class BrandSection extends StatelessWidget {
  CategoryModel? categoryModel;
  BrandSection({super.key, required this.categoryModel});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(MyStrings.categories, style: semiBoldLargeInter.copyWith(fontWeight: FontWeight.w700, fontSize: 14)),
        const SizedBox(height: Dimensions.space20),
        Column(
          children: [
            ListView.builder(
                itemCount: categoryModel!.data!.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: Dimensions.space16),
                    child: Row(
                      children: [
                        Text(categoryModel!.data![index].display!, style: regularDefaultInter.copyWith(fontSize: Dimensions.space13, color: MyColor.primaryTextColor)),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.all(Dimensions.space4),
                          height: Dimensions.space18,
                          width: Dimensions.space18,
                          decoration: BoxDecoration(color: MyColor.primaryColor, border: Border.all(color: MyColor.colorGrey.withOpacity(.6), width: 1), shape: BoxShape.circle),
                          child: CheckboxListTile(
                            title: const Text(""),
                            value: categoryModel!.data![index].isChecked,
                            onChanged: (bool? value) {
                              categoryModel!.data![index].isChecked = value!;
                            },
                          ),
                        )
                      ],
                    ),
                  );
                })
          ],
          /*  List.generate(
              filterController.categoryModel!.data!.length,
              (index) => GestureDetector(
                    onTap: () => controller.setBrandSectionCurrentIndex(index),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: Dimensions.space16),
                      child: Row(
                        children: [
                          Text(controller.brandSectionList[index], style: regularDefaultInter.copyWith(fontSize: Dimensions.space13, color: MyColor.primaryTextColor)),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.all(Dimensions.space4),
                            height: Dimensions.space18,
                            width: Dimensions.space18,
                            decoration: BoxDecoration(color: controller.brandSectionCurrentIndex == index ? MyColor.primaryColor : null, border: controller.brandSectionCurrentIndex != index ? Border.all(color: MyColor.colorGrey.withOpacity(.6), width: 1) : null, shape: BoxShape.circle),
                            child: controller.brandSectionCurrentIndex == index ? SvgPicture.asset(MyImages.check) : const SizedBox.shrink(),
                          )
                        ],
                      ),
                    ),
                  )
          ),*/
        ),
      ],
    );
  }
}
