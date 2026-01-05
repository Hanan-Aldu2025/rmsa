class UserEntity {
  final String name;
  final String email;
  final String uId;
  final String phoneNumber;
  final bool emailVerified;

  const UserEntity({
    required this.phoneNumber,
    required this.name,
    required this.email,
    required this.uId,
    required this.emailVerified,
  });
}
