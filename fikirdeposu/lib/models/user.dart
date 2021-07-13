class User {
  String uid;
  String firstName;
  String lastName;
  String email;
  String tel;
  String image;
  String bio;

  User(
      {this.uid,
      this.firstName,
      this.lastName,
      this.image,
      this.email,
      this.tel,
      this.bio});

  factory User.fromMap(Map<String, dynamic> data) {
    return User(
      uid: data["uid"],
      firstName: data["firstName"],
      lastName: data["lastName"],
      email: data["email"],
      image: data["image"],
      tel: data["tel"],
      bio: data["bio"],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'tel': tel,
      'image': image,
      'bio':bio,
    };
  }
}
