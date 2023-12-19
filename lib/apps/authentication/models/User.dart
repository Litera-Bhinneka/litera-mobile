// Class untuk menampilkan kerangka User
class User {
  String username = "";
  bool isGuest = true;
  User(this.username);
}

// Variabel data untuk menyimpan User loggedin
class UserLoggedIn {
  static User user = User("");
}