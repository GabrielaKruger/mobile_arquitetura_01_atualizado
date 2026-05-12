class SessionManager {
  static Map<String, dynamic>? user;

  static bool get isLogged => user != null;

  static void saveUser(Map<String, dynamic> data) {
    user = data;
  }

  static void logout() {
    user = null;
  }
}