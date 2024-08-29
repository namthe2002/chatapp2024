import 'package:google_translate/google_translate.dart';
import 'package:live_yoko/Global/GlobalValue.dart';
import 'package:live_yoko/Global/TextByNation.dart';

class Translator {
  // String currentFromCode = '';
  // Translator();
  // Future init(String from) async {
  //   currentFromCode = from;
  //   GoogleTranslate.initialize(
  //     apiKey: "AIzaSyBp3eBqKUulE7uObm7QpojxRF3Y9p-D3LU",
  //     sourceLanguage: from,
  //     targetLanguage: GlobalValue().getCountryCode(),
  //   );
  // }

  // Future<String> translate(String from, String content) async {
  //   if (currentFromCode != from) {
  //     currentFromCode = from;
  //     await init(currentFromCode);
  //   }

  //   await content.translate().then((value) {
  //     print('--------------------------------------- $value');
  //     return value;
  //   });
  //   return content;
  // }

  Translator();
  Future init() async {
    GoogleTranslate.initialize(
      apiKey: "AIzaSyBp3eBqKUulE7uObm7QpojxRF3Y9p-D3LU",
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
      apiKey: "AIzaSyBp3eBqKUulE7uObm7QpojxRF3Y9p-D3LU",
      targetLanguage: language,
    );
  }

  Future<String> translate(String content) async {
    return await content.translate();
  }
}
