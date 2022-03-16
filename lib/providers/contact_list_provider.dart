import 'package:koompi_hotspot/all_export.dart';
import 'package:koompi_hotspot/models/contact_list_model.dart';

class ContactListProvider with ChangeNotifier {
  Backend? _backend;

  GetRequest? _getRequest;

  List<ContactListModel> contactList = [];

  Future<void> fetchContactList() async {
    _backend = Backend();
    _getRequest = GetRequest();
    contactList = [];

    // Fetch Contact List
    await _getRequest!.getContactList().then((value) {
      _backend!.listData = json.decode(value.body);
      if (_backend!.listData!.isEmpty) {
        return null;
      } else {
        for (var l in _backend!.listData!) {
          contactList.add(ContactListModel(l));
        }
      }
    });

    notifyListeners();
  }
}
