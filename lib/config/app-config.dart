
enum Environment{
  PREPROD,
  PROD
}


class AppConfig{
  final String appName;
  final Environment environment;

  AppConfig({required this.appName, required this.environment});
}