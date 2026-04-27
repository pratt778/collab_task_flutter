import 'package:flutter_clean_starter/core/config/constants/api_constant.dart';
import 'package:flutter_clean_starter/core/network/api_helper.dart';
import 'package:flutter_clean_starter/core/utils/safe_request_mapper.dart';
import 'package:flutter_clean_starter/features/demo/data/models/demo_model.dart';

abstract class DemoRemoteDatasource {
  Future<List<DemoModel>> getDemos();
}

class DemoRemoteDatasourceImpl implements DemoRemoteDatasource {
  final ApiHelper apiHelper;

  DemoRemoteDatasourceImpl({required this.apiHelper});

  @override
  Future<List<DemoModel>> getDemos() {
    return SafeRequest.call(() async {
      final response = await apiHelper.get(
        path: '${ApiConstants.baseUrl}/${ApiConstants.demos}',
      );
      final data = response.data as List<dynamic>;
      return data
          .map((e) => DemoModel.fromJson(e as Map<String, dynamic>))
          .toList();
    });
  }
}
