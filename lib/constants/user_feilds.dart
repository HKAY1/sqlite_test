class UserFeilds {
  static const String tableName = "users";
  static const String id = "id";
  static const String number = "phone_number";
  static const String otp = "otp";
  static const String idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
  static const String numberType = 'TEXT';
  static const String otpType = 'TEXT';
  static const List<String> values = [id, number, otp];
}
