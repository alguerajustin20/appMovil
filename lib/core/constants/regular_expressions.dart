class CommonRegex {
  static final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
  static final passwordRegex = RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d@$!%*?&]{8,}$');
  static final numericOnlyRegex = RegExp(r'^[0-9]+$');
}
