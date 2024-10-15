// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class UserModel {
  final int? id;
  final String phoneNumber;
  final String otp;
  UserModel({
    this.id,
    required this.phoneNumber,
    required this.otp,
  });

  UserModel copyWith({
    int? id,
    String? phoneNumber,
    String? otp,
  }) {
    return UserModel(
      id: id ?? this.id,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      otp: otp ?? this.otp,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'phone_number': phoneNumber,
      'otp': otp,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] != null ? map['id'] as int : null,
      phoneNumber: map['phone_number'] as String,
      otp: map['otp'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'UserModel(id: $id, phoneNumber: $phoneNumber, otp: $otp)';

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.phoneNumber == phoneNumber &&
        other.otp == otp;
  }

  @override
  int get hashCode => id.hashCode ^ phoneNumber.hashCode ^ otp.hashCode;
}
