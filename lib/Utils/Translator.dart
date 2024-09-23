import 'package:google_translate/google_translate.dart';
import 'package:live_yoko/Global/GlobalValue.dart';
import 'package:live_yoko/Global/TextByNation.dart';

class Translator {
  String currentFromCode = '';
  Translator();
  Future init() async {
    GoogleTranslate.initialize(
      apiKey: "AIzaSyBnmX-LJejvl5kihsN-pNxKZ9Rcbw8SM4k",
      targetLanguage: GlobalValue.getInstance().getCountryCode(),
    );
  }

  Future init2() async {
    String language = 'zh-CN';
    if (TextByNation.nationCode.value == 'US') {
      language = 'en';
    } else if (TextByNation.nationCode.value == 'VN') {
      language = 'vi';
    }
    GoogleTranslate.initialize(
      apiKey: "AIzaSyBnmX-LJejvl5kihsN-pNxKZ9Rcbw8SM4k",
      targetLanguage: language,
    );
  }

  Future<String> translate(String content) async {
    return await content.translate();
  }
}
