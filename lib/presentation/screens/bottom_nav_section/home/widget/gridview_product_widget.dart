import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../../config/route/route.dart';
import '../../../../../config/utils/dimensions.dart';
import '../../../../../config/utils/my_color.dart';
import '../../../../../config/utils/style.dart';
import '../../../../../domain/controller/home/home_controller.dart';
import '../../../../../domain/product/my_product.dart';

class GridViewProductWidget extends StatelessWidget {
  final ScrollPhysics physics;
  final List<ProductModel> productModelList;
  GridViewProductWidget({super.key, required this.physics, required this.productModelList});
  final homeController = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.space2),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, mainAxisSpacing: 10, childAspectRatio: .74),
      itemCount: productModelList.length,
      physics: physics,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return Card(
          color: MyColor.colorWhite,
          surfaceTintColor: MyColor.colorWhite,
          shadowColor: MyColor.naturalLight,
          elevation: 1,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: Dimensions.space8),
            decoration: BoxDecoration(
              color: MyColor.colorWhite,
              borderRadius: BorderRadius.circular(Dimensions.space7),
            ),
            child: Container(
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      GestureDetector(
                        onTap: () => Get.toNamed(RouteHelper.productDetailsScreen2, arguments: productModelList[index]),
                        child: Column(
                          children: [
                            Container(
                                width: double.maxFinite,
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                margin: const EdgeInsets.all(2),
                                decoration: BoxDecoration(color: MyColor.colorLightGrey, borderRadius: BorderRadius.circular(10)),
                                child: Image.network(
                                  productModelList[index].image,
                                  width: 110,
                                  height: 110,
                                )),
                            const SizedBox(
                              height: 18,
                            )
                          ],
                        ),
                      ),
                      Positioned(
                          right: 10,
                          bottom: 0,
                          child: GestureDetector(
                            onTap: () {
                              homeController.addItemToCartApi(productModelList[index].productID, 1);
                            },
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(shape: BoxShape.circle, color: MyColor.primaryColor, border: Border.all(color: MyColor.colorWhite, width: 3)),
                              child: const Icon(
                                Icons.add,
                                size: 25,
                                color: MyColor.colorWhite,
                              ),
                            ),
                          ))
                    ],
                  ),
                  GestureDetector(
                    onTap: () => Get.toNamed(RouteHelper.productDetailsScreen2, arguments: productModelList[index]),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            productModelList[index].brand,
                            style: mediumDefault.copyWith(color: MyColor.bodyTextColor),
                          ),
                          Text(
                            productModelList[index].title,
                            style: mediumLarge,
                            maxLines: 1,
                          ),
                          Text(
                            productModelList[index].description,
                            style: mediumDefault.copyWith(color: MyColor.bodyTextColor),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Text(
                                '${productModelList[index].sellingCurrencyLogo}${NumberFormat.currency(
                                    locale: 'en_GB',
                                    symbol: '',
                                    decimalDigits: productModelList[index].sellingCurrencyLogo != '\$' && productModelList[index].sellingCurrencyLogo != '€' ? 0 : 2
                                ).format(productModelList[index].price)}',
                                style: mediumLarge.copyWith(fontSize: 15),
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              Text(
                                '${productModelList[index].sellingCurrencyLogo}${NumberFormat.currency(
                                    locale: 'en_GB',
                                    symbol: '',
                                    decimalDigits: productModelList[index].sellingCurrencyLogo != '\$' && productModelList[index].sellingCurrencyLogo != '€' ? 0 : 2
                                ).format(productModelList[index].onlinePriceBeforeDiscount)}',
                                style: mediumDefault.copyWith(color: MyColor.canceledTextColor, decoration: TextDecoration.lineThrough),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
