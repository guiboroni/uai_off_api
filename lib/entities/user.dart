class User {
  final int? id;
  final String? email;
  final String? password;
  final String? iosToken;
  final String? androidToken;
  final String? refreshToken;
  final String? socialKey;
  final String? img;
  final int? storeId;

  User({
    this.id,
    this.email,
    this.password,
    this.iosToken,
    this.androidToken,
    this.refreshToken,
    this.socialKey,
    this.img,
    this.storeId,
  });

  User copyWith({
    int? id,
    String? email,
    String? password,
    String? iosToken,
    String? androidToken,
    String? refreshToken,
    String? socialKey,
    String? img,
    int? storeId,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      password: password ?? this.password,
      iosToken: iosToken ?? this.iosToken,
      androidToken: androidToken ?? this.androidToken,
      refreshToken: refreshToken ?? this.refreshToken,
      socialKey: socialKey ?? this.socialKey,
      img: img ?? this.img,
      storeId: storeId ?? this.storeId,
    );
  }
}
