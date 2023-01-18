class AppUser {
  String id;
  String name;
  String email;
  String bio;
  String gender;
  String image;
  String cover;
  bool isVerified;

  AppUser({
    this.id = '',
    this.name = '',
    this.email = '',
    this.image = '',
    this.gender = 'Male',
    this.bio = '',
    this.cover = '',
    this.isVerified = false,
  });

  factory AppUser.fromMap(Map<String, dynamic> userData) {
    return AppUser(
        id: userData['id'] ?? '',
        name: userData['name'] ?? '',
        email: userData['email'] ?? '',
        gender: userData['gender'] ?? 'Male',
        image: userData['image'] ?? '',
        cover: userData['cover']?? '',
        bio: userData['bio']?? '',
        isVerified: userData['isVerified']?? false
    );
  }

  Map<String, dynamic> userToMap(AppUser user, String imageUrl, String coverUrl) {
    return {
      'id': user.id,
      'name': user.name,
      'email': user.email,
      'image': imageUrl,
      'cover': coverUrl,
      'gender': user.gender,
      'bio': user.bio,
      'isVerified': user.isVerified
    };
  }
}
