import 'package:flutter/material.dart';
import 'package:ShapeCom/config/route/route.dart';
import 'package:ShapeCom/config/utils/dimensions.dart';
import 'package:ShapeCom/config/utils/my_color.dart';
import 'package:ShapeCom/config/utils/style.dart';
import 'package:ShapeCom/domain/controller/shipping_address/shipping_address_controller.dart';
import 'package:ShapeCom/presentation/components/divider/custom_divider.dart';
import 'package:ShapeCom/presentation/components/text/cart_sub_text.dart';
import 'package:ShapeCom/presentation/screens/shipping_address/widget/add_new_address_section.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:shimmer/shimmer.dart';

import '../../../config/utils/my_images.dart';
import '../../../config/utils/my_strings.dart';
import '../../../config/utils/util.dart';
import '../../components/app-bar/custom_appbar.dart';
import '../../components/checkbox/circular_check_box.dart';

class ShippingAddressScreen extends StatefulWidget {
  const ShippingAddressScreen({super.key});

  @override
  State<ShippingAddressScreen> createState() => _ShippingAddressScreenState();
}

class _ShippingAddressScreenState extends State<ShippingAddressScreen> {
  var shippingAddressController = Get.put(ShippingAddressController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ShippingAddressController>(
      builder: (controller) => Scaffold(
        backgroundColor: MyColor.backGroundScreenColor,
        appBar: CustomAppBar(
          title: MyStrings.shippingAddress,
          leadingImage: MyImages.backButton,
        ),
        body: SingleChildScrollView(
          padding: Dimensions.shippingAddressPadding,
          child: Column(
            children: [
              Container(
                padding: Dimensions.shippingAddressPadding,
                decoration: BoxDecoration(color: MyColor.colorWhite, borderRadius: BorderRadius.circular(Dimensions.space5)),
                child: shippingAddressController.isLoading
                    ? buildShimmerEffect()
                    : shippingAddressController.myAddressesCount > 0
                        ? ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: shippingAddressController.myAddressesCount,
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () {
                                  shippingAddressController.setCurrentIndex(index, shippingAddressController.myAddressesModel!.data!.addresses![index].addressID);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 5),
                                  child: Row(
                                    children: [
                                      CircularCheckBox(controller: shippingAddressController, index: index),
                                      const SizedBox(width: Dimensions.space15),
                                      CartSubText(
                                        text: "${shippingAddressController.myAddressesModel?.data?.addresses?[index].qazaTown ?? ""}\n${shippingAddressController.myAddressesModel?.data?.addresses?[index].addressDetails ?? ""}",
                                        fontSize: 13,
                                      )
                                    ],
                                  ),
                                ),
                              );
                            },
                          )
                        : Center(child: MyUtils.noRecordsFoundWidget()),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildShimmerEffect() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: 10,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              children: [
                CircularCheckBox(controller: shippingAddressController, index: index),
                const SizedBox(width: Dimensions.space15),
                CartSubText(
                  text: '',
                  fontSize: 13,
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
