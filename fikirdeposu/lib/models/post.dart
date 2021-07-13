class Post {
  final String userUid;
  final String title;
  final String content;
  final String type;
  final String datetime;
  final String image;
  final String firstName;
  final String lastName;
  final String email;
  final double price;
  final List<String> keywords;
  final List<String> favorites;

  Post(
      {this.userUid,
      this.title,
      this.content,
      this.type,
      this.datetime,
      this.image,
      this.price,
      this.favorites,
      this.keywords,
      this.firstName,
      this.lastName,
      this.email});

  factory Post.fromMap(Map<String, dynamic> data) {
    return Post(
      userUid: data["userUid"],
      title: data["title"],
      content: data["content"],
      price: data["price"],
      type: data["type"],
      datetime: data["datetime"],
      image: data["image"],
      keywords: List<String>.from(data["keywords"]),
      favorites: List<String>.from(data["favorites"]),
      firstName: data["firstName"],
      lastName: data["lastName"],
      email: data["email"],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "userUid": userUid,
      "title": title,
      "content": content,
      "type": type,
      "price": price,
      "keywords": keywords,
      "favorites": favorites,
      "datetime": datetime,
      "image": image,
      "firstName": firstName,
      "lastName": lastName,
      "email": email,
    };
  }
}
