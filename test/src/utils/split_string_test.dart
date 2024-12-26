import 'package:flutter_test/flutter_test.dart';
import 'package:smart_note/src/utils/split_string.dart';

void main() {
  test(
    "Split string and return list",
    () {
//arrange
      String str = "1,2,3,4,5";
//act
      List<String> result = SplitString.splitString(str);

//assert
      expect(result, ["1", "2", "3", "4", "5"]);
    },
  );
}
