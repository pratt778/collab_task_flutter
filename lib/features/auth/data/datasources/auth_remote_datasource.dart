import 'package:flutter/cupertino.dart';
import 'package:flutter_clean_starter/core/config/constants/api_constant.dart';
import 'package:flutter_clean_starter/core/network/api_helper.dart';
import 'package:flutter_clean_starter/core/utils/safe_request_mapper.dart';
import 'package:flutter_clean_starter/features/auth/data/models/login_response_model.dart';

abstract class AuthRemoteDatasource {
  Future<LoginResponseModel> login({
    required String phoneNumber,
    required String customerNo,
    required String organizationCode,
  });
  Future<void> logout();
}

class AuthRemoteDatasourceImpl implements AuthRemoteDatasource {
  final ApiHelper apiHelper;
  AuthRemoteDatasourceImpl({required this.apiHelper});
  @override
  Future<LoginResponseModel> login({
    required String phoneNumber,
    required String customerNo,
    required String organizationCode,
  }) {
    return SafeRequest.call(() async {
      debugPrint(
        'organizationCode: $organizationCode, customerNo: $customerNo, phoneNumber: $phoneNumber',
      );
      final response = await apiHelper.post(
        path: '${ApiConstants.baseUrl}/${ApiConstants.login}',
        body: {
          'contact_number': phoneNumber,
          'customer_no': customerNo,
          'organization_code': organizationCode,
        },
      );
      final loginResponseModel = LoginResponseModel.fromJson(
        response.data['data'],
      );
      return loginResponseModel;
    });
  }

  @override
  Future<void> logout() {
    return SafeRequest.call(() async {
      await apiHelper.post(
        path: '${ApiConstants.baseUrl}/${ApiConstants.logout}',
        body: {},
      );
    });
  }
}
