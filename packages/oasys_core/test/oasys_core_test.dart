import 'package:flutter_test/flutter_test.dart';
import 'package:oasys_core/oasys_core.dart';

void main() {
  test('required validator returns message for empty value', () {
    final validator = FormValidators.requiredField('Required');

    expect(validator(''), 'Required');
    expect(validator('value'), isNull);
  });
}
