import 'package:ShapeCom/config/utils/dimensions.dart';
import 'package:ShapeCom/domain/controller/cart_controller/cartController.dart';
import 'package:ShapeCom/domain/controller/track_order/track_order_controller.dart';
import 'package:ShapeCom/presentation/screens/track_order/widget/time_line_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../config/utils/my_images.dart';
import '../../../config/utils/my_strings.dart';
import '../../components/app-bar/custom_appbar.dart';

class TrackOrderScreen extends StatefulWidget {
  const TrackOrderScreen({
    super.key,
  });

  @override
  State<TrackOrderScreen> createState() => _TrackOrderScreenState();
}

class _TrackOrderScreenState extends State<TrackOrderScreen> {
  @override
  void initState() {
    Get.put(CartCountController());
    final controller = Get.put(TrackOrderController());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: MyStrings.trackOrder,
        leadingImage: MyImages.backButton,
      ),
      body: SingleChildScrollView(
        padding: Dimensions.trackOrderPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TimeLineWidget(isActive: true, title: MyStrings.confirmed, bodyText: MyStrings.confirmedBodyText, svgImage: MyImages.trackOrderConfirmed),
            TimeLineWidget(isActive: false, title: MyStrings.inProcessing, svgImage: MyImages.processing),
            TimeLineWidget(
              isActive: false,
              svgImage: MyImages.dispatched,
              title: MyStrings.dispatched,
            ),
            TimeLineWidget(
              isActive: false,
              endTrack: true,
              svgImage: MyImages.delivery,
              title: MyStrings.delivered,
            )
          ],
        ),
      ),
    );
  }
}
