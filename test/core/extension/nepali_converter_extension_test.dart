import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_clean_starter/core/extension/nepali_converter_extension.dart';

void main() {
  group('NepaliNumberConverter', () {
    test('converts a single ASCII digit to its Devanagari equivalent', () {
      expect('0'.toNepali(), '०');
      expect('9'.toNepali(), '९');
      
    });

    test('converts a multi-digit string digit-by-digit', () {
      expect('2082'.toNepali(), '२०८२');
    });

    test('works on int via the Object.toString() path', () {
      expect(9841.toString().toNepali(), '९८४१');
    });

    test('passes non-digit characters through unchanged', () {
      expect('v1.2'.toNepali(), 'v१.२');
      expect(''.toNepali(), '');
    });
  });
}
