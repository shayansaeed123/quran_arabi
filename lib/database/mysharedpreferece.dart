import 'dart:core';

import 'package:get_storage/get_storage.dart';

class MySharedPrefrence {
  final GetStorage preferences = GetStorage();

  bool getUserLoginStatus() {
    return preferences.read('user_login_status') ?? false;
  }

  void setUserLoginStatus(bool? loginStatus) {
    preferences.write('user_login_status', loginStatus ?? false);
  }

  String getCatId() {
    return preferences.read('cat_id') ?? '';
  }

  void setCatId(String? catId) {
    preferences.write('cat_id', catId ?? '');
  }

  String getVersionCode() {
    return preferences.read('version_code') ?? '';
  }

  void setVersionCode(String? versionCode) {
    preferences.write('version_code', versionCode ?? '');
  }

  String getUserToken() {
    return preferences.read('user_token') ?? '';
  }

  void setUserToken(String? userToken) {
    preferences.write('user_token', userToken ?? '');
  }

  String getUserStatus1() {
    return preferences.read('status1') ?? '0';
  }

  void setUserStatus1(String? userStatus) {
    preferences.write('status1', userStatus ?? '0');
  }

  String getShopName() {
    return preferences.read('shop_name') ?? '';
  }

  void setShopName(String? shopName) {
    preferences.write('shop_name', shopName ?? '');
  }

  String get_user_email() {
    return preferences.read('user_email') ?? '';
  }

  void set_user_email(String? userEmail) {
    preferences.write('user_email', userEmail ?? '');
  }

  String getUserNumber() {
    return preferences.read('user_number') ?? '';
  }

  void setUserNumber(String? userNumber) {
    preferences.write('user_number', userNumber ?? '');
  }

  int get_user_id() {
    return int.tryParse(preferences.read('user_id') ?? '0') ?? 0;
  }

  void set_user_id(int userId) {
    preferences.write('user_id', userId.toString());
  }

  String getUserType() {
    return preferences.read('user_type') ?? '';
  }

  void setUserType(String? userType) {
    preferences.write('user_type', userType ?? '');
  }

  String getDeviceToken() {
    return preferences.read('device_token') ?? '';
  }

  void setDeviceToken(String? deviceToken) {
    preferences.write('device_token', deviceToken ?? '');
  }

  String getVersionName() {
    return preferences.read('versionName') ?? '';
  }

  void setUserCurrentLocation(String? userCurrentLocation) {
    preferences.write('user_current_location', userCurrentLocation ?? '');
  }

  String getUserCurrentLocation() {
    return preferences.read('user_current_location') ?? '';
  }

  void set_user_name(String? userName) {
    preferences.write('user_name', userName ?? '');
  }

  String get_user_name() {
    return preferences.read('user_name') ?? '';
  }

  void setUserCnic(String? userCnic) {
    preferences.write('user_cnic', userCnic ?? '');
  }

  String getUserCnic() {
    return preferences.read('user_cnic') ?? '';
  }

  void setUserDesignation(String? userDesignation) {
    preferences.write('user_designation', userDesignation ?? '');
  }

  String getUserDesignation() {
    return preferences.read('user_designation') ?? '';
  }

  String getUserImage() {
    return preferences.read('image') ?? '';
  }

  void setUserImage(String? userImage) {
    preferences.write('image', userImage ?? '');
  }

  int getUserCurrentAddressId() {
    return preferences.read('user_current_address_id') ?? 0;
  }

  void setUserCurrentAddressId(int? userCurrentAddressId) {
    preferences.write('user_current_address_id', userCurrentAddressId ?? 0);
  }

  int getUserLastAddressId() {
    return preferences.read('user_last_address_id') ?? 0;
  }

  void setUserLastAddressId(int? userLastAddressId) {
    preferences.write('user_last_address_id', userLastAddressId ?? 0);
  }

  String getUserCurrentLocationLatitude() {
    return preferences.read('user_current_location_latitude') ?? '';
  }

  void setUserCurrentLocationLatitude(String? latitude) {
    preferences.write('user_current_location_latitude', latitude ?? '');
  }

  String getUserCurrentLocationLongitude() {
    return preferences.read('user_current_location_longitude') ?? '';
  }

  void setUserCurrentLocationLongitude(String? longitude) {
    preferences.write('user_current_location_longitude', longitude ?? '');
  }

  void setDistributorName(String? distributorName) {
    preferences.write('distributor_name', distributorName ?? '');
  }

  String getDistributorName() {
    return preferences.read('distributor_name') ?? '';
  }

  void setStoreDistributorId(int? distributorId) {
    preferences.write('store_distributor_id', distributorId ?? 0);
  }

  int getStoreDistributorId() {
    return preferences.read('store_distributor_id') ?? 0;
  }

  void setUserCafeId(int? cafeId) {
    preferences.write('user_cafe_id', cafeId ?? 0);
  }

  int getUserCafeId() {
    return preferences.read('user_cafe_id') ?? 0;
  }

  void setUserCompanyId(String? companyId) {
    preferences.write('user_company_id', companyId ?? '');
  }

  String getUserCompanyId() {
    return preferences.read('user_company_id') ?? '';
  }

  void logout() {
    preferences.erase();
  }
}