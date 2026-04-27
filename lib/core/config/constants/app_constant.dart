enum Environment { prod, staging, dev }

class AppConfig {
  static late Environment environment;
  static bool get enableIpConfig => environment != Environment.prod;
  static bool get isProduction => environment == Environment.prod;

  static void init({required Environment env}) {
    environment = env;
  }
}
