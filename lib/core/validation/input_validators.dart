class InputValidators {
  const InputValidators._();

  static String? validateName(String value) {
    if (value.trim().isEmpty) {
      return 'Name is required.';
    }
    final hasDigit = RegExp(r'\d').hasMatch(value);
    if (hasDigit) {
      return 'Name must not contain numbers.';
    }
    return null;
  }

  static String? validateEmail(String value) {
    final trimmedValue = value.trim();
    if (trimmedValue.isEmpty) {
      return 'Email is required.';
    }
    if (!trimmedValue.contains('@') || !trimmedValue.contains('.')) {
      return 'Enter a valid email address.';
    }
    return null;
  }

  static String? validatePassword(String value) {
    if (value.isEmpty) {
      return 'Password is required.';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters.';
    }
    return null;
  }

  static String? validateEntryTitle(String value) {
    if (value.trim().isEmpty) {
      return 'Title is required.';
    }
    return null;
  }

  static String? validatePortion(String value) {
    if (value.trim().isEmpty) {
      return 'Portion is required.';
    }
    final parsed = int.tryParse(value);
    if (parsed == null || parsed <= 0) {
      return 'Portion must be a positive number.';
    }
    return null;
  }
}
