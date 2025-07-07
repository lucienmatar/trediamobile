import 'package:ShapeCom/config/utils/my_color.dart';
import 'package:ShapeCom/config/utils/style.dart';
import 'package:ShapeCom/config/utils/util.dart';
import 'package:ShapeCom/domain/controller/my_order/my_order_controller.dart';
import 'package:ShapeCom/domain/product/my_product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

import '../../../config/route/route.dart';
import '../../../config/utils/dimensions.dart';
import '../../../config/utils/my_images.dart';
import '../../../config/utils/my_strings.dart';
import '../../components/text/cart_sub_text.dart';

class MyOrderScreen extends StatefulWidget {
  final String customRoute;
  final bool isShowBackButton;

  const MyOrderScreen({super.key, this.customRoute = "", this.isShowBackButton = true});

  @override
  State<MyOrderScreen> createState() => _MyOrderScreenState();
}

class _MyOrderScreenState extends State<MyOrderScreen> {
  final myOrderController = Get.put(MyOrderController());
  final ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.hasClients) {
      final double currentPosition = _scrollController.position.pixels;
      final double maxScrollExtent = _scrollController.position.maxScrollExtent;
      const double threshold = 100.0; // Trigger when 100px from the bottom

      // Check if we're near the bottom
      if (maxScrollExtent - currentPosition <= threshold) {
        print("Reached the bottom, loading more...");
        myOrderController.refreshLoadMoreItem();
      }
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll); // Clean up listener
    _scrollController.dispose(); // Dispose of the controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.offNamed(RouteHelper.bottomNavBar);
        return true;
      },
      child: GetBuilder<MyOrderController>(
        builder: (controller) => PopScope(
          canPop: false,
          child: Scaffold(
            backgroundColor: MyColor.backGroundScreenColor,
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
                        Get.offAllNamed(RouteHelper.bottomNavBar);
                      },
                      icon: SvgPicture.asset(MyImages.backButton))
                  : null,
              automaticallyImplyLeading: false,
            ),
            body: myOrderController.isLoading
                ? buildShimmer()
                : myOrderController.totalMyOrderCount > 0
                    ? SafeArea(
                        child: RefreshIndicator(
                          color: MyColor.primaryColor,
                          backgroundColor: Colors.white,
                          onRefresh: myOrderController.refreshItem,
                          child: SingleChildScrollView(
                            controller: _scrollController,
                            child: ListView.separated(
                              separatorBuilder: (context, index) => const SizedBox(height: 12),
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              shrinkWrap: true,
                              itemCount: myOrderController.totalMyOrderCount,
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                // Get the purchase date string from the API
                                final purchaseDateString = myOrderController.myOrderModel?.data?.orders?[index].purchaseDate?.toString() ?? "";

                                // Parse and format the date
                                String formattedDate = "";
                                if (purchaseDateString.isNotEmpty) {
                                  try {
                                    final dateTime = DateTime.parse(purchaseDateString); // Parse the API date string
                                    formattedDate = DateFormat('yyyy-MM-dd HH:mm').format(dateTime); // Format to date, hour, minute
                                  } catch (e) {
                                    formattedDate = purchaseDateString; // Fallback to raw string if parsing fails
                                  }
                                }
                                return GestureDetector(
                                    onTap: () => Get.offNamed(RouteHelper.trackOrderScreen, arguments: {"orderID": myOrderController.myOrderModel?.data?.orders?[index].orderID, "orderNO": myOrderController.myOrderModel?.data?.orders?[index].orderNO, "purchaseDate": myOrderController.myOrderModel?.data?.orders?[index].purchaseDate}),
                                    child: Container(
                                      width: double.maxFinite,
                                      padding: EdgeInsets.only(left: Dimensions.space15, right: Dimensions.space15, top: Dimensions.space15, bottom: Dimensions.space10),
                                      decoration: BoxDecoration(
                                        color: MyColor.colorWhite,
                                        borderRadius: BorderRadius.circular(Dimensions.cardRadius),
                                        boxShadow: MyUtils.getCardShadow(),
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              ClipOval(
                                                child: FadeInImage.assetNetwork(
                                                  placeholder: MyImages.splashLogo,
                                                  image: 'https://example.com/image.jpg',
                                                  width: 40,
                                                  height: 40,
                                                  fit: BoxFit.cover,
                                                  imageErrorBuilder: (context, error, stackTrace) => Image.asset(MyImages.splashLogo, width: 40, height: 40, fit: BoxFit.cover),
                                                ),
                                              ),
                                              SizedBox(width: 10),
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    myOrderController.myOrderModel?.data?.orders?[index].orderNO.toString() ?? "",
                                                    style: semiBoldLargeInter,
                                                  ),
                                                  const SizedBox(height: 2),
                                                  Text(
                                                    formattedDate,
                                                    style: regularDefaultInter.copyWith(color: MyColor.cartSubtitleColor, height: 1.7, wordSpacing: 2, fontSize: 12),
                                                  ),
                                                ],
                                              ),
                                              const Spacer(),
                                              const Icon(
                                                Icons.arrow_forward_ios_sharp,
                                                size: Dimensions.space15,
                                              )
                                            ],
                                          ),
                                          SizedBox(height: 10),
                                          ListView.separated(
                                            separatorBuilder: (context, index) => const SizedBox(height: 5),
                                            shrinkWrap: true,
                                            physics: NeverScrollableScrollPhysics(),
                                            itemCount: myOrderController.myOrderModel!.data!.orders![index].orderItemsLength!,
                                            itemBuilder: (context, index1) {
                                              return Row(
                                                children: [
                                                  Text(
                                                    myOrderController.myOrderModel?.data?.orders?[index].orderItems?[index1].qty?.toInt().toString() ?? "",
                                                    style: regularDefault.copyWith(color: MyColor.primaryColor),
                                                  ),
                                                  SizedBox(width: 5),
                                                  Text(
                                                    myOrderController.myOrderModel?.data?.orders?[index].orderItems?[index1].itemName ?? "",
                                                    style: regularDefault,
                                                  ),
                                                ],
                                              );
                                            },
                                          ),
                                          SizedBox(height: 5),
                                          Text(
                                            myOrderController.myOrderModel?.data?.orders?[index].otherItemsText ?? "",
                                            style: regularDefault.copyWith(color: MyColor.cartSubtitleColor),
                                          ),
                                          SizedBox(height: 5),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "${MyStrings.total} ${myOrderController.myOrderModel?.data?.orders?[index].sellingCurrencyLogo ?? ""} ${myOrderController.myOrderModel?.data?.orders?[index].total ?? ""}",
                                                style: regularDefault,
                                              ),
                                              Text(
                                                myOrderController.myOrderModel?.data?.orders?[index].orderStatus ?? "",
                                                style: regularDefault,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ));
                              },
                            ),
                          ),
                        ),
                      )
                    : SafeArea(child: RefreshIndicator(color: MyColor.primaryColor, backgroundColor: Colors.white, onRefresh: myOrderController.refreshItem, child: Center(
              child: MyUtils.noRecordsFoundWidget(),
            ),)),
          ),
        ),
      ),
    );
  }

  buildShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: ListView.separated(
        separatorBuilder: (context, index) => const SizedBox(height: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shrinkWrap: true,
        itemCount: 10,
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, index) {
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
                          child: SizedBox(height: 50),
                        ),
                        const SizedBox(width: Dimensions.space16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("", style: boldSmall.copyWith(color: MyColor.naturalDark)),
                              Text("", style: semiBoldLarge.copyWith(fontSize: 14), maxLines: 1),
                              const SizedBox(height: 4),
                              Text("", style: mediumDefault.copyWith(color: MyColor.naturalDark)),
                              const SizedBox(height: Dimensions.cardContentSpace),
                              Text("", style: boldDefault),
                              const SizedBox(height: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(50), color: MyColor.pendingColor.withOpacity(.6)),
                                child: Text("", style: mediumSmall.copyWith(color: MyColor.colorWhite)),
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
      ),
    );
  }
}
