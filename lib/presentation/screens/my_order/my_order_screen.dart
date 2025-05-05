import 'package:ShapeCom/config/utils/my_color.dart';
import 'package:ShapeCom/config/utils/style.dart';
import 'package:ShapeCom/config/utils/util.dart';
import 'package:ShapeCom/domain/controller/my_order/my_order_controller.dart';
import 'package:ShapeCom/domain/product/my_product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../config/route/route.dart';
import '../../../config/utils/dimensions.dart';
import '../../../config/utils/my_images.dart';
import '../../../config/utils/my_strings.dart';

class MyOrderScreen extends StatefulWidget {
  final String customRoute;
  final bool isShowBackButton;

  const MyOrderScreen({super.key, this.customRoute = "", this.isShowBackButton = true});

  @override
  State<MyOrderScreen> createState() => _MyOrderScreenState();
}

class _MyOrderScreenState extends State<MyOrderScreen> {
  final myOrderController = Get.put(MyOrderController());

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: MyColor.colorWhite,
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            MyStrings.myOrder,
            style: titleText,
          ),
          leading: widget.isShowBackButton
              ? IconButton(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onPressed: () {
                    if (widget.customRoute.isNotEmpty) {
                      Get.offAllNamed(widget.customRoute);
                    } else {
                      Get.back();
                    }
                  },
                  icon: SvgPicture.asset(MyImages.backButton))
              : null,
          automaticallyImplyLeading: false,
        ),
        body: myOrderController.totalMyOrderCount > 0
            ? ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                shrinkWrap: true,
                itemCount: myOrderController.totalMyOrderCount,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  var item = MyProduct.mixProductList[index];
                  return GestureDetector(
                      onTap: () => Get.toNamed(RouteHelper.trackOrderScreen),
                      child: Container(
                        color: MyColor.colorWhite,
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: context.width * .28,
                                  height: 120,
                                  padding: const EdgeInsets.symmetric(horizontal: Dimensions.space8),
                                  decoration: BoxDecoration(
                                    color: MyColor.colorLightGrey,
                                    borderRadius: BorderRadius.circular(Dimensions.space6),
                                  ),
                                  child: Image.asset(item.image),
                                ),
                                const SizedBox(width: Dimensions.space16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("#ASEDBKLKDHG", style: boldSmall.copyWith(color: MyColor.naturalDark)),
                                      Text(item.title, style: semiBoldLarge.copyWith(fontSize: 14), maxLines: 1),
                                      const SizedBox(height: 4),
                                      Text(item.size, style: mediumDefault.copyWith(color: MyColor.naturalDark)),
                                      const SizedBox(height: Dimensions.cardContentSpace),
                                      Text("\$${item.price}", style: boldDefault),
                                      const SizedBox(height: 8),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(50), color: item.status == MyStrings.delivered ? MyColor.greenSuccessColor : MyColor.pendingColor.withOpacity(.6)),
                                        child: Text(item.status!, style: mediumSmall.copyWith(color: MyColor.colorWhite)),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              margin: const EdgeInsets.symmetric(vertical: Dimensions.space14),
                              height: 1,
                              width: double.maxFinite,
                              color: MyColor.colorLightGrey,
                            )
                          ],
                        ),
                      ));
                },
              )
            : MyUtils.noRecordsFoundWidget(),
      ),
    );
  }
}
