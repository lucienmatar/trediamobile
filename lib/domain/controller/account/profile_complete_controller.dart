import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ShapeCom/config/utils/my_strings.dart';
import 'package:ShapeCom/presentation/components/snack_bar/show_custom_snackbar.dart';



class ProfileCompleteController extends GetxController {

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController  = TextEditingController();
  TextEditingController emailController     = TextEditingController();
  TextEditingController mobileNoController  = TextEditingController();
  TextEditingController addressController   = TextEditingController();
  TextEditingController stateController     = TextEditingController();
  TextEditingController zipCodeController   = TextEditingController();
  TextEditingController cityController      = TextEditingController();


  FocusNode firstNameFocusNode = FocusNode();
  FocusNode lastNameFocusNode  = FocusNode();
  FocusNode emailFocusNode     = FocusNode();
  FocusNode mobileNoFocusNode  = FocusNode();
  FocusNode addressFocusNode   = FocusNode();
  FocusNode stateFocusNode     = FocusNode();
  FocusNode zipCodeFocusNode   = FocusNode();
  FocusNode cityFocusNode      = FocusNode();
  FocusNode countryFocusNode   = FocusNode();


  bool isLoading     = false;
  bool submitLoading = false;

  updateProfile()async{

    String firstName = firstNameController.text;
    String lastName  = lastNameController.text.toString();
    String address   = addressController.text.toString();
    String city      = cityController.text.toString();
    String zip       = zipCodeController.text.toString();
    String state     = stateController.text.toString();


    if(firstName.isEmpty){
      CustomSnackBar.error(errorList: [MyStrings.kFirstNameNullError]);
      return;
    }else if(lastName.isEmpty){
      CustomSnackBar.error(errorList: [MyStrings.kLastNameNullError]);
      return;
    }

    submitLoading=true;
    update();

    submitLoading=false;
    update();

  }

}
