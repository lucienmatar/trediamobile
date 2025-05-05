import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ShapeCom/domain/controller/wish_list/wish_list_controller.dart';
import 'package:ShapeCom/domain/product/my_product.dart';
import 'package:ShapeCom/presentation/components/custom_rating_widget.dart';
import 'package:ShapeCom/presentation/screens/my_cart/widget/quantity_button.dart';
import 'package:ShapeCom/presentation/screens/wish_list/widget/rating_widget_for_wish_list.dart';
import 'package:get/get.dart';

import '../../../../config/utils/dimensions.dart';
import '../../../../config/utils/my_color.dart';
import '../../../../config/utils/my_images.dart';
import '../../../../config/utils/my_strings.dart';
import '../../../../config/utils/style.dart';
import '../../../../domain/controller/my_cart/my_cart_controller.dart';
class WishListCartWidget extends StatelessWidget {
  final WishListController controller;
  final ProductModel productModel;
  final int index;

  const WishListCartWidget({
    super.key,
    required this.controller,
    required this.productModel,
    required this.index
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<WishListController>(
      builder: (controller) => Stack(
        children: [
          Row(
            children: [
              Container(
                width: context.width * .28,
                height: 90,
                padding: const EdgeInsets.symmetric(horizontal: Dimensions.space8),
                decoration: BoxDecoration(
                  color: MyColor.colorLightGrey,
                  borderRadius: BorderRadius.circular(Dimensions.space6),
                ),
                child: Image.asset(productModel.image),
              ),
              const SizedBox(width: Dimensions.space16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //const Text(controller.fav,style: semiBoldLarge,maxLines: 1),
                    const SizedBox(height: 4),
                    //Text("L, Black",style: mediumDefault.copyWith(color: MyColor.naturalDark)),
                    //const CustomRatingWidget(size: 13),
                    const SizedBox(height: 4),
                    const Text("\$59.00",style: boldDefault),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: IconButton(
              onPressed: () {
                print(index);
                //controller.mixProductList.removeAt(index);
                controller.update();
              },
              icon: SvgPicture.asset(MyImages.wishList,width: 18,height: 18, colorFilter: const ColorFilter.mode(MyColor.primaryColor, BlendMode.srcIn)
              )
            )
          )
        ],
      ),
    );
  }
}
