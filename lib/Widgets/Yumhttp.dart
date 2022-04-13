import 'dart:convert';
import 'package:http/http.dart' as http;

class YumUserhttp {
  late String _cookie;
  String _uid;
  YumUserhttp(this._uid);
  String yumURL = '54.180.116.149:82';
  Future<int> yumRegister(_nickName) async {
    // final url = Uri.parse("http://52.79.251.162:80/auth/register");
    // var response = await http
    //     .put(url, body: <String, String?>{"uid": _uid, "nickName": _nickName});
    // // print(response.body);

    final url = Uri.http(yumURL, '/auth/register');
    var response = await http
        .post(url, body: <String, String>{"uid": _uid, "userAlias": _nickName});
    return response.statusCode;
  }

  yumDelete() async {
    final url = Uri.http(yumURL, '/auth/secession');
    var response = await http.delete(
      url,
      headers: {'Cookie': _cookie},
    );
    // print(response.body);
  }

  Future<int> yumUpdateNickName(_nickName) async {
    final url =
        Uri.http(yumURL, '/auth/updateNickName', {"userAlias": _nickName});
    var response = await http.post(url, headers: {'Cookie': _cookie});
    return response.statusCode;
  }

  Future<int> yumLogin() async {
    final url = Uri.http(yumURL, '/auth/login', {"uid": _uid});
    var response = await http.get(url);
    String _tmpCookie = response.headers['set-cookie'] ?? '';
    var idx = _tmpCookie.indexOf(';');
    _cookie = (idx == -1) ? _tmpCookie : _tmpCookie.substring(0, idx);
    // if (response.statusCode == 200) {
    //   print(response.body);
    //   print(_cookie);
    // } else {
    //   print('Request failed with status: ${response.statusCode}.');
    // }
    print(_cookie);
    return response.statusCode;
  }

  Future<int> yumProfileImg(imgPath) async {
    var headers = {'Cookie': _cookie};
    var request = http.MultipartRequest(
        'PUT', Uri.parse('http://54.180.116.149:82/auth/updateProfileImage'));
    request.files.add(await http.MultipartFile.fromPath('file', imgPath));
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    return response.statusCode;
  }

  Future<List<dynamic>> yumInfo() async {
    // print(_cookie);
    final url = Uri.http(yumURL, '/auth/info');
    late List<dynamic> _list;
    var response = await http.get(url, headers: {'Cookie': _cookie});
    if (response.statusCode == 200) {
      String responseBody = utf8.decode(response.bodyBytes);
      _list = jsonDecode(responseBody);
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
    return _list;
  }
}
