class AuthResponse {
  final bool success;
  final String? error;

  const AuthResponse({
    required this.success,
    required this.error,
  });
}
