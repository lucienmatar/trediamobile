import 'package:ShapeCom/config/utils/my_constants.dart';
import 'package:get/get.dart';

import '../../../config/network/api_service.dart';
import '../../../config/utils/my_preferences.dart';
import '../../../config/utils/my_strings.dart';
import '../../../presentation/components/snack_bar/show_custom_snackbar.dart';
import '../../../presentation/screens/auth/login/model/login_model.dart';
import '../../../presentation/screens/my_cart/model/cart_count_model.dart';
import '../../../presentation/screens/my_cart/model/get_item_model.dart';

class BottomNavBarController extends GetxController {
  bool isGuestLogin = true;
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    isGuestLogin = MyPrefrences.getBool(MyPrefrences.guestLogin) ?? true;
  }
}
