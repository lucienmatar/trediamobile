import 'package:flutter/material.dart';
import 'package:ShapeCom/config/utils/my_color.dart';
import 'package:ShapeCom/config/utils/my_images.dart';
import 'package:ShapeCom/config/utils/my_strings.dart';
import 'package:ShapeCom/domain/controller/mens_fashion/mens_fashion_controller.dart';
import 'package:ShapeCom/domain/controller/top_brand/top_brand_controller.dart';
import 'package:ShapeCom/domain/product/my_product.dart';
import 'package:ShapeCom/presentation/components/app-bar/custom_appbar.dart';
import 'package:ShapeCom/presentation/components/checkbox/circular_check_box.dart';
import 'package:ShapeCom/presentation/components/divider/custom_divider.dart';
import 'package:ShapeCom/presentation/screens/bottom_nav_section/home/widget/gridview_product_widget.dart';
import 'package:ShapeCom/presentation/screens/mens_fashion/widget/brand_section.dart';
import 'package:ShapeCom/presentation/screens/mens_fashion/widget/color_section.dart';
import 'package:ShapeCom/presentation/screens/mens_fashion/widget/custom_check_box_circular.dart';
import 'package:ShapeCom/presentation/screens/mens_fashion/widget/filter_screen.dart';
import 'package:ShapeCom/presentation/screens/mens_fashion/widget/custom_search_field.dart';
import 'package:ShapeCom/presentation/screens/mens_fashion/widget/mens_fashion_rating_bar.dart';
import 'package:ShapeCom/presentation/screens/mens_fashion/widget/mens_fashion_section.dart';
import 'package:ShapeCom/presentation/screens/mens_fashion/widget/price_range_section.dart';
import 'package:ShapeCom/presentation/screens/mens_fashion/widget/search_bar_section.dart';
import 'package:ShapeCom/presentation/screens/mens_fashion/widget/size_section.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../config/route/route.dart';
import '../../../config/utils/dimensions.dart';
import '../../../config/utils/style.dart';
import '../bottom_nav_section/home/widget/visible_icon.dart';
class CategoryDetailsScreen extends StatefulWidget {

  final ProductModel category;

  const CategoryDetailsScreen({super.key, required this.category});

  @override
  State<CategoryDetailsScreen> createState() => _CategoryDetailsScreenState();
}

class _CategoryDetailsScreenState extends State<CategoryDetailsScreen> {


  @override
  void initState() {
    final controller = Get.put(MensFashionController());
    controller.loadCategory();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;

    return GetBuilder<MensFashionController>(
        builder: (controller) => Scaffold(
          endDrawer: FilterScreen(),
          //key: controller.scaffoldKey,
          backgroundColor: MyColor.screenBgColor,
          appBar: CustomAppBar(
            title: widget.category.title,
            isShowBackBtn: true,
            isTitleCenter: true,
            leadingImage: MyImages.backButton,
            actionImage: MyImages.card,
            isShowSingleActionBtn: true,
            actionPress: () {Get.toNamed(RouteHelper.myCartScreen);},
          ),
          body: Column(
            children: [
              SearchBarSection(controller: controller),
              const SizedBox(height: Dimensions.space8,),
              Expanded(
                child: GridViewProductWidget(physics: const BouncingScrollPhysics(), productModelList: controller.categoryList),
              ),
            ],
          ),
        )
    );
  }
}








