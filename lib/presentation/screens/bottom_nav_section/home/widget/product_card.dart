import 'package:flutter/material.dart';
import 'package:ShapeCom/config/route/route.dart';
import 'package:ShapeCom/presentation/screens/bottom_nav_section/home/widget/rating_widget.dart';
import 'package:ShapeCom/presentation/screens/bottom_nav_section/home/widget/visible_icon.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../../../config/utils/dimensions.dart';
import '../../../../../config/utils/my_color.dart';
import '../../../../../config/utils/my_images.dart';
import '../../../../../config/utils/my_strings.dart';
import '../../../../../config/utils/style.dart';
import '../../../../../domain/controller/home/home_controller.dart';
import '../../../../../domain/product/my_product.dart';
class ProductList extends StatelessWidget {

  final HomeController controller;
  final bool enableDiscount;
  final List<ProductModel> productList;

  const ProductList({
    super.key,
    required this.controller,
    this.enableDiscount = true,
    required this.productList
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SingleChildScrollView(
          padding: const EdgeInsets.only(left: Dimensions.space10 ),
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: List.generate(productList.length, (index){

              return GestureDetector(
                onTap: () {
                  Get.toNamed(RouteHelper.productDetailsScreen2,arguments: productList[index]);
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: Dimensions.space8),
                      padding: const EdgeInsets.all(Dimensions.space10),
                      width: context.width * .4,
                      decoration: BoxDecoration(
                        color: MyColor.colorLightGrey,
                        borderRadius: BorderRadius.circular(Dimensions.space7),
                      ),
                      child: Image.asset(productList[index].image,width: 110,height: 115),
                    ),

                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: Dimensions.space8),
                      width: context.width * .4,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: Dimensions.space10),
                          Text(productList[index].title,textAlign: TextAlign.center,style: boldLarge.copyWith(color: MyColor.colorBlack,fontSize: 14),maxLines: 1,overflow: TextOverflow.ellipsis,),
                          const SizedBox(height: 4),
                          Text(productList[index].description,style: mediumDefault.copyWith(color: MyColor.bodyTextColor),maxLines: 2,overflow: TextOverflow.ellipsis),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Text("\$${productList[index].price}",style: boldLarge),
                              const SizedBox(width: 10),
                              //Text("\$${(int.tryParse(productList[index].price)?? 100 ) + 200}",style: boldLarge.copyWith(fontSize: 12,decoration: TextDecoration.lineThrough,color: MyColor.bodyTextColor)),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              );
            }),
          ),
        ),
        const SizedBox(height: Dimensions.space30,)
      ],
    );
  }
}

