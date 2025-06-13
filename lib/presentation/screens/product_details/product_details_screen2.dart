import 'package:ShapeCom/config/utils/my_color.dart';
import 'package:ShapeCom/config/utils/my_constants.dart';
import 'package:ShapeCom/config/utils/style.dart';
import 'package:ShapeCom/domain/controller/cart_controller/cartController.dart';
import 'package:ShapeCom/domain/controller/product_details/product_details_controller.dart';
import 'package:ShapeCom/presentation/components/app-bar/custom_appbar.dart';
import 'package:badges/badges.dart' as badges;
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../config/route/route.dart';
import '../../../config/utils/dimensions.dart';
import '../../../config/utils/my_images.dart';
import '../../../config/utils/my_strings.dart';
import '../../../domain/product/my_product.dart';
import '../../components/custom_read_more.dart';
import '../bottom_nav_section/home/widget/custom_product_section.dart';

class ProductDetailsScreen2 extends StatefulWidget {
  const ProductDetailsScreen2({super.key});

  @override
  State<ProductDetailsScreen2> createState() => _ProductDetailsScreen2State();
}

class _ProductDetailsScreen2State extends State<ProductDetailsScreen2> {
  late ProductModel productModel;
  late ProductDetailsController productDetailsController;

  @override
  void initState() {
    super.initState();
    productModel = Get.arguments as ProductModel;
    productDetailsController = Get.put(ProductDetailsController(productModel.productID), tag: productModel.productID.toString());
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProductDetailsController>(
      tag: productModel.productID.toString(),
      builder: (controller) => Scaffold(
        appBar: const CustomAppBar(
          title: MyStrings.productDetails,
          leadingImage: MyImages.backButton,
        ),
        body: productDetailsController.isLoading!
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        children: [
                          Stack(
                            children: [
                              Container(
                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: MyColor.primaryColor.withOpacity(.07)),
                                child: Column(
                                  children: [
                                    CarouselSlider(
                                      items: productDetailsController.getItemDetailsModel!.data!.media!.map((e) => Image.network("${MyConstants.imageBaseURL}${e.thumbnailURL}")).toList(),
                                      options: CarouselOptions(
                                        aspectRatio: 1,
                                        autoPlay: true,
                                        autoPlayInterval: const Duration(seconds: 2),
                                        viewportFraction: 1.0,
                                        height: context.height * .38,
                                        enableInfiniteScroll: true,
                                        onPageChanged: (index, reason) {
                                          controller.setCurrentIndex(index);
                                        },
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: List.generate(
                                          3,
                                          (index) => Container(
                                                padding: const EdgeInsets.symmetric(vertical: Dimensions.space8),
                                                margin: const EdgeInsets.only(right: Dimensions.space10),
                                                width: controller.currentIndex == index ? 20 : 10,
                                                height: 8,
                                                decoration: BoxDecoration(
                                                  color: controller.currentIndex == index ? MyColor.primaryColor : MyColor.bodyTextColor,
                                                  borderRadius: BorderRadius.circular(Dimensions.cardRadius),
                                                ),
                                              )),
                                    ),
                                    const SizedBox(height: 10)
                                  ],
                                ),
                              ),
                              Positioned(
                                  top: 10,
                                  right: 10,
                                  child: GestureDetector(
                                    onTap: () {
                                      productDetailsController.toggleFavorite(productModel.productID);
                                    },
                                    child: Container(
                                      height: 40,
                                      width: 40,
                                      padding: const EdgeInsets.all(10),
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: MyColor.colorWhite,
                                      ),
                                      child: SvgPicture.asset(
                                        productDetailsController.getItemDetailsModel!.data!.item!.isFavorite! ? MyImages.wishList : MyImages.wishListOutline,
                                        colorFilter: const ColorFilter.mode(MyColor.primaryColor, BlendMode.srcIn),
                                      ),
                                    ),
                                  ))
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                flex: 6,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      productDetailsController.getItemDetailsModel!.data!.item!.itemName!,
                                      style: boldLarge,
                                      maxLines: 1,
                                    ),
                                    Text(
                                      productDetailsController.getItemDetailsModel!.data!.item!.categoryName!,
                                      style: regularLarge.copyWith(color: MyColor.naturalDark),
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    //const CustomRatingWidget()
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 4,
                                child: Column(
                                  children: [
                                    Text(
                                      "${productModel.sellingCurrencyLogo}${productModel.onlinePriceBeforeDiscount}",
                                      style: boldLarge.copyWith(
                                        decoration: TextDecoration.lineThrough,
                                        color: MyColor.canceledTextColor,
                                      ),
                                    ),
                                    Text(
                                      "${productModel.sellingCurrencyLogo}${productModel.price}",
                                      style: mediumOverLarge,
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Align(alignment: Alignment.topLeft, child: CustomReadMoreText('${productDetailsController.getItemDetailsModel!.data!.item!.onlineDetails ?? ''} ', trimLines: 4, colorClickableText: MyColor.primaryColor, trimMode: TrimMode.Line, trimCollapsedText: MyStrings.seeMore, trimExpandedText: MyStrings.seeLess, moreStyle: regularLarge.copyWith(color: MyColor.primaryColor, fontWeight: FontWeight.w600), lessStyle: regularLarge.copyWith(color: MyColor.colorGreen, fontWeight: FontWeight.w600), style: regularLarge.copyWith(color: MyColor.bodyTextColor))),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              /*Row(
                                children: [
                                  const Text(
                                    MyStrings.color,
                                    style: mediumLarge,
                                  ),
                                  const SizedBox(
                                    width: 15,
                                  ),
                                  Row(
                                    children: List.generate(
                                      3,
                                      (index) {
                                        return GestureDetector(
                                          onTap: () {
                                            controller.setSelectedColor(index);
                                          },
                                          child: Container(
                                            height: 25,
                                            width: 25,
                                            margin: const EdgeInsets.only(right: 6),
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: controller.selectColorIndex == index ? MyColor.naturalLight.withOpacity(.4) : Colors.transparent,
                                            ),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Container(
                                                  padding: const EdgeInsets.all(9),
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: controller.productColor[index],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  )
                                ],
                              ),*/
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      controller.decreaseQuantity();
                                    },
                                    child: Container(
                                      width: 30,
                                      height: 30,
                                      decoration: BoxDecoration(shape: BoxShape.circle, color: MyColor.bodyTextColor, border: Border.all(color: MyColor.colorWhite, width: 3)),
                                      child: const Icon(
                                        Icons.remove,
                                        size: 14,
                                        color: MyColor.colorWhite,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 6),
                                    child: Text(
                                      "${controller.quantity}",
                                      style: mediumLarge.copyWith(color: MyColor.bodyTextColor),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      controller.increaseQuantity();
                                    },
                                    child: Container(
                                      width: 30,
                                      height: 30,
                                      decoration: BoxDecoration(shape: BoxShape.circle, color: MyColor.bodyTextColor, border: Border.all(color: MyColor.colorWhite, width: 3)),
                                      child: const Icon(
                                        Icons.add,
                                        size: 14,
                                        color: MyColor.colorWhite,
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    productDetailsController.relatedItemsCount > 0 ? buildRelatedProductList() : const Offstage(),
                    /* CustomProductSection(
                      productList: MyProduct.shoeList.reversed.toList(),
                      controller: Get.find(),
                      productType: MyStrings.relatedProduct,
                    )*/
                  ],
                ),
              ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          child: Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: ElevatedButton(
                    onPressed: () {
                      productDetailsController.addItemToCartApi();
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: MyColor.primaryColor, shadowColor: MyColor.transparentColor, padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16), textStyle: const TextStyle(color: MyColor.colorWhite, fontSize: 14, fontWeight: FontWeight.w500)),
                    child: Text(
                      MyStrings.addToCart,
                      style: const TextStyle(color: MyColor.colorWhite),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              GestureDetector(
                  onTap: () {
                    Get.toNamed(RouteHelper.myCartScreen);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(13),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: MyColor.primaryColor.withOpacity(.2),
                    ),
                    child: GetBuilder<CartCountController>(
                      builder: (controller) => badges.Badge(
                        showBadge: controller.cartCount > 0,
                        badgeStyle: const badges.BadgeStyle(
                          shape: badges.BadgeShape.circle,
                          badgeColor: MyColor.inProgressTextColor,
                          padding: EdgeInsets.all(5),
                          elevation: 0,
                        ),
                        badgeContent: Text(
                          controller.cartCount.toString(),
                          style: regularSmall.copyWith(fontSize: 8, color: MyColor.colorWhite),
                        ),
                        child: SvgPicture.asset(MyImages.cart),
                      ),
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildRelatedProductList() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(Dimensions.space16, Dimensions.space13, Dimensions.space14, Dimensions.space13),
          child: Row(
            children: [
              Text(MyStrings.relatedProduct, style: boldLarge.copyWith(fontSize: 18)),
              const Spacer(),
            ],
          ),
        ),
        SingleChildScrollView(
          padding: const EdgeInsets.only(left: Dimensions.space10),
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: List.generate(productDetailsController.relatedItemsCount, (index) {
              return GestureDetector(
                onTap: () {
                  ProductModel productModel = ProductModel(
                    image: "${MyConstants.imageBaseURL}${productDetailsController.getRelatedItemsModel!.data!.items![index].imageURL}",
                    brand: productDetailsController.getRelatedItemsModel!.data!.items![index].categoryName!,
                    title: productDetailsController.getRelatedItemsModel!.data!.items![index].itemName!,
                    description: productDetailsController.getRelatedItemsModel!.data!.items![index].onlineDetails!,
                    onlinePriceBeforeDiscount: productDetailsController.getRelatedItemsModel!.data!.items![index].onlinePriceBeforeDiscount!.toDouble(),
                    price: productDetailsController.getRelatedItemsModel!.data!.items![index].onlinePrice!.toDouble(),
                    sellingCurrencyLogo: productDetailsController.getRelatedItemsModel!.data!.items![index].sellingCurrencyLogo!,
                    productID: productDetailsController.getRelatedItemsModel!.data!.items![index].idItem!.toInt(),
                  );
                  Future.delayed(const Duration(milliseconds: 100), () {
                    Get.toNamed(RouteHelper.productDetailsScreen2, arguments: productModel, preventDuplicates: false);
                  });
                },
                child: Container(
                  width: context.width * .4,
                  margin: const EdgeInsets.symmetric(horizontal: Dimensions.space8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(Dimensions.space10),
                        width: context.width * .4,
                        decoration: BoxDecoration(
                          color: MyColor.colorLightGrey,
                          borderRadius: BorderRadius.circular(Dimensions.space7),
                        ),
                        child: Image.network(
                          fit: BoxFit.cover,
                          "${MyConstants.imageBaseURL}${productDetailsController.getRelatedItemsModel!.data!.items![index].imageURL}",
                          width: 110,
                          height: 115,
                        ),
                      ),
                      const SizedBox(height: Dimensions.space10),
                      Text(
                        productDetailsController.getRelatedItemsModel!.data!.items![index].categoryName!,
                        style: mediumDefault.copyWith(color: MyColor.bodyTextColor),
                      ),
                      const SizedBox(height: 4),
                      SizedBox(
                        height: 20, // Reserve fixed height for itemName
                        width: context.width * .4,
                        child: Text(
                          productDetailsController.getRelatedItemsModel!.data!.items![index].itemName!,
                          style: boldLarge.copyWith(color: MyColor.colorBlack, fontSize: 14),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(height: 4),
                      SizedBox(
                        height: 34, // Reserve fixed height for description (2 lines)
                        width: context.width * .4,
                        child: Text(
                          productDetailsController.getRelatedItemsModel!.data!.items![index].onlineDetails!,
                          style: mediumDefault.copyWith(color: MyColor.bodyTextColor),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            "${productDetailsController.getRelatedItemsModel!.data!.items![index].sellingCurrencyLogo}${productDetailsController.getRelatedItemsModel!.data!.items![index].onlinePrice}",
                            style: boldLarge,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            "${productDetailsController.getRelatedItemsModel!.data!.items![index].sellingCurrencyLogo}${productDetailsController.getRelatedItemsModel!.data!.items![index].onlinePriceBeforeDiscount}",
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
              );
            }),
          ),
        ),
        const SizedBox(height: Dimensions.space30),
      ],
    );
  }
}
