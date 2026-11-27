class User {
  final int id;
  final String name;
  final String email;
  final String role;
  final DateTime? email_verified_at;
  final DateTime? created_at;
  final DateTime? updated_at;

  User({
    required this.id,
    required this.name, 
    required this.email,
    required this.role,
    required this.email_verified_at,
    required this.created_at, 
    required this.updated_at
  });
}
