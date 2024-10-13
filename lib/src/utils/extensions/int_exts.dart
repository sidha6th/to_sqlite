extension IntExts on int {
  bool get isLowerCaseChar => this >= 97 && this <= 122;

  bool get isUppercaseChar => this >= 65 && this <= 90;

  bool get isNumber => this >= 48 && this <= 57;

  bool get isAlphabet => isLowerCaseChar || isUppercaseChar;

  bool get isUnderscore => this==95;
}
