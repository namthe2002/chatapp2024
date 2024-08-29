class RegularExpressions {
  //RegExp
  static RegExp regexEmoji = RegExp(
      r'(\u00a9|\u00ae|[\u2000-\u3300]|\ud83c[\ud000-\udfff]|\ud83d[\ud000-\udfff]|\ud83e[\ud000-\udfff])');
  static RegExp hexPhoneNumber = RegExp(r'^(\+?84|0|86-?)?\d{9,12}$');
}
