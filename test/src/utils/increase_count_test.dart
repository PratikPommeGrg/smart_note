import 'package:flutter_test/flutter_test.dart';
import 'package:smart_note/src/utils/increase_count.dart';

void main() {
  test(
    "Value should be increased by 1",
    () {
//arrange
      int value = 0;

//act
      int result = increment(value);

//assert
      expect(result, 1);
    },
  );
}
