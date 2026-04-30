import 'package:injectable/injectable.dart';
import 'package:collab_task/core/config/constants/api_constant.dart';
import 'package:collab_task/core/network/api_helper.dart';
import 'package:collab_task/core/utils/safe_request_mapper.dart';
import 'package:collab_task/features/demo/data/models/demo_model.dart';

abstract class DemoRemoteDatasource {
  Future<List<DemoModel>> getDemos();
}

@LazySingleton(as: DemoRemoteDatasource)
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
