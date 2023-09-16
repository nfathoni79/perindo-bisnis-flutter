class UserToken {
  const UserToken({
    required this.accessToken,
    required this.refreshToken,
  });

  factory UserToken.fromJson(Map<String, dynamic> json) {
    return UserToken(
      accessToken: json['access_token'],
      refreshToken: json['refresh_token'],
    );
  }

  final String accessToken;
  final String refreshToken;
}
