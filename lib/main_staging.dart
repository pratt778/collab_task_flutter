
import 'package:flutter_clean_starter/main_common.dart';
import 'package:flutter_clean_starter/core/config/constants/app_constant.dart';

void main() {
  AppConfig.init(env: Environment.staging);
  mainCommon();
}
