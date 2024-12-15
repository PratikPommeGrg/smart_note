class RegexConfig {
  static RegExp numberRegex = RegExp('[0-9]');
  static RegExp textRegex = RegExp('[a-zA-Z]');
  static RegExp emailRegex = RegExp(
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
  static RegExp phoneNumberRegex = RegExp('9(6|7|8|9)[0-9]');

  static RegExp searchRegrex = RegExp('[a-zA-Z0-9- ]');
  static RegExp fullNameTextRegrex = RegExp('[a-zA-Z ]');

  static RegExp oneSpaceBetweenWords = RegExp(r'^(\w+ ?)*$');

  static RegExp stopConsecutiveSpace = RegExp(r'\s\s');

  static RegExp allowOneSpaceOnly = RegExp(r'\s{2}');

  static RegExp doubleRegExp = RegExp(r'^-?\d+(\.\d+)?$');
}
