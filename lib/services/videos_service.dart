import 'package:agni_app/repository/repository.dart';

class VideosService {
  Repository _repository;

  VideosService() {
    _repository = Repository();
  }

  getAllVideos() async {
    return await _repository.httpGet('get-all-videos');
  }

  // httpPost(String api, data) async {
  //   return await http.post(_baseUrl + "/" + api, body: data);
  // }
}
