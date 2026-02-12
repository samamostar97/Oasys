typedef Validator = String? Function(String? value);

class FormValidators {
  static Validator requiredField(String message) {
    return (value) {
      if (value == null || value.trim().isEmpty) {
        return message;
      }
      return null;
    };
  }

  static Validator minLength(int min, String message) {
    return (value) {
      if (value == null || value.trim().length < min) {
        return message;
      }
      return null;
    };
  }

  static Validator email(String message) {
    final pattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    return (value) {
      if (value == null || value.trim().isEmpty) {
        return null;
      }
      if (!pattern.hasMatch(value.trim())) {
        return message;
      }
      return null;
    };
  }

  static Validator compose(List<Validator> validators) {
    return (value) {
      for (final validator in validators) {
        final error = validator(value);
        if (error != null) {
          return error;
        }
      }
      return null;
    };
  }
}
