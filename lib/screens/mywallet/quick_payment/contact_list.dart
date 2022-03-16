import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:koompi_hotspot/all_export.dart';
import 'package:koompi_hotspot/providers/contact_list_provider.dart';
import 'package:koompi_hotspot/screens/mywallet/quick_payment/edit_contact.dart';
import 'package:koompi_hotspot/screens/mywallet/quick_payment/save_contact.dart';

class ContactListScreen extends StatefulWidget {
  const ContactListScreen({Key? key}) : super(key: key);

  @override
  _ContactListScreenState createState() => _ContactListScreenState();
}

class _ContactListScreenState extends State<ContactListScreen> {

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
  var contact = Provider.of<ContactListProvider>(context);
  return Scaffold(
    appBar: AppBar(
      leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          }),
      backgroundColor: Colors.white,
      iconTheme: const IconThemeData(
        color: Colors.black, //change your color here
      ),
      title: const Text(
        'Quick Transfer',
        style: TextStyle(
            color: Colors.black, fontFamily: 'Medium', fontSize: 22.0),
      ),
    ),
    body: contact.contactList.isEmpty
        ? Column(
            children: [
              Expanded(
                child: Align(
                  alignment: Alignment.center,
                  child: SvgPicture.asset(
                    'assets/images/no_data.svg',
                    height: MediaQuery.of(context).size.height * 0.25,
                    width: MediaQuery.of(context).size.width * 0.25,
                    placeholderBuilder: (context) => const Center(),
                  ),
                ),
              ),
            ],
          )

        // Display Loading
        :contact.contactList.isEmpty
            ? Column(
                children: [
                  Expanded(
                    child: Align(
                      alignment: Alignment.center,
                      child: SvgPicture.asset(
                        'assets/images/no_data.svg',
                        height: MediaQuery.of(context).size.height * 0.25,
                        width: MediaQuery.of(context).size.width * 0.25,
                        placeholderBuilder: (context) => const Center(),
                      ),
                    ),
                  ),
                ],
              )
            // Display notification list
            : ListView.builder(
                // shrinkWrap: true,
                itemCount: contact.contactList.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.0),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 7,
                          offset:
                              const Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    child: ListTile(
                      onTap: () async {
                        await Navigator.push(
                          context,
                          PageTransition(
                            type: PageTransitionType.bottomToTop,
                            child: SendRequest(contact.contactList[index].address!, "", "")
                          )
                        );
                      },
                      trailing: DropdownButtonHideUnderline(
                        child: DropdownButton2(
                          customButton: const Icon(
                            Icons.more_vert_rounded,
                            size: 36,
                            color: Colors.black,
                          ), 
                          items: [
                            ...MenuItems.firstItems.map((item) =>
                              DropdownMenuItem<MenuItem>(
                                value: item,
                                child: MenuItems.buildItem(item),
                              ),
                            ),
                          ],
                          onChanged: (value) {
                            MenuItems.onChanged(context, value as MenuItem, index);
                          },
                          itemHeight: 48,
                          itemPadding: const EdgeInsets.only(left: 16, right: 16),
                          dropdownWidth: MediaQuery.of(context).size.width/ 1.5,
                          dropdownPadding: const EdgeInsets.symmetric(vertical: 6),
                          dropdownDecoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.white,
                          ),
                          dropdownElevation: 8,
                          offset: const Offset(0, 8),
                        ),
                      ),
                      title: Text(
                        contact.contactList[index].username!,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: TextStyle(
                          fontSize: 14.0,
                          color: HexColor('0CACDA'),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      subtitle: Text(
                        contact.contactList[index].address!,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: const TextStyle(
                          fontSize: 12.0,
                          color: Colors.black,
                          fontFamily: 'Poppins-Regular',
                        ),
                      ),
                    ),
                  );
                }),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => {
          Navigator.push(
            context,
            PageTransition(
              type: PageTransitionType.rightToLeft,
              child: const SaveContact()
            )
          ),
        }
      ),
    );
  }
}

class MenuItem {
  final String text;
  final IconData icon;

  const MenuItem({
    required this.text,
    required this.icon,
  });
}

class MenuItems {
  static const List<MenuItem> firstItems = [edit, delete];

  static const edit = MenuItem(text: 'Edit Template', icon: Icons.edit);
  static const delete = MenuItem(text: 'Delete Template', icon: Icons.delete);

  static Widget buildItem(MenuItem item) {
    return Row(
      children: [
        Icon(
          item.icon,
          color: Colors.black,
          size: 22
        ),
        const SizedBox(
          width: 10,
        ),
        Text(
          item.text,
          style: const TextStyle(
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  static onChanged(BuildContext context, MenuItem item, int index) {

    var contact =  Provider.of<ContactListProvider>(context, listen: false);

    Future<void> deleteContact() async {
      var _lang = AppLocalizeService.of(context);
      final Backend _backend = Backend();

      dialogLoading(context);
      try {
        final result = await InternetAddress.lookup('google.com');
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          if (kDebugMode) {
            print('Internet connected');
          }
          _backend.response = await PostRequest().deleteContactAddress(
            contact.contactList[index].id!,
          );

          var responseJson = json.decode(_backend.response!.body);
          if (_backend.response!.statusCode == 200) {
            await Provider.of<ContactListProvider>(context, listen: false).fetchContactList();
            Navigator.of(context).pop();
          } 
          else {
            await Components.dialog(
                context,
                textAlignCenter(text: responseJson['message']),
                warningTitleDialog());
            Navigator.of(context).pop();
          }
        }
      } on SocketException catch (_) {
        await Components.dialog(
            context,
            textAlignCenter(text: _lang.translate('no_internet_message')),
            warningTitleDialog());
        Navigator.of(context).pop();
      }
    }

    switch (item) {
      case MenuItems.edit:
      //Do something
        Navigator.push(
          context,
          PageTransition(
            type: PageTransitionType.rightToLeft,
            child: EditContact(id: contact.contactList[index].id!, name: contact.contactList[index].username, address: contact.contactList[index].address)
          )
        );
        break;

      case MenuItems.delete:
      //Do something
        deleteContact();
        break;
    }
  }

}