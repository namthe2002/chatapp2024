import 'dart:async';
import 'dart:convert';
import 'dart:io';
import "dart:html" as html;
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:live_yoko/Global/TextByNation.dart';
import 'package:live_yoko/Utils/Translator.dart';

import '../Global/GlobalValue.dart';
import '../Utils/Utils.dart';

class APICaller {
  static APICaller _apiCaller = APICaller();



  final String BASE_URL = "https://tw-apimaster-v2.anbeteam.io.vn/api/";
  final String BASE_URL_MEDIA = "https://livestreammedia.funcasino.vip/";
  Translator translator = Translator();

  static APICaller getInstance() {
    if (_apiCaller == null) {
      _apiCaller = APICaller();
    }
    return _apiCaller;
  }

  Future<dynamic> get(String endpoint, {dynamic body}) async {
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': GlobalValue.getInstance().getToken(),
    };
    Uri uri = Uri.parse(BASE_URL + endpoint);
    final finalUri = uri.replace(queryParameters: body);

    final response = await http
        .get(finalUri, headers: requestHeaders)
        .timeout(const Duration(seconds: 30), onTimeout: () {
      return http.Response(
          TextByNation.getStringByKey('error_api_no_connect'), 408);
    });
    Utils.backLogin(response.statusCode == 401);
    if (response.statusCode != 200) {
      return null;
    }
    if (jsonDecode(response.body)['error']['code'] != 0) {
      translator.init2();
      String translateData = await translator
          .translate(jsonDecode(response.body)['error']['message']);
      Utils.showSnackBar(
          title: TextByNation.getStringByKey('notification'),
          message: translateData);
      return null;
    }
    return jsonDecode(response.body);
  }

  Future<dynamic> post(String endpoint, dynamic body) async {
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': GlobalValue.getInstance().getToken(),
    };
    final uri = Uri.parse(BASE_URL + endpoint);

    final response = await http
        .post(uri, headers: requestHeaders, body: jsonEncode(body))
        .timeout(
      const Duration(seconds: 30),
      onTimeout: () {
        return http.Response(
            TextByNation.getStringByKey('error_api_no_connect'), 408);
      },
    );
    Utils.backLogin(response.statusCode == 401);
    if (response.statusCode != 200) {
      return null;
    }
    if (jsonDecode(response.body)['error']['code'] != 0) {
      translator.init2();
      String translateData = await translator
          .translate(jsonDecode(response.body)['error']['message']);
      Utils.showSnackBar(
          title: TextByNation.getStringByKey('notification'),
          message: translateData);
      return null;
    }
    return jsonDecode(response.body);
  }

  Future<dynamic> postFile(String endpoint, File filePath) async {
    Map<String, String> requestHeaders = {
      'Content-type': 'multipart/form-data',
      'AccountUuid': GlobalValue.getInstance().getUuid(),
      'Product': 'User'
    };
    final uri = Uri.parse(BASE_URL_MEDIA + endpoint);

    final request = http.MultipartRequest('POST', uri);
    request.files.add(await http.MultipartFile.fromPath('file', filePath.path));
    request.headers.addAll(requestHeaders);

    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse).timeout(
      const Duration(seconds: 30),
      onTimeout: () {
        return http.Response(
            TextByNation.getStringByKey('error_api_no_connect'), 408);
      },
    );
    Utils.backLogin(response.statusCode == 401);
    if (response.statusCode != 200) {
      return null;
    }
    if (jsonDecode(response.body)['error']['code'] != 0) {
      translator.init2();
      String translateData = await translator
          .translate(jsonDecode(response.body)['error']['message']);
      Utils.showSnackBar(
          title: TextByNation.getStringByKey('notification'),
          message: translateData);
      return null;
    }
    return jsonDecode(response.body);
  }

  Future<dynamic> putFile(
      {required String endpoint,
      required File filePath,
      required int type,
      required String keyCert,
      required String time}) async {
    Map<String, String> requestHeaders = {
      'Content-type': 'multipart/form-data',
      'Authorization': GlobalValue.getInstance().getToken(),
    };
    final uri = Uri.parse(BASE_URL + endpoint);

    final request = http.MultipartRequest('PUT', uri);
    request.files
        .add(await http.MultipartFile.fromPath('ImageFile', filePath.path));
    request.fields['Type'] = '$type';
    request.fields['KeyCert'] = '$keyCert';
    request.fields['Time'] = '$time';
    request.headers.addAll(requestHeaders);

    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse).timeout(
      const Duration(seconds: 30),
      onTimeout: () {
        return http.Response(
            TextByNation.getStringByKey('error_api_no_connect'), 408);
      },
    );
    Utils.backLogin(response.statusCode == 401);
    if (response.statusCode != 200) {

      return null;
    }
    if (jsonDecode(response.body)['error']['code'] != 0) {
      translator.init2();
      String translateData = await translator
          .translate(jsonDecode(response.body)['error']['message']);
      Utils.showSnackBar(
          title: TextByNation.getStringByKey('notification'),
          message: translateData);
      return null;
    }
    return jsonDecode(response.body);
  }



  Future<dynamic> putFilesWeb2(
      {required String endpoint,
        required List<Uint8List> fileData,
        required int type,
        required String keyCert,
        required String time,required String fileName}) async {
    Map<String, String> requestHeaders = {
      'Content-type': 'multipart/form-data',
      'Authorization': GlobalValue.getInstance().getToken(),
    };
    final uri = Uri.parse(BASE_URL + endpoint);

    final request = http.MultipartRequest('PUT', uri);
    List<http.MultipartFile> files = [];
    for (var file in fileData) {
      var f = http.MultipartFile.fromBytes(
        'ImageFile',
        file,
        filename:fileName,
      );
      files.add(f);
    }


    request.files.addAll(files);
    request.fields['Type'] = '$type';
    request.fields['KeyCert'] = '$keyCert';
    request.fields['Time'] = '$time';
    request.headers.addAll(requestHeaders);

    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse).timeout(
      const Duration(seconds: 30),
      onTimeout: () {
        return http.Response(
            TextByNation.getStringByKey('error_api_no_connect'), 408);
      },
    );

    Utils.backLogin(response.statusCode == 401);
    if (response.statusCode != 200) {
      return null;
    }
    if (jsonDecode(response.body)['error']['code'] != 0) {
      translator.init2();
      String translateData = await translator
          .translate(jsonDecode(response.body)['error']['message']);
      Utils.showSnackBar(
          title: TextByNation.getStringByKey('notification'),
          message: translateData);
      return null;
    }
    return jsonDecode(response.body);
  }


  Future<dynamic> putFilesWeb(
      {required String endpoint,
      required List<html.File> fileData,
      required int type,
      required String keyCert,
      required String time}) async {
    Map<String, String> requestHeaders = {
      'Content-type': 'multipart/form-data',
      'Authorization': GlobalValue.getInstance().getToken(),
    };
    final uri = Uri.parse(BASE_URL + endpoint);

    final request = http.MultipartRequest('PUT', uri);
    List<http.MultipartFile> files = [];
    for (var file in fileData) {
      final reader = html.FileReader();
      reader.readAsArrayBuffer(file);
      await reader.onLoad.first;
      final data = reader.result as Uint8List;
      var f = http.MultipartFile.fromBytes(
        'ImageFile',
        data,
        filename: file.name,
      );
      files.add(f);
    }


    request.files.addAll(files);
    request.fields['Type'] = '$type';
    request.fields['KeyCert'] = '$keyCert';
    request.fields['Time'] = '$time';
    request.headers.addAll(requestHeaders);

    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse).timeout(
      const Duration(seconds: 30),
      onTimeout: () {
        return http.Response(
            TextByNation.getStringByKey('error_api_no_connect'), 408);
      },
    );

    Utils.backLogin(response.statusCode == 401);
    if (response.statusCode != 200) {
      return null;
    }
    if (jsonDecode(response.body)['error']['code'] != 0) {
      translator.init2();
      String translateData = await translator
          .translate(jsonDecode(response.body)['error']['message']);
      Utils.showSnackBar(
          title: TextByNation.getStringByKey('notification'),
          message: translateData);
      return null;
    }
    return jsonDecode(response.body);
  }

  Future<dynamic> putFiles(
      {required String endpoint,
      required List<File> filePath,
      required int type,
      required String keyCert,
      required String time}) async {
    Map<String, String> requestHeaders = {
      'Content-type': 'multipart/form-data',
      'Authorization': GlobalValue.getInstance().getToken(),
    };
    final uri = Uri.parse(BASE_URL + endpoint);

    final request = http.MultipartRequest('PUT', uri);
    List<http.MultipartFile> files = [];
    for (File file in filePath) {
      var f = await http.MultipartFile.fromPath('ImageFile', file.path);
      files.add(f);
    }
    request.files.addAll(files);
    request.fields['Type'] = '$type';
    request.fields['KeyCert'] = '$keyCert';
    request.fields['Time'] = '$time';
    request.headers.addAll(requestHeaders);

    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse).timeout(
      const Duration(seconds: 30),
      onTimeout: () {
        return http.Response(
            TextByNation.getStringByKey('error_api_no_connect'), 408);
      },
    );

    Utils.backLogin(response.statusCode == 401);
    if (response.statusCode != 200) {
      // Utils.showSnackBar(
      //     title: TextByNation.getStringByKey('notification'),
      //     message: response.body);
      return null;
    }
    if (jsonDecode(response.body)['error']['code'] != 0) {
      translator.init2();
      String translateData = await translator
          .translate(jsonDecode(response.body)['error']['message']);
      Utils.showSnackBar(
          title: TextByNation.getStringByKey('notification'),
          message: translateData);
      return null;
    }
    return jsonDecode(response.body);
  }

  Future<dynamic> postFiles(String endpoint, List<File> filePath) async {
    Map<String, String> requestHeaders = {
      'Content-type': 'multipart/form-data',
      'Authorization': GlobalValue.getInstance().getToken(),
      'AccountUuid': GlobalValue.getInstance().getUuid(),
      'Product': 'User'
    };
    final uri = Uri.parse(BASE_URL_MEDIA + endpoint);

    final request = http.MultipartRequest('POST', uri);
    List<http.MultipartFile> files = [];
    for (File file in filePath) {
      var f = await http.MultipartFile.fromPath('files', file.path);
      files.add(f);
    }
    request.files.addAll(files);
    request.headers.addAll(requestHeaders);

    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse).timeout(
      const Duration(seconds: 30),
      onTimeout: () {
        return http.Response(
            TextByNation.getStringByKey('error_api_no_connect'), 408);
      },
    );
    Utils.backLogin(response.statusCode == 401);
    if (response.statusCode != 200) {
      // Utils.showSnackBar(
      //     title: TextByNation.getStringByKey('notification'),
      //     message: response.body);
      return null;
    }
    if (jsonDecode(response.body)['error']['code'] != 0) {
      translator.init2();
      String translateData = await translator
          .translate(jsonDecode(response.body)['error']['message']);
      Utils.showSnackBar(
          title: TextByNation.getStringByKey('notification'),
          message: translateData);
      return null;
    }
    return jsonDecode(response.body);
  }

  Future<dynamic> put(String endpoint, dynamic body) async {
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': GlobalValue.getInstance().getToken(),
      'AccountUuid': GlobalValue.getInstance().getUuid(),
      'token': GlobalValue.getInstance()
          .getToken()
          .substring(GlobalValue.getInstance().getToken().indexOf(' ') + 1),
      'Product': 'User'
    };
    final uri = Uri.parse(BASE_URL + endpoint);

    final response = await http
        .put(uri, headers: requestHeaders, body: jsonEncode(body))
        .timeout(
      const Duration(seconds: 30),
      onTimeout: () {
        return http.Response(
            TextByNation.getStringByKey('error_api_no_connect'), 408);
      },
    );
    Utils.backLogin(response.statusCode == 401);
    if (response.statusCode != 200) {
      // Utils.showSnackBar(
      //     title: TextByNation.getStringByKey('notification'),
      //     message: response.body);
      return null;
    }
    if (jsonDecode(response.body)['error']['code'] != 0) {
      translator.init2();
      String translateData = await translator
          .translate(jsonDecode(response.body)['error']['message']);
      Utils.showSnackBar(
          title: TextByNation.getStringByKey('notification'),
          message: translateData);
      return null;
    }
    return jsonDecode(response.body);
  }

  Future<dynamic> delete(String endpoint, {dynamic body}) async {
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': GlobalValue.getInstance().getToken(),
      'AccountUuid': GlobalValue.getInstance().getUuid(),
      'Product': 'User'
    };
    final uri = Uri.parse(BASE_URL + endpoint);

    final response = await http
        .delete(uri, headers: requestHeaders, body: jsonEncode(body))
        .timeout(
      const Duration(seconds: 30),
      onTimeout: () {
        return http.Response(
            TextByNation.getStringByKey('error_api_no_connect'), 408);
      },
    );
    Utils.backLogin(response.statusCode == 401);
    if (response.statusCode != 200) {
      // Utils.showSnackBar(
      //     title: TextByNation.getStringByKey('notification'),
      //     message: response.body);
      return null;
    }
    if (jsonDecode(response.body)['error']['code'] != 0) {
      translator.init2();
      String translateData = await translator
          .translate(jsonDecode(response.body)['error']['message']);
      Utils.showSnackBar(
          title: TextByNation.getStringByKey('notification'),
          message: translateData);
      return null;
    }
    return jsonDecode(response.body);
  }
}
