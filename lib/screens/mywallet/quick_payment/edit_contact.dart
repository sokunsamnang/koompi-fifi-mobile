import 'package:koompi_hotspot/all_export.dart';
import 'package:koompi_hotspot/providers/contact_list_provider.dart';

class EditContact extends StatefulWidget {

  final int id;
  final String? name;
  final String? address;

  const EditContact({Key? key, required this.id, this.name, this.address})
      : super(key: key);
  @override
  EditContactState createState() => EditContactState();
}

class EditContactState extends State<EditContact> {

  TextEditingController usernameController = TextEditingController();
  TextEditingController addressWalletController = TextEditingController();
  final Backend _backend = Backend();


  GlobalKey<ScaffoldState> globalKey = GlobalKey<ScaffoldState>();

  final formKey = GlobalKey<FormState>();
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;

  String onChanged(String value) {
    return value;
  }

  void _submitValidate() {
    final form = formKey.currentState;

    if (form!.validate()) {
      form.save();
      _onSubmit();
    } else {
      setState(() {
        autovalidateMode = AutovalidateMode.always;
      });
    }
  }


  Future<void> _onSubmit() async {
    var lang = AppLocalizeService.of(context);

    dialogLoading(context);
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        if (kDebugMode) {
          print('Internet connected');
        }
        _backend.response = await PostRequest().putContactAddress(
          widget.id.toString(),
          usernameController.text,
          addressWalletController.text,
        );

        var responseJson = json.decode(_backend.response!.body);
        if (_backend.response!.statusCode == 200) {

          if (!mounted) return;
          await Provider.of<ContactListProvider>(context, listen: false).fetchContactList();

          if (!mounted) return;
          Navigator.of(context).pop();
          Navigator.of(context).pop();
        } 
        else {
          if (!mounted) return;
          await Components.dialog(
            context,
            textAlignCenter(text: responseJson['message']),
            warningTitleDialog()
          );

          if (!mounted) return;
          Navigator.of(context).pop();
        }
      }
    } on SocketException catch (_) {
      await Components.dialog(
        context,
        textAlignCenter(text: lang.translate('no_internet_message')),
        warningTitleDialog()
      );

      if (!mounted) return;
      Navigator.of(context).pop();
    }
  }

  @override
  void initState() {
    super.initState();
    usernameController = TextEditingController(text: widget.name);
    addressWalletController = TextEditingController(text: widget.address);
    AppServices.noInternetConnection(globalKey);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      key: globalKey,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
            icon: const Icon(Iconsax.arrow_left_2, color: Colors.black),
            onPressed: () {
              Navigator.pop(context);
            }),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(
          color: Colors.black, //change your color here
        ),
        title: Text(
          'Edit Contact',
         style: GoogleFonts.robotoCondensed(
            textStyle: const TextStyle(
              color: Colors.black,
              fontStyle: FontStyle.italic,
              fontSize: 24,
              fontWeight: FontWeight.w700,
            )
          ),
        ),
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Form(
            key: formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 28.0, right: 28.0, bottom: 30.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const SizedBox(
                      height: 16.0,
                    ),
                    // const Text('Template Name'),
                    const SizedBox(height: 10.0),
                    TextFormField(
                      validator: (val) => val!.isEmpty
                          ? 'Name is required'
                          : null,
                      onSaved: (val) => usernameController.text = val!,
                      autovalidateMode: AutovalidateMode.always,
                      maxLength: null,
                      controller: usernameController,
                      decoration: InputDecoration(
                        prefixIcon:
                            Icon(Iconsax.user_add, color: HexColor('0CACDA')),
                        hintText: 'Name',
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: BorderSide(
                            color: primaryColor,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: BorderSide(
                            color: primaryColor,
                          ),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: const BorderSide(color: Colors.red),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: const BorderSide(color: Colors.red),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    // const Text('Receiver Address'),
                    const SizedBox(height: 10.0),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: TextFormField(
                            onChanged: onChanged,
                            validator: (val) => val!.isEmpty
                                ? 'Receiver Address is required'
                                : null,
                            onSaved: (val) => addressWalletController.text = val!,
                            autovalidateMode: AutovalidateMode.always,
                            maxLength: null,
                            controller: addressWalletController,
                            decoration: InputDecoration(
                              prefixIcon:
                                  Icon(Iconsax.document_text, color: HexColor('0CACDA')),
                              hintText: 'Receiver Address',
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.0),
                                borderSide: BorderSide(
                                  color: primaryColor,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.0),
                                borderSide: BorderSide(
                                  color: primaryColor,
                                ),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.0),
                                borderSide: const BorderSide(color: Colors.red),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.0),
                                borderSide: const BorderSide(color: Colors.red),
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                          splashRadius: 30.0,
                          icon: Icon(Iconsax.scan_barcode, color: primaryColor),
                          iconSize: 50,
                          onPressed: () async {
                            try {

                              final response = await Navigator.push(
                                context,
                                PageTransition(
                                    type: PageTransitionType.bottomToTop,
                                    child: const QrScanner()));

                              if (response != null) {
                                addressWalletController.text = response.toString();
                                onChanged(response.toString());
                              }
                              // ignore: empty_catches
                            } catch (e) {}
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 50.0),
                    Center(
                      child: InkWell(
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: 50,
                          decoration: BoxDecoration(
                              gradient: const LinearGradient(colors: [
                                Color(0xFF17ead9),
                                Color(0xFF6078ea)
                              ]),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                    color:
                                        const Color(0xFF6078ea).withOpacity(.3),
                                    offset: const Offset(0.0, 8.0),
                                    blurRadius: 8.0)
                              ]),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              customBorder: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              onTap: () async {
                                FocusScope.of(context).unfocus();
                                _submitValidate();
                              },
                              child: const Center(
                                child: Text('Save',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: "Poppins-Bold",
                                        fontSize: 18)),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
