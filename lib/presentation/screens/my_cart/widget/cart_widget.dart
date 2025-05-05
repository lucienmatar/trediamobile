import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ShapeCom/domain/product/my_product.dart';
import 'package:ShapeCom/presentation/components/warning_aleart_dialog.dart';
import 'package:ShapeCom/presentation/screens/my_cart/widget/quantity_button.dart';
import 'package:get/get.dart';

import '../../../../config/utils/dimensions.dart';
import '../../../../config/utils/my_color.dart';
import '../../../../config/utils/my_images.dart';
import '../../../../config/utils/my_strings.dart';
import '../../../../config/utils/style.dart';
import '../../../../domain/controller/my_cart/my_cart_controller.dart';
import '../../../components/divider/horizontal_divider.dart';
class CartWidget extends StatelessWidget {

  final MyCartController controller;
  final ProductModel productModel;

  const CartWidget({
    super.key,
    required this.controller,
    required this.productModel
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Row(
          children: [
            Container(
              width: context.width * .28,
              padding: const EdgeInsets.symmetric(horizontal: Dimensions.space8,vertical: 14),
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
                  Text(productModel.title,style: semiBoldLarge.copyWith(fontSize: 14),maxLines: 1),
                  const SizedBox(height: 4),
                  Text(productModel.size,style: mediumDefault.copyWith(color: MyColor.naturalDark),),
                  const SizedBox(height: 4),
                  Text("\$${productModel.price}",style: semiBoldLarge.copyWith(fontSize: 14,color: MyColor.primaryColor)),
                  const SizedBox(height: 8,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: MyColor.naturalDark,width: .5)
                        ),
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                controller.decreaseQuantity(productModel);
                              },
                              child: const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 4),
                                child: Icon(Icons.remove,color: MyColor.naturalDark,size: 20,),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 3),
                              decoration: const BoxDecoration(
                                border: Border.symmetric(vertical: BorderSide(color: MyColor.naturalDark))
                              ),
                              child: Text("${productModel.quantity}",style: mediumLarge.copyWith(color: MyColor.colorBlack)),
                            ),
                            GestureDetector(
                              onTap: () {
                                controller.increaseQuantity(productModel);
                              },
                              child: const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 4),
                                child: Icon(Icons.add,color: MyColor.naturalDark,size: 20,),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
        Positioned(
          right: 0,
          bottom: -5,
          child: IconButton(
            onPressed: () {
              const WarningAlertDialog().warningAlertDialog(
                subtitleMessage: "You want to delete this item?",
                context, () {Get.back();});
            },
            icon: SvgPicture.asset(MyImages.delete,width: 22,height: 22, colorFilter: const ColorFilter.mode(MyColor.primaryColor, BlendMode.srcIn)
          )
        ))
      ],
    );
  }
}

