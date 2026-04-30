import 'package:flutter_test/flutter_test.dart';
import 'package:collab_task/core/extension/string_extension.dart';

void main() {
  group('StringExtension.capitalize', () {
    test('uppercases the first character and lowercases the rest', () {
      expect('flutter'.capitalize(), 'Flutter');
    });

    test('returns the same shape for already-capitalized input', () {
      expect('Flutter'.capitalize(), 'Flutter');
    });

    test('handles all-caps input by lowercasing the tail', () {
      expect('FLUTTER'.capitalize(), 'Flutter');
    });
  });
}
