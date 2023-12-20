// profile.dart

class Book {
  final int id;
  final String title;
  final String imageLink;

  Book({
    required this.id,
    required this.title,
    required this.imageLink,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id'],
      title: json['title'],
      imageLink: json['image_link'],
    );
  }
}

class WishlistBook {
  final int id;
  final String title;
  final String imageLink;

  WishlistBook({
    required this.id,
    required this.title,
    required this.imageLink,
  });

  factory WishlistBook.fromJson(Map<String, dynamic> json) {
    return WishlistBook(
      id: json['id'],
      title: json['title'],
      imageLink: json['image_link'],
    );
  }
}
