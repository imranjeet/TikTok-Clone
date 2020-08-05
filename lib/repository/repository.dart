import 'package:http/http.dart' as http;

class Repository {
  String _baseUrl = 'http://agni-api.infous.xyz/api';
  var _headers = {"Content-type":"multipart/form-data"};
  // var _headers = {"Content-type": "application/x-www-form-urlencoded", "Accept": "application/json"};

  httpGet(String api) async {
    return await http.get(_baseUrl + "/" + api);
  }

  httpGetById(String api, id) async {
    return await http.get(_baseUrl + "/" + api + "/" + id.toString());
  }

  httpPost(String api, data) async {
    return await http.post(_baseUrl + "/" + api, body: data,
    );
  }
}
