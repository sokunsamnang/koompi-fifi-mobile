import 'package:http/http.dart' as http;
import 'package:koompi_hotspot/all_export.dart';

class GetRequest with ChangeNotifier {
  String? alertText;
  var _mData = ModelUserData();
  ModelUserData get mUser => _mData;

  final StorageServices _prefService = StorageServices();
  final Backend _backend = Backend();

  Future<http.Response> getUserProfile(String? token) async {
    var response = await http.get(Uri.parse("${ApiService.url}/dashboard/"),
        headers: <String, String>{
          "accept": "application/json",
          "authorization": "Bearer ${token!}",
        });
    var responseBody = json.decode(response.body);
    mData = ModelUserData.fromJson(responseBody);

    _mData = ModelUserData.fromJson(responseBody);

    return response;
  }

  Future<http.Response> getWallet() async {
    /* Expired Token In Welcome Screen */
    await _prefService.read('token').then((value) {
      _backend.token = Map<String, dynamic>.from({"token": value});
    });
    _backend.response = await http.get(
        Uri.parse("${ApiService.url}/selendra/get-wallet"),
        headers: _backend.conceteHeader(
            "authorization", "Bearer ${_backend.token['token']}"));
    return _backend.response!;
  }

  Future<http.Response> getTrxHistory() async {
    /* Expired Token In Welcome Screen */
    await _prefService.read('token').then((value) {
      _backend.token = Map<String, dynamic>.from({"token": value});
    });
    _backend.response = await http.get(
        Uri.parse("${ApiService.url}/selendra/history"),
        headers: _backend.conceteHeader(
            "authorization", "Bearer ${_backend.token['token']}"));
    return _backend.response!;
  }

  Future<http.Response> getNotification() async {
    /* Expired Token In Welcome Screen */
    await _prefService.read('token').then((value) {
      _backend.token = Map<String, dynamic>.from({"token": value});
    });
    _backend.response = await http.get(
        Uri.parse("${ApiService.url}/dashboard/notification"),
        headers: _backend.conceteHeader(
            "authorization", "Bearer ${_backend.token['token']}"));
    return _backend.response!;
  }

  Future<http.Response> getContactList() async {
    /* Expired Token In Welcome Screen */
    await _prefService.read('token').then((value) {
      _backend.token = Map<String, dynamic>.from({"token": value});
    });
    _backend.response = await http.get(
        Uri.parse("${ApiService.url}/contactlist"),
        headers: _backend.conceteHeader(
            "authorization", "Bearer ${_backend.token['token']}"));
    return _backend.response!;
  }

}
