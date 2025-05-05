import 'package:ShapeCom/config/utils/my_constants.dart';
import 'package:ShapeCom/config/utils/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:ShapeCom/config/utils/dimensions.dart';
import 'package:ShapeCom/config/utils/my_color.dart';
import 'package:ShapeCom/config/utils/my_strings.dart';
import 'package:ShapeCom/domain/controller/home/home_controller.dart';
import 'package:ShapeCom/presentation/components/stataus_bar_color_widget.dart';
import 'package:ShapeCom/presentation/screens/bottom_nav_section/home/widget/gridview_product_widget.dart';
import 'package:ShapeCom/presentation/screens/bottom_nav_section/home/widget/home_screen_top_section.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../config/route/route.dart';
import '../../../../config/utils/my_images.dart';
import '../../../../config/utils/style.dart';
import '../../../../domain/controller/mens_fashion/mens_fashion_controller.dart';
import '../../mens_fashion/widget/custom_search_field.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final mensFashionController = Get.put(MensFashionController());
  final homeController = Get.put(HomeController());
  final FocusNode _searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    mensFashionController.loadCategory();
    // Add the scroll listener directly in initState
    _scrollController.addListener(_onScroll);
    _searchFocusNode.addListener(() {
      if (_searchFocusNode.hasFocus) {
        print("Search box got focus");
      } else {
        print("Search box lost focus");
        //if (homeController.searchController.text.toString().trim().isNotEmpty) {
        // call search get item api
        homeController.itemName = homeController.searchController.text.toString().trim();
        MyConstants.filtersApplied = true;
        homeController.applyFilters();
        //}
      }
    });
  }

  void _onScroll() {
    if (_scrollController.hasClients) {
      final double currentPosition = _scrollController.position.pixels;
      final double maxScrollExtent = _scrollController.position.maxScrollExtent;
      const double threshold = 100.0; // Trigger when 100px from the bottom

      // Check if we're near the bottom
      if (maxScrollExtent - currentPosition <= threshold) {
        print("Reached the bottom, loading more...");
        homeController.refreshItem();
      }
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll); // Clean up listener
    _scrollController.dispose(); // Dispose of the controller
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
        builder: (controller) => StatusBarColorWidget(
              color: MyColor.colorWhite,
              iconBrightness: Brightness.dark,
              child: Scaffold(
                backgroundColor: MyColor.colorLightGrey,
                key: scaffoldKey,
                body: SafeArea(
                  child: RefreshIndicator(
                    color: MyColor.primaryColor, // Color of the loading indicator
                    backgroundColor: Colors.white, // Background color of the refresh indicator
                    onRefresh: homeController.refreshItem,
                    child: Column(
                      children: [
                        const HomeScreenTopSection(),
                        const SizedBox(height: 10),
                        Expanded(
                          child: Container(
                            decoration: const BoxDecoration(color: MyColor.colorWhite, borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))),
                            child: SingleChildScrollView(
                              controller: _scrollController, // Attach ScrollController
                              child: Column(
                                children: [
                                  buildSearchBarSection(),
                                  const SizedBox(
                                    height: Dimensions.space8,
                                  ),
                                  Visibility(visible: MyConstants.filtersApplied, child: buildFilterSection()),
                                  homeController.isShimmerShow==false ? GridViewProductWidget(physics: const BouncingScrollPhysics(), productModelList: homeController.productModelList) : buildHomeScreenShimmer(),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ));
  }

  Widget buildSearchBarSection() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.space16, vertical: Dimensions.space8),
      color: MyColor.colorWhite,
      child: Row(
        children: [
          Expanded(
            child: CustomSearchField(
              controller: homeController.searchController,
              focusNode: _searchFocusNode,
              inputAction: TextInputAction.done, // shows "Done" on keyboard
              textInputType: TextInputType.name,
              hintText: "${MyStrings.searchIn} ${MyStrings.appName}",
              labelText: MyStrings.searchIn,
              onChanged: (value) {},
              prefixIcon: MyImages.search,
              animatedLabel: false,
              needOutlineBorder: true,
              isSearch: true,
              validator: (value) {
                if (value.isEmpty) {
                  return MyStrings.fieldErrorMsg;
                } else {
                  return null;
                }
              },
            ),
          ),
          const SizedBox(
            width: Dimensions.space12,
          ),
          InkWell(
              onTap: () {
                Get.toNamed(RouteHelper.filterScreen)!.then((result) {
                  homeController.applyFilters();
                });
              },
              child: SvgPicture.asset(MyImages.filter))
        ],
      ),
    );
  }

  Widget buildFilterSection() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.space17),
      color: MyColor.colorWhite,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "${homeController.filtersCount} items",
            style: mediumDefault.copyWith(color: MyColor.bodyTextColor),
          ),
          IconButton(
              padding: EdgeInsets.zero, // removes internal padding
              constraints: const BoxConstraints(), // removes default size constraints
              visualDensity: VisualDensity.compact, // optional: makes it even more compact
              onPressed: () {
                //reset filters
                homeController.resetFilters();
              },
              icon: const Icon(Icons.close, color: MyColor.bodyTextColor))
        ],
      ),
    );
  }

  Widget buildHomeScreenShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: GridView.builder(
        padding: const EdgeInsets.symmetric(horizontal: Dimensions.space2),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, mainAxisSpacing: 10, childAspectRatio: .74),
        itemCount: 10,
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
                        Column(
                          children: [
                            Container(
                                width: double.maxFinite,
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                margin: const EdgeInsets.all(2),
                                decoration: BoxDecoration(color: MyColor.colorLightGrey, borderRadius: BorderRadius.circular(10)),
                                child: const SizedBox(
                                  width: 110,
                                  height: 110,
                                )),
                            const SizedBox(
                              height: 18,
                            )
                          ],
                        ),
                        Positioned(
                            right: 10,
                            bottom: 0,
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(shape: BoxShape.circle, color: MyColor.primaryColor, border: Border.all(color: MyColor.colorWhite, width: 3)),
                              child: const Icon(
                                Icons.add,
                                size: 25,
                                color: MyColor.colorWhite,
                              ),
                            ))
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "",
                            style: mediumDefault.copyWith(color: MyColor.bodyTextColor),
                          ),
                          const Text(
                            "",
                            style: mediumLarge,
                            maxLines: 1,
                          ),
                          Text(
                            "",
                            style: mediumDefault.copyWith(color: MyColor.bodyTextColor),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Text(
                                "",
                                style: mediumLarge.copyWith(fontSize: 15),
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              Text(
                                "",
                                style: mediumDefault.copyWith(color: MyColor.canceledTextColor, decoration: TextDecoration.lineThrough),
                              ),
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
