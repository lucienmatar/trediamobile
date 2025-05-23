import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../config/utils/dimensions.dart';
import '../../../../config/utils/my_color.dart';
import '../../../../config/utils/my_strings.dart';
import '../../../../config/utils/style.dart';
import '../../../../domain/controller/payment_log/payment_log_controller.dart';
import '../../../components/divider/horizontal_divider.dart';
class PaymentLogCart extends StatelessWidget {

  final PaymentLogController controller;

  const PaymentLogCart({

    super.key,
    required this.controller
  });

  @override
  Widget build(BuildContext context) {

    return Container(
      padding: Dimensions.paymentLogCartPadding,
      margin: const EdgeInsets.only(bottom:Dimensions.space5),
      color: MyColor.colorWhite,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text("\$${controller.paymentAmount} ",style: boldOverLarge),
              const CircleAvatar(
                backgroundColor: MyColor.colorOrange,
                radius: 3,
              ),
            ],
          ),
          const SizedBox(height: Dimensions.paymentLogContentHeight),
          Text(controller.transectionId,style: semiBoldDefault,),
          const SizedBox(height: Dimensions.paymentLogContentHeight),
          Row(
            children: [
              Text(MyStrings.dateText,style: regularSmall.copyWith(color: MyColor.iconColor)),
              const HorizontalDivider(),
              Text("${MyStrings.size} : ${controller.productSize}",style: regularSmall.copyWith(color: MyColor.iconColor)),
              const Spacer(),
              Text(MyStrings.stripeHosted.tr,style: mediumDefault)
            ],
          )
        ],
      ),
    );
  }
}
