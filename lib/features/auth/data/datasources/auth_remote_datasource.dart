import 'package:flutter/cupertino.dart';
import 'package:injectable/injectable.dart';
import 'package:collab_task/core/config/constants/api_constant.dart';
import 'package:collab_task/core/network/api_helper.dart';
import 'package:collab_task/core/utils/safe_request_mapper.dart';
import 'package:collab_task/features/auth/data/models/login_response_model.dart';

abstract class AuthRemoteDatasource {
  Future<LoginResponseModel> login({
    required String phoneNumber,
    required String customerNo,
    required String organizationCode,
  });
  Future<void> logout();
}

@LazySingleton(as: AuthRemoteDatasource)
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
