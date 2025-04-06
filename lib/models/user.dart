import 'package:pitstop_app/models/roles.dart';

class User {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String? phoneNumber;
  final Role role;
  final UserType userType;

  String get name => '$firstName $lastName';

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    this.phoneNumber,
    this.role = Role.CLIENT,
    this.userType = UserType.CLIENT,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phoneNumber'],
      role:
          json['role'] != null
              ? Role.values.firstWhere(
                (e) => e.toString().split('.').last == json['role'],
                orElse: () => Role.CLIENT,
              )
              : Role.CLIENT,
      userType:
          json['userType'] != null
              ? UserType.values.firstWhere(
                (e) => e.toString().split('.').last == json['role'],
                orElse: () => UserType.CLIENT,
              )
              : UserType.CLIENT,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'role': role.toString().split('.').last,
      'userType': userType.toString().split('.').last,
    };

    if (id.isNotEmpty) {
      data['_id'] = id;
    }

    if (phoneNumber != null) {
      data['phoneNumber'] = phoneNumber;
    }

    return data;
  }

  bool get isClient => userType == UserType.CLIENT;
}
