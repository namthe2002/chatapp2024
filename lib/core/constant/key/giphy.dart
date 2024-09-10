import 'dart:math';

class KeyPackage {
  static String apiKeyGiphyWebsite = 'FeeIBvB2H1cJV6z01sOdXpY7MOBnoGJn';

  static String getRandId() {
    const alphabet =
        'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    const length = 20;
    final buffer = StringBuffer();
    final random = Random.secure();

    for (int i = 0; i < length; i++) {
      buffer.write(alphabet[random.nextInt(length)]);
    }
    return buffer.toString();
  }
}
