import 'package:ShapeCom/config/utils/my_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:ShapeCom/config/utils/my_strings.dart';
import 'package:ShapeCom/domain/controller/wish_list/wish_list_controller.dart';
import 'package:ShapeCom/presentation/components/app-bar/custom_appbar_mab.dart';
import 'package:ShapeCom/presentation/screens/wish_list/widget/wish_list_cart_widget.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import '../../../config/route/route.dart';
import '../../../config/utils/dimensions.dart';
import '../../../config/utils/my_color.dart';
import '../../../config/utils/my_images.dart';
import '../../../config/utils/style.dart';
import '../../../domain/product/my_product.dart';
import '../my_cart/widget/slide_menu.dart';

class WishListScreen extends StatefulWidget {
  const WishListScreen({super.key});

  @override
  State<WishListScreen> createState() => _WishListScreenState();
}

class _WishListScreenState extends State<WishListScreen> {
  final wishListController = Get.put(WishListController());
  final ScrollController _scrollController = ScrollController();
  bool isReFresh = false;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<WishListController>(
      builder: (controller) => Scaffold(
        appBar: CustomAppBarWithMAB(
          title: MyStrings.wishList,
          isShowBackBtn: true,
          leadingImage: MyImages.backButton,
          actionImage1: MyImages.search,
          actionImage2: MyImages.card,
          actionPress2: () {
            if (wishListController.isGuestLogin) {
              showGuestLoginDialog();
            } else {
              Get.toNamed(RouteHelper.myCartScreen)!.then((result) {
                print("object received");
                setState(() {
                  isReFresh = true;
                });
              });
            }
          },
        ),
        body: RefreshIndicator(
          color: MyColor.primaryColor,
          backgroundColor: Colors.white,
          onRefresh: wishListController.refreshItem,
          child: wishListController.isShimmerShow
              ? ListView(
                  controller: _scrollController,
                  children: List.generate(10, (index) {
                    return Column(
                      children: [
                        SlideMenu(
                          swipeContentWidth: 0.3,
                          menuItems: [
                            GestureDetector(
                                onTap: () {},
                                child: SvgPicture.asset(
                                  MyImages.delete,
                                  width: Dimensions.space20,
                                )),
                            GestureDetector(
                                onTap: () {},
                                child: SvgPicture.asset(
                                  MyImages.card,
                                  width: Dimensions.space20,
                                  colorFilter: const ColorFilter.mode(MyColor.primaryColor, BlendMode.srcIn),
                                )),
                            GestureDetector(
                                onTap: () {},
                                child: SvgPicture.asset(
                                  MyImages.comparison,
                                  width: Dimensions.space20,
                                  colorFilter: const ColorFilter.mode(MyColor.iconColor, BlendMode.srcIn),
                                )),
                          ],
                          child: Container(
                            color: MyColor.colorWhite,
                            child: ListTile(
                              contentPadding: Dimensions.lisTilePaddingHV,
                              title: buildShimmerWishlist(),
                            ),
                          ),
                        ),
                        Container(
                          height: 1,
                          width: double.maxFinite,
                          color: MyColor.colorLightGrey,
                        ),
                      ],
                    );
                  }),
                )
              : wishListController.favoriteItemCount > 0
                  ? ListView(
                      controller: _scrollController,
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: List.generate(wishListController.favoriteItemCount, (index) {
                        return Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                ProductModel productModel = ProductModel(
                                  image: "${MyConstants.imageBaseURL}${wishListController.favoriteItemModel!.data!.items![index].imageURL}",
                                  brand: wishListController.favoriteItemModel!.data!.items![index].categoryName!,
                                  title: wishListController.favoriteItemModel!.data!.items![index].itemName!,
                                  description: "",
                                  onlinePriceBeforeDiscount: wishListController.favoriteItemModel!.data!.items![index].onlinePriceBeforeDiscount!.toDouble(),
                                  price: wishListController.favoriteItemModel!.data!.items![index].onlinePrice!.toDouble(),
                                  sellingCurrencyLogo: wishListController.favoriteItemModel!.data!.items![index].sellingCurrencyLogo!,
                                  productID: wishListController.favoriteItemModel!.data!.items![index].idItem!.toInt(),
                                );
                                Future.delayed(const Duration(milliseconds: 100), () {
                                  Get.toNamed(RouteHelper.productDetailsScreen2, arguments: productModel);
                                });
                              },
                              child: SlideMenu(
                                swipeContentWidth: 0.3,
                                menuItems: [
                                  GestureDetector(
                                      onTap: () {},
                                      child: SvgPicture.asset(
                                        MyImages.card,
                                        width: Dimensions.space20,
                                        colorFilter: const ColorFilter.mode(MyColor.primaryColor, BlendMode.srcIn),
                                      )),
                                ],
                                child: Container(
                                  color: MyColor.colorWhite,
                                  child: ListTile(
                                    contentPadding: Dimensions.lisTilePaddingHV,
                                    title: buildWishlist(index),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              height: 1,
                              width: double.maxFinite,
                              color: MyColor.colorLightGrey,
                            ),
                          ],
                        );
                      }),
                    )
                  : SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height - kToolbarHeight - MediaQuery.of(context).padding.top, // Adjust for app bar and status bar
                        child: Center(
                          child: Text(
                            wishListController.noDataFound ?? MyStrings.noRecordsFound,
                            style: semiBoldLarge.copyWith(fontSize: 14),
                            maxLines: 1,
                          ),
                        ),
                      ),
                    ),
        ),
      ),
    );
  }

  Widget buildWishlist(int index) {
    return Stack(
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
              child: Image.network("${MyConstants.imageBaseURL}${wishListController.favoriteItemModel!.data!.items![index].imageURL!}"),
            ),
            const SizedBox(width: Dimensions.space16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(wishListController.favoriteItemModel!.data!.items![index].itemName!, style: semiBoldLarge, maxLines: 1),
                  const SizedBox(height: 4),
                  Text(wishListController.favoriteItemModel!.data!.items![index].categoryName!, style: mediumDefault.copyWith(color: MyColor.naturalDark)),
                  //const CustomRatingWidget(size: 13),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        '${wishListController.favoriteItemModel!.data!.items![index].sellingCurrencyLogo}'
                        '${NumberFormat.currency(locale: 'en_GB', symbol: '', decimalDigits: wishListController.favoriteItemModel!.data!.items![index].sellingCurrencyLogo != '\$' && wishListController.favoriteItemModel!.data!.items![index].sellingCurrencyLogo != '€' ? 0 : 2).format(wishListController.favoriteItemModel!.data!.items![index].onlinePrice)}',
                        style: boldLarge,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        '${wishListController.favoriteItemModel!.data!.items![index].sellingCurrencyLogo}'
                        '${NumberFormat.currency(locale: 'en_GB', symbol: '', decimalDigits: wishListController.favoriteItemModel!.data!.items![index].sellingCurrencyLogo != '\$' && wishListController.favoriteItemModel!.data!.items![index].sellingCurrencyLogo != '€' ? 0 : 2).format(wishListController.favoriteItemModel!.data!.items![index].onlinePriceBeforeDiscount)}',
                        style: boldLarge.copyWith(
                          fontSize: 12,
                          decoration: TextDecoration.lineThrough,
                          color: MyColor.bodyTextColor,
                        ),
                      ),
                    ],
                  ),
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
                  wishListController.toggleFavorite(wishListController.favoriteItemModel!.data!.items![index].idItem!.toInt());
                },
                icon: SvgPicture.asset(MyImages.wishList, width: 18, height: 18, colorFilter: const ColorFilter.mode(MyColor.primaryColor, BlendMode.srcIn))))
      ],
    );
  }

  Widget buildShimmerWishlist() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Stack(
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
                child: Image.asset(MyImages.appLogo, width: 50, height: 50, fit: BoxFit.cover),
              ),
              const SizedBox(width: Dimensions.space16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("", style: semiBoldLarge, maxLines: 1),
                    const SizedBox(height: 4),
                    Text("", style: mediumDefault.copyWith(color: MyColor.naturalDark)),
                    //const CustomRatingWidget(size: 13),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Text("", style: boldLarge),
                        const SizedBox(width: 10),
                        Text("", style: boldLarge.copyWith(fontSize: 12, decoration: TextDecoration.lineThrough, color: MyColor.bodyTextColor)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          Positioned(right: 0, bottom: 0, child: IconButton(onPressed: () {}, icon: SvgPicture.asset(MyImages.wishListOutline, width: 18, height: 18, colorFilter: const ColorFilter.mode(MyColor.primaryColor, BlendMode.srcIn))))
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
        wishListController.loadMoreItem();
      }
    }
  }

  showGuestLoginDialog() {
    Get.defaultDialog(
      title: MyStrings.guestLogin,
      titleStyle: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
      middleText: MyStrings.guestLogin2,
      middleTextStyle: const TextStyle(
        fontSize: 14,
        color: Colors.black87,
      ),
      barrierDismissible: false, // Prevent dismissing by tapping outside
      radius: 10, // Rounded corners
      actions: [
        TextButton(
          onPressed: () {
            Get.back(); // Close dialog
            Get.toNamed(RouteHelper.loginScreen, arguments: "guest");
          },
          child: Text(
            MyStrings.signInSignup,
            style: TextStyle(
              color: MyColor.primaryColor,
              fontSize: 14,
            ),
          ),
        ),
        TextButton(
          onPressed: () {
            Get.back(); // Close dialog
          },
          child: Text(
            MyStrings.close,
            style: TextStyle(
              color: MyColor.colorGrey,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
