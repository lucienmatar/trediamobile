import 'package:ShapeCom/domain/controller/coupon_code/coupon_code_controller.dart';
import 'package:ShapeCom/presentation/components/app-bar/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ShapeCom/config/utils/my_color.dart';
import 'package:ShapeCom/config/utils/style.dart';
import '../../../config/utils/my_images.dart';
import '../../../config/utils/my_strings.dart';
import '../../components/app-bar/custom_appbar_mab.dart';

class CouponCodeScreen extends StatefulWidget {
  const CouponCodeScreen({super.key});

  @override
  State<CouponCodeScreen> createState() => _CouponCodeScreenState();
}

class _CouponCodeScreenState extends State<CouponCodeScreen> {

  @override
  void initState() {
    Get.put(CouponCodeController());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CouponCodeController>(
      builder: (controller) => Scaffold(
        backgroundColor: MyColor.colorLightGrey,
        appBar: CustomAppBar(
          title: MyStrings.couponCode,
          leadingImage: MyImages.backButton,
        ),
        body: ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          physics: const BouncingScrollPhysics(),
          itemCount: 10,
          itemBuilder: (context, index) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 14 ),
              margin: const EdgeInsets.symmetric(vertical: 6),
              decoration: BoxDecoration(
                color: MyColor.colorWhite,
                borderRadius: BorderRadius.circular(8)
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset(MyImages.paypal,width: 40,height: 40,),
                  const SizedBox(width: 10,),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(controller.couponCodeList[index].codeType,style: boldDefault.copyWith(color: MyColor.bodyTextColor)),
                        const SizedBox(height: 6),
                        Text("${controller.couponCodeList[index].discountPercent}% OFF",style: boldLarge.copyWith(fontSize: 14)),
                        const SizedBox(height: 6),
                        Text("Valid till Nov ${controller.couponCodeList[index].validDate}",style: boldDefault.copyWith(color: MyColor.bodyTextColor),),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 6),
                    decoration: BoxDecoration(
                      color: MyColor.naturalLight.withOpacity(.15),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      children: [
                        Text(controller.couponCodeList[index].couponCode,style: boldDefault),
                        const SizedBox(width: 20),
                        Image.asset(MyImages.copy,width: 14,height: 14,color: MyColor.naturalDark,)
                      ],
                    ),
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
