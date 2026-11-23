
class ApiConfig {
  static const String baseUrl =
      'http://10.187.155.202:8000/api';

  // Authentication
  static const String login = '$baseUrl/login';
  static const String user = '$baseUrl/user';
  static const String logout = '$baseUrl/logout';

  // Super Admin - Perumahan
  static const String perumahan = '$baseUrl/perumahan';

  static String detailPerumahan(int id) =>
      '$perumahan/$id';

  static String blokPerumahan(int id) =>
      '$perumahan/$id/blok';

  static String unitBlok(int id) =>
      '$baseUrl/blok/$id/unit';
}
