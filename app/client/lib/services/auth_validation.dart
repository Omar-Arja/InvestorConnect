// AuthValidation class

class AuthValidation {
  static validateLogin(String email, String password) {
    if (email.isEmpty || password.isEmpty) {
      return 'Please fill in all fields';
    } else if (!email.contains('@') || !email.contains('.')) {
      return 'Please enter a valid email';
    }
    return null;
  }

  static validateSignup(
    String firstName,
    String lastName,
    String email,
    String password,
    String confirmPassword,
  ) {
    if (firstName.isEmpty ||
        lastName.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      return 'Please fill in all fields';
    } else if (!email.contains('@') || !email.contains('.')) {
      return 'Please enter a valid email address';
    } else if (password.length < 8) {
      return 'Password must be 8 + characters';
    } else if (password != confirmPassword) {
      return 'Passwords do not match';
    }
    return null;
  }
}
