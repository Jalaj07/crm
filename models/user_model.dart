class UserModel {
  final String token;
  final int userId;
  final String name;
  final int companyId;
  final String companyName;

  UserModel({
    required this.token,
    required this.userId,
    required this.name,
    required this.companyId,
    required this.companyName,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      token: json['token'],
      userId: json['user_id'],
      name: json['name'],
      companyId: json['company_id'][0]['id'],
      companyName: json['company_id'][0]['name'],
    );
  }
}
