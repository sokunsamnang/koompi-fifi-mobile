import 'package:koompi_hotspot/all_export.dart';
import 'package:koompi_hotspot/models/contact_list_model.dart';
import 'package:http/http.dart' as http;

class ContactListProvider with ChangeNotifier {
  Backend? _backend;

  List<ContactListModel> contactList = [];

  Future<void> fetchContactList() async {
    StorageServices _prefService = StorageServices();
    _backend = Backend();
    contactList = [];

    // Fetch Contact List
    try {
      await _prefService.read('token').then((onValue) async {
        http.Response response = await http.get(
            Uri.parse('${ApiService.url}/contactlist'),
            headers: <String, String>{
              "accept": "application/json",
              "authorization": "Bearer " + onValue!,
            });

        if (response.statusCode == 200) {
          var responseBody = json.decode(response.body);
          _backend!.listData = responseBody;
          for (var l in _backend!.listData!) {
            contactList.add(ContactListModel(l));
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
