import 'dart:io';

import 'package:google_speech/google_speech.dart';
import 'package:live_yoko/Global/GlobalValue.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';

//guide: in controller create Speech2Text instance -> call init() -> call getTextFromAudio() when need

class Speech2Text {
  Speech2Text();

  late SpeechToText speechToText;

  Future init() async {
    var serviceAccount =
        ServiceAccount.fromString(r'''{"type": "service_account",
  "project_id": "daring-cache-417706",
  "private_key_id": "ea9aa52b3d8b8d02f8142a7b1f258e1f93ac6a7d",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvwIBADANBgkqhkiG9w0BAQEFAASCBKkwggSlAgEAAoIBAQDBRtt+eYjkv8dE\nObwTupK7Ew2esr0uXUoUc3jFL0awQCeHrmXRBA8LP2106CT0qEPbsHl3CBc1TxQq\na6o9vNCIC1I8cG2m0kqlwLdWAhpq47iLkjB+IkhhQ6FLeFIlShegp+Mqqnk9CSjN\nKy5/JhBSVv8SizTkA+SuQP4Q2oShd141DedKzNGojgIVdnvL3hIMgl1tjDYv3H0B\nfMFvmiwB48eGtTdZWNIJkQ6lUsw9QdBkEeIlnfLCi+1AeHuqt/1OmyVsN/6GLRa5\nVczEfwA3yM0B3JGnjQjUAd8/ObOrG6xm37IX+nraHklvZK+uQl+o49lNoHmKgIxk\nugE5CpBHAgMBAAECggEAEW1hFqV0KjAZEk+xMKEDk81MtP3bE6Z2Xgnono48B2HM\ntRRZrbMtShXYU3coXrK0MuE8N12DsWfyfD3qz7Gwc3vipXyu6zpaxoxUdUBjGNB0\ntonVe1VLBaryWcEJ7/I412C1mbmQwGfZha2gysObXox/Z/2+V9fHOgEcbfE0jiLY\nn/kSeZM6h/WfmxQsP6zmJCRxZK/ydGIRDilqV29JW9rwaWjzv9ErYUZC+aUaHXa1\nEFBmt+XK5MKicnz+xTyiUNCHACyNfDI7ofrSeP1mb6WPVnD8K9h2dlaRFJ/SWABm\nmYRZhgYitX97bnSMjxS653GNzngfLkUYXocecu5HkQKBgQD3B0ydcTA5Is87K8Oj\ntpTxbzGTWxAsRAWSVjgzJ1p6nr5CUIQ6mTQMnjbXn6fehCsthcs13OGbH6Z6V/pH\n4GyIbLX6rspZP+TJz0OBVgcH8op0x1i3ouaem0pjRIU1KluURjOQjoHSSXlPtwb9\nsqmMDglGy0zOh/6TJK1Ai8L4dwKBgQDIS8/II5MNQdc2PHTpECeBPLI8O1kVykBc\nEhIy3OjoOwWxhe44zv024p6AIrhY1kXu+GVpnMDHYcdIo2tVToQoadc1RXf4jKc1\nQYJg0ruylNe74Y2jLjCKfv3fUOXCw4CqyIUCiGy57UVG4yEpU/kxEWRbz3AddzZw\n2e/myODqsQKBgQCZ9+K4/yOfeSLRLqXyFIshML0lq0yZSoxueW7t80lhxC+yBZ1l\nKLhYZQSpwMlQ1/BRn2LZX6L+nOuWtd85jZgYMCn85ZUZq8leP+FDa+tV+MZzowyY\n6N/1W7UxyjN8v7n04QyivTANcd464UlqN0GWGemORojI8dqqu+GAqZwMYQKBgQCK\nY58XmETFFyW8Sn84fLne2HIJnbPKk2hudOnwDKQ7uHQRmQjkZVec8W0z+UlH0ByX\npTZkhzLHT66iaI8DbPFw/tf77ZibuYraB/4uKcwX8jEwlgIHqiVNu7pq7nkhXXTs\nCwmjm2EMAX0pIktKQ8Pb/DlMGgJLyY9q35ma6lZEsQKBgQCsQ7xkNRNS90bVl3bx\nyAd+WIs3oDQWPM+VGvJ+SG1VvuAtOpvAuaL+ZtpuOwZSti7eJEa9zMsSIlhtMt/Q\nrs23MZraMmYxMzsC7dLD8SblqDzFtcCV9Kq6uSGRWsMn7ZrtVcluNb25NxOsWaxR\n/BhnJ+4sgKCtoELYFbJ86I7B1Q==\n-----END PRIVATE KEY-----\n",
  "client_email": "ggspeechtotext@daring-cache-417706.iam.gserviceaccount.com",
  "client_id": "112543172812700320910",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/ggspeechtotext%40daring-cache-417706.iam.gserviceaccount.com",
  "universe_domain": "googleapis.com"}''');

    speechToText = SpeechToText.viaServiceAccount(serviceAccount);
  }

  Future<List<int>> _getAudioContent(String link) async {
    final directory = await getDownloadPath(link);
    final path = directory! + '/${Uri.parse(link).pathSegments.last}';
    return File(path).readAsBytesSync().toList();
  }

  Future<String> getTextFromAudio(String link, String languageCode) async {
    try {
      var config = RecognitionConfig(
          encoding: AudioEncoding.LINEAR16,
          model: RecognitionModel.basic,
          enableAutomaticPunctuation: true,
          sampleRateHertz: Platform.isAndroid ? 8000 : 44100,
          languageCode: languageCode);
      if (Platform.isIOS) {
        config.audioChannelCount = 2;
      }
      final status = await Permission.storage.request();
      var response;
      if (status.isGranted) {
        var audio = await _getAudioContent(link);
        response = await speechToText.recognize(config, audio);
      }
      return response.results
          .map((e) => e.alternatives.first.transcript)
          .join('\n');
    } catch (e) {
      print('$e');
      return '';
    }
  }

  Future<String?> getDownloadPath(String link) async {
    Directory? directory;
    try {
      if (Platform.isIOS) {
        directory = await getApplicationDocumentsDirectory();
      } else {
        directory = await getTemporaryDirectory();
        if (!await directory.exists())
          directory = await getExternalStorageDirectory();
      }

      final response = await http.get(Uri.parse(link));
      if (response.statusCode == 200) {
        await File('${directory!.path}/${Uri.parse(link).pathSegments.last}')
            .writeAsBytes((response.bodyBytes));
      }
    } catch (e) {
      print("Cannot get path");
    }
    return directory?.path;
  }
}
