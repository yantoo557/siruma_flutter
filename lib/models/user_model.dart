
class UserModel {
  final int id;
  final String nama;
  final String email;
  final int roleId;
  final String roleName;

  UserModel({
    required this.id,
    required this.nama,
    required this.email,
    required this.roleId,
    required this.roleName,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: int.parse(json['id'].toString()),
      nama: (json['nama'] ?? json['name'] ?? '').toString(),
      email: (json['email'] ?? '').toString(),
      roleId: int.parse(json['role_id'].toString()),
      roleName: (json['role'] ?? '').toString(),
    );
  }
}
