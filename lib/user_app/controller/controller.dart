import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:placement_task/user_app/modal/modal.dart';
import 'package:placement_task/user_app/services/api_service.dart';

class CustomerController extends GetxController {
  ApiUserService apiHelper = ApiUserService();
  List<CustomerModal> customerList =<CustomerModal> [].obs;
  RxBool isToggle = false.obs;
  RxBool isDarkTheme = false.obs;

  Future<List> fetchData() async {
    final user = await apiHelper.fetchApiData();
    customerList = user
        .map(
          (e) => CustomerModal.fromMap(e),
        )
        .toList();
    return customerList;
  }

  CustomerController() {
    fetchData();
  }
}
