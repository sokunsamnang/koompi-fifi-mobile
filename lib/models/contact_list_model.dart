class ContactListModel {
  int? id;
  String? username;
  String? address;

  ContactListModel(Map<String, dynamic> data) {
    _fromJson(data);
  }

  void _fromJson(Map<String, dynamic> data) {
    id = data['id'];
    username = data['contact_name'];
    address = data['contact_wallet'];
  }
}
