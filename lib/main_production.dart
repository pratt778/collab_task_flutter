
import 'package:collab_task/main_common.dart';
import 'package:collab_task/core/config/constants/app_constant.dart';

void main() {
  AppConfig.init(env: Environment.prod);
  mainCommon();
}
