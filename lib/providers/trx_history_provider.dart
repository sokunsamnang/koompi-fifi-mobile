import 'package:koompi_hotspot/all_export.dart';
import 'package:http/http.dart' as http;

class TrxHistoryProvider with ChangeNotifier {
  Backend? _backend;

  List<TrxHistoryModel> trxHistoryList = [];

  Future<void> fetchTrxHistory() async {
    StorageServices _prefService = StorageServices();

    _backend = Backend();
    trxHistoryList = [];

    try {
      await _prefService.read('token').then((onValue) async {
        http.Response response = await http.get(
            Uri.parse('${ApiService.url}/selendra/history'),
            headers: <String, String>{
              "accept": "application/json",
              "authorization": "Bearer " + onValue!,
            });

        if (response.statusCode == 200) {
          var responseBody = json.decode(response.body);
          _backend!.listData = responseBody;
          for (var l in _backend!.listData!) {
            trxHistoryList.add(TrxHistoryModel(l));
          }
        } else {
          var responseBody = json.decode(response.body);
          return responseBody;
        }
      });
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }

    notifyListeners();
  }
}
