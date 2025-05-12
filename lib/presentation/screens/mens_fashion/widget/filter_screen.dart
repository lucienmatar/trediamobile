import 'package:ShapeCom/config/utils/my_constants.dart';
import 'package:ShapeCom/config/utils/util.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../config/utils/dimensions.dart';
import '../../../../config/utils/my_color.dart';
import '../../../../config/utils/my_images.dart';
import '../../../../config/utils/my_strings.dart';
import '../../../../config/utils/style.dart';
import '../../../../domain/controller/mens_fashion/filter_controller.dart';
import '../../../components/app-bar/custom_appbar_mab.dart';
import '../../../components/buttons/rounded_button.dart';
import '../../../components/divider/custom_divider.dart';

class FilterScreen extends StatelessWidget {
  final filterController = Get.put(FilterController());
  FilterScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<FilterController>(
      builder: (controller) => Scaffold(
        appBar: CustomAppBarWithMAB(
          title: MyStrings.filter,
          isShowBackBtn: true,
          leadingImage: MyImages.backButton,
          actionImage1: MyImages.search,
          actionPress2: () {},
        ),
        body: SafeArea(
          child: Container(
            height: double.maxFinite,
            color: MyColor.colorWhite,
            child: ListView(
              padding: Dimensions.filterDrawerPadding,
              children: [
                /* Text(MyStrings.categories.tr,style: semiBoldLargeInter.copyWith(fontWeight: FontWeight.w700)),
               const SizedBox(height: Dimensions.space21),
                const TitleText(title: MyStrings.electronics),
                const SizedBox(height: Dimensions.space18),
                MensFashionSection(controller: controller),
                const TitleText(title: MyStrings.healthAndBeauty),
                const SizedBox(height: Dimensions.space20),
                const TitleText(title: MyStrings.babysFashion),
                const SizedBox(height: Dimensions.space20),
                const TitleText(title: MyStrings.weddingsAndEvents),
                const CustomDivider(dividerHeight: 1,space: Dimensions.space34),
                 ColorSection(controller: controller),
                const CustomDivider(dividerHeight: 1,space: Dimensions.space34),*/
                filterController.categoryCount > 0 ? buildCategory() : const Offstage(),
                const CustomDivider(dividerHeight: 1, space: Dimensions.space34),
                filterController.currencyCount > 0 ? buildCurrencies() : const Offstage(),
                const CustomDivider(dividerHeight: 1, space: Dimensions.space34),
                filterController.isRangeValueLoaded ? buildPriceRangeSection() : const Offstage(),
                const SizedBox(height: Dimensions.space50),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: RoundedButton(
            press: () {
              MyConstants.filtersApplied = true;
              MyConstants.filtersCategories = filterController.selectedCategoryIds.join(',');
              MyConstants.filtersCurrency = filterController.currencyModel!.data![filterController.selectedCurrencyValue!].display!;
              MyConstants.filtersRangeStartValue = filterController.rangeStartValue;
              MyConstants.filtersRangeEndValue = filterController.rangeEndValue;
              Get.back(result: "filtered"); // Close the screen
            },
            text: MyStrings.apply,
          ),
        ),
      ),
    );
  }

  Widget buildCategory() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(MyStrings.categories, style: semiBoldLargeInter.copyWith(fontWeight: FontWeight.w700, fontSize: 14)),
        Column(
          children: [
            const SizedBox(height: Dimensions.space20),
            ListView.builder(
              shrinkWrap: true,
              itemCount: filterController.categoryModel!.data!.length,
              itemBuilder: (context, index) {
                return ListTile(
                  dense: true, // Reduces internal padding
                  title: Text(filterController.categoryModel!.data![index].display!, style: regularDefaultInter.copyWith(fontSize: Dimensions.space13, color: MyColor.primaryTextColor)),
                  trailing: Checkbox(
                    value: filterController.categoryModel!.data![index].isChecked,
                    onChanged: (bool? value) {
                      filterController.categoryModel!.data![index].isChecked = value!;
                      if (value == true) {
                        filterController.selectedCategoryIds.add(filterController.categoryModel!.data![index].value!);
                      } else {
                        filterController.selectedCategoryIds.remove(filterController.categoryModel!.data![index].value!);
                      }
                      filterController.update();
                    },
                  ),
                  visualDensity: const VisualDensity(vertical: -4), // Adjust density to make it compact
                );
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget buildCurrencies() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(MyStrings.currencies, style: semiBoldLargeInter.copyWith(fontWeight: FontWeight.w700, fontSize: 14)),
        const SizedBox(height: Dimensions.space20),
        ListView.builder(
          shrinkWrap: true,
          itemCount: filterController.currencyCount,
          itemBuilder: (context, index) {
            return ListTile(
              dense: true, // Reduces internal padding
              title: Text(filterController.currencyModel!.data![index].display!),
              trailing: Radio<int>(
                value: index,
                groupValue: filterController.selectedCurrencyValue,
                onChanged: (int? value) {
                  filterController.selectedCurrencyValue = value;
                  filterController.getMaxOnlinePriceBasedOnCcyApi(filterController.currencyModel!.data![index].display!);
                },
              ),
              visualDensity: const VisualDensity(vertical: -4), // Adjust density to make it compact
            );
          },
        ),
      ],
    );
  }

  Widget buildPriceRangeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(MyStrings.priceRange, style: semiBoldLargeInter.copyWith(fontWeight: FontWeight.w700, fontSize: 14)),
        const SizedBox(height: Dimensions.space15),
        RangeSlider(
          activeColor: MyColor.primaryColor,
          inactiveColor: MyColor.textFieldDisableBorderColor,
          values: RangeValues(filterController.rangeStartValue, filterController.rangeEndValue),
          min: 0,
          max: double.parse(filterController.maxOnlinePriceBasedOnCcyModel!.data![0].display!),
          divisions: 50,
          onChanged: (RangeValues values) {
            filterController.setStartAndEndValue(values.start, values.end);
          },
        ),
        const SizedBox(
          height: Dimensions.space10,
        ),
        Row(
          children: [Text(MyStrings.price, style: regularDefaultInter.copyWith(fontSize: Dimensions.space14)), const Spacer(), Text("${filterController.rangeStartValue.toStringAsFixed(0)} - ${filterController.rangeEndValue.toStringAsFixed(0)}", style: regularDefaultInter.copyWith(fontSize: Dimensions.space14))],
        ),
      ],
    );
  }
}