/// Form validation utilities
/// Form doğrulama yardımcı fonksiyonları

class Validators {
  /// Email validation
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email';
    }
    
    return null;
  }

  /// Password validation
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    
    return null;
  }

  /// Player name validation
  static String? validatePlayerName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Name is required';
    }
    
    if (value.length < 3) {
      return 'Name must be at least 3 characters';
    }
    
    if (value.length > 20) {
      return 'Name must not exceed 20 characters';
    }
    
    // Only letters, numbers, spaces, and underscores
    final nameRegex = RegExp(r'^[a-zA-Z0-9_ ]+$');
    if (!nameRegex.hasMatch(value)) {
      return 'Name can only contain letters, numbers, spaces, and underscores';
    }
    
    return null;
  }

  /// Generic required field validation
  static String? validateRequired(String? value, {String fieldName = 'Field'}) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  /// Numeric validation
  static String? validateNumeric(String? value, {String fieldName = 'Value'}) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }
    
    if (int.tryParse(value) == null && double.tryParse(value) == null) {
      return '$fieldName must be a number';
    }
    
    return null;
  }

  /// Phone number validation (basic)
  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }
    
    final phoneRegex = RegExp(r'^[0-9]{10,15}$');
    if (!phoneRegex.hasMatch(value.replaceAll(RegExp(r'[^0-9]'), ''))) {
      return 'Please enter a valid phone number';
    }
    
    return null;
  }

  /// Min length validation
  static String? validateMinLength(String? value, int minLength, {String fieldName = 'Field'}) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }
    
    if (value.length < minLength) {
      return '$fieldName must be at least $minLength characters';
    }
    
    return null;
  }

  /// Max length validation
  static String? validateMaxLength(String? value, int maxLength, {String fieldName = 'Field'}) {
    if (value == null || value.isEmpty) {
      return null; // Optional field
    }
    
    if (value.length > maxLength) {
      return '$fieldName must not exceed $maxLength characters';
    }
    
    return null;
  }
}
