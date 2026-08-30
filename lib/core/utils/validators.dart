class Validators {
  // التحقق من البريد الإلكتروني
  static bool isValidEmail(String? email) {
    if (email == null || email.isEmpty) return false;
    final emailRegex = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$",
    );
    return emailRegex.hasMatch(email);
  }

  // التحقق من رقم الهاتف
  static bool isValidPhone(String? phone) {
    if (phone == null || phone.isEmpty) return false;
    final phoneRegex = RegExp(r'^[0-9]{7,15}$');
    return phoneRegex.hasMatch(phone);
  }

  // التحقق من كلمة المرور (8 أحرف على الأقل، رقم واحد، حرف كبير)
  static bool isValidPassword(String? password) {
    if (password == null || password.isEmpty) return false;
    final passwordRegex = RegExp(r'^(?=.*[A-Z])(?=.*\d)[A-Za-z\d@$!%*?&]{8,}$');
    return passwordRegex.hasMatch(password);
  }

  // التحقق من الحقول الفارغة
  static bool isNotEmpty(String? value) {
    return value != null && value.trim().isNotEmpty;
  }
}
