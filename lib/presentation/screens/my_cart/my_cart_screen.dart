import 'package:ShapeCom/config/utils/my_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:ShapeCom/config/utils/my_color.dart';
import 'package:ShapeCom/config/utils/my_images.dart';
import 'package:ShapeCom/config/utils/my_strings.dart';
import 'package:ShapeCom/domain/controller/my_cart/my_cart_controller.dart';
import 'package:shimmer/shimmer.dart';
import '../../../config/route/route.dart';
import '../../../config/utils/dimensions.dart';
import '../../../config/utils/style.dart';
import '../../../domain/product/my_product.dart';
import '../../components/warning_aleart_dialog.dart';

class MyCartScreen extends StatefulWidget {
  final bool isShowBackButton;

  const MyCartScreen({super.key, this.isShowBackButton = true});

  @override
  State<MyCartScreen> createState() => _MyCartScreenState();
}

class _MyCartScreenState extends State<MyCartScreen> {
  final myCartController = Get.put(MyCartController());
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MyCartController>(
      builder: (controller) => Scaffold(
          backgroundColor: MyColor.colorLightGrey,
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              MyStrings.myCart,
              style: titleText,
            ),
            leading: widget.isShowBackButton
                ? IconButton(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onPressed: () {
                      Get.back();
                    },
                    icon: SvgPicture.asset(MyImages.backButton))
                : null,
            automaticallyImplyLeading: false,
          ),
          body: RefreshIndicator(
            color: MyColor.primaryColor, // Color of the loading indicator
            backgroundColor: Colors.white, // Background color of the refresh indicator
            onRefresh: myCartController.refreshItem,
            child: myCartController.isShimmerShow == false
                ? myCartController.cartCount > 0
                    ? ListView.builder(
                        shrinkWrap: true,
                        itemCount: myCartController.cartCount,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              // Handle item tap
                              ProductModel productModel = ProductModel(image: "${MyConstants.imageBaseURL}${myCartController.myCartItemModel!.data!.items![index].imageURL}", brand: myCartController.myCartItemModel!.data!.items![index].categoryName!, title: myCartController.myCartItemModel!.data!.items![index].itemName!, description: "", onlinePriceBeforeDiscount: myCartController.myCartItemModel!.data!.items![index].sumOnlinePriceBeforeDiscount!.toDouble(), price: myCartController.myCartItemModel!.data!.items![index].sumOnlinePrice!.toDouble(), sellingCurrencyLogo: myCartController.myCartItemModel!.data!.items![index].sellingCurrencyLogo!, productID: myCartController.myCartItemModel!.data!.items![index].idItem!.toInt());
                              Future.delayed(const Duration(milliseconds: 100), () {
                                Get.toNamed(RouteHelper.productDetailsScreen2, arguments: productModel);
                              });
                            },
                            child: Container(
                              color: MyColor.colorWhite,
                              margin: const EdgeInsets.only(bottom: Dimensions.space4),
                              child: ListTile(
                                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                                title: buildCartWidget(index),
                              ),
                            ),
                          );
                        })
                    : SingleChildScrollView(
                        child: Container(
                          height: MediaQuery.of(context).size.height,
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(myCartController.noDataFound, style: semiBoldLarge.copyWith(fontSize: 14)),
                            ],
                          ),
                        ),
                      )
                : ListView.builder(
                    shrinkWrap: true,
                    itemCount: 10,
                    itemBuilder: (context, index) {
                      return Container(
                        color: MyColor.colorWhite,
                        margin: const EdgeInsets.only(bottom: Dimensions.space4),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                          title: buildShimmerCartWidget(),
                        ),
                      );
                    }),
          ),
          bottomNavigationBar: widget.isShowBackButton ? buildBottomSection() : const SizedBox.shrink()),
    );
  }

  Widget buildBottomSection() {
    return myCartController.loadTotalPrice
        ? Padding(
            padding: Dimensions.myCartBottomPadding,
            child: Row(
              children: [
                /* TextButton(
            onPressed: () {
            },
            child: Text(MyStrings.applyCopun, style: boldDefault.copyWith(color: MyColor.primaryColor)),
          ),
          const Spacer(),  */
                Text("${MyStrings.subTotal} : ${myCartController.subTotalPriceCart!.data!.subtotal!.sellingCurrencyLogo}${myCartController.subTotalPriceCart!.data!.subtotal!.subTotalPrice ?? "0"}", style: semiBoldLargeInter.copyWith(fontWeight: FontWeight.w500)),
                const SizedBox(width: Dimensions.space12),
                Text("${myCartController.subTotalPriceCart!.data!.subtotal!.sellingCurrencyLogo}${myCartController.subTotalPriceCart!.data!.subtotal!.subTotalPriceBeforeDiscount ?? "0"}", style: boldLarge.copyWith(fontSize: 12, decoration: TextDecoration.lineThrough, color: MyColor.bodyTextColor)),
                const SizedBox(width: Dimensions.space12),
                InkWell(
                  onTap: () {
                    myCartController.gotoCheckOutPage();
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(color: MyColor.primaryColor, borderRadius: BorderRadius.circular(4)),
                    child: Text(
                      MyStrings.checkOut,
                      style: regularDefault.copyWith(color: MyColor.colorWhite),
                    ),
                  ),
                )
              ],
            ),
          )
        : const Offstage();
  }

  Widget buildCartWidget(int index) {
    return Stack(
      children: [
        Row(
          children: [
            Container(
              width: context.width * .28,
              padding: const EdgeInsets.symmetric(horizontal: Dimensions.space8, vertical: 14),
              decoration: BoxDecoration(
                color: MyColor.colorLightGrey,
                borderRadius: BorderRadius.circular(Dimensions.space6),
              ),
              child: Image.network("${MyConstants.imageBaseURL}${myCartController.myCartItemModel!.data!.items![index].imageURL}"),
            ),
            const SizedBox(width: Dimensions.space16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(myCartController.myCartItemModel!.data!.items![index].itemName!, style: semiBoldLarge.copyWith(fontSize: 14), maxLines: 1),
                  const SizedBox(height: 4),
                  Text(
                    myCartController.myCartItemModel!.data!.items![index].categoryName!,
                    style: mediumDefault.copyWith(color: MyColor.naturalDark),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text("${myCartController.myCartItemModel!.data!.items![index].sellingCurrencyLogo!}${myCartController.myCartItemModel!.data!.items![index].sumOnlinePrice!}", style: semiBoldLarge.copyWith(fontSize: 14, color: MyColor.primaryColor)),
                      const SizedBox(
                        width: 8,
                      ),
                      Text("${myCartController.myCartItemModel!.data!.items![index].sumOnlinePriceBeforeDiscount!}", style: boldLarge.copyWith(fontSize: 12, decoration: TextDecoration.lineThrough, color: MyColor.bodyTextColor)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(6), border: Border.all(color: MyColor.naturalDark, width: .5)),
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                if (myCartController.myCartItemModel!.data!.items![index].qty! > 1) {
                                  myCartController.updateQtyItemCartApi(myCartController.myCartItemModel!.data!.items![index].idItem!.toInt(), index, -1);
                                }
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 4),
                                child: Icon(
                                  Icons.remove,
                                  color: myCartController.myCartItemModel!.data!.items![index].qty! > 1 ? MyColor.naturalDark : MyColor.trackOrderInactiveIconColor,
                                  size: 20,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: const BoxDecoration(border: Border.symmetric(vertical: BorderSide(color: MyColor.naturalDark))),
                              child: Text("${myCartController.myCartItemModel!.data!.items![index].qty}", style: mediumLarge.copyWith(color: MyColor.colorBlack)),
                            ),
                            GestureDetector(
                              onTap: () {
                                myCartController.updateQtyItemCartApi(myCartController.myCartItemModel!.data!.items![index].idItem!.toInt(), index, 1);
                              },
                              child: const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 4),
                                child: Icon(
                                  Icons.add,
                                  color: MyColor.naturalDark,
                                  size: 20,
                                ),
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
                  const WarningAlertDialog().warningAlertDialog(subtitleMessage: "You want to delete this item?", context, () {
                    myCartController.removeItemFromCartApi(myCartController.myCartItemModel!.data!.items![index].idItem!.toInt());
                    Get.back();
                  });
                },
                icon: SvgPicture.asset(MyImages.delete, width: 22, height: 22, colorFilter: const ColorFilter.mode(MyColor.primaryColor, BlendMode.srcIn))))
      ],
    );
  }

  Widget buildShimmerCartWidget() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Stack(
        children: [
          Row(
            children: [
              Container(
                width: context.width * .28,
                padding: const EdgeInsets.symmetric(horizontal: Dimensions.space8, vertical: 14),
                decoration: BoxDecoration(
                  color: MyColor.colorLightGrey,
                  borderRadius: BorderRadius.circular(Dimensions.space6),
                ),
                child: Image.asset(MyImages.appLogo),
              ),
              const SizedBox(width: Dimensions.space16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("", style: semiBoldLarge.copyWith(fontSize: 14), maxLines: 1),
                    const SizedBox(height: 4),
                    Text(
                      "",
                      style: mediumDefault.copyWith(color: MyColor.naturalDark),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text("", style: semiBoldLarge.copyWith(fontSize: 14, color: MyColor.primaryColor)),
                        const SizedBox(
                          width: 8,
                        ),
                        Text("", style: boldLarge.copyWith(fontSize: 12, decoration: TextDecoration.lineThrough, color: MyColor.bodyTextColor)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(6), border: Border.all(color: MyColor.naturalDark, width: .5)),
                          child: Row(
                            children: [
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 4),
                                child: Icon(
                                  Icons.remove,
                                  color: MyColor.trackOrderInactiveIconColor,
                                  size: 20,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: const BoxDecoration(border: Border.symmetric(vertical: BorderSide(color: MyColor.naturalDark))),
                                child: Text("", style: mediumLarge.copyWith(color: MyColor.colorBlack)),
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 4),
                                child: Icon(
                                  Icons.add,
                                  color: MyColor.naturalDark,
                                  size: 20,
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
                icon: SvgPicture.asset(MyImages.delete, width: 22, height: 22, colorFilter: const ColorFilter.mode(MyColor.primaryColor, BlendMode.srcIn)),
                onPressed: () {},
              ))
        ],
      ),
    );
  }

  @override
  void initState() {
    _scrollController.addListener(_onScroll);
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll); // Clean up listener
    _scrollController.dispose(); // Dispose of the controller
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.hasClients) {
      final double currentPosition = _scrollController.position.pixels;
      final double maxScrollExtent = _scrollController.position.maxScrollExtent;
      const double threshold = 100.0; // Trigger when 100px from the bottom

      // Check if we're near the bottom
      if (maxScrollExtent - currentPosition <= threshold) {
        print("Reached the bottom, loading more...");
        myCartController.loadMoreItem();
      }
    }
  }
}
