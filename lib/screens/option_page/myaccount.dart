import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:koompi_hotspot/all_export.dart';

class MyAccount extends StatefulWidget {
  const MyAccount({Key? key}) : super(key: key);

  @override
  MyAccountState createState() => MyAccountState();
}

class MyAccountState extends State<MyAccount>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;

  final formKey = GlobalKey<FormState>();
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;
  String? imageUrl;

  Future pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        imageUrl = pickedFile.path;
      });
    }
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
        var response = await PostRequest().completeInfoUser(
          fullnameController.text,
          phoneController.text,
          gender!,
          birthdate!,
          address!,
        );
        if (response.statusCode == 200) {
          if(imageUrl != null){
            await PostRequest().upLoadImage(File(imageUrl!));
          }
          setState(() {
            StorageServices().updateUserData(context);
          });
        } else {
          if (kDebugMode) {
            print('update info not Successful');
          }

          if (!mounted) return;
          await Components.dialog(
            context,
            textAlignCenter(text: lang.translate('update_info_error')),
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

  final _birthdate = DateFormat('dd-MMM-yyyy').format(DateTime.now());
  
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _controller!.dispose();
  }


  // final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void comingSoonSnackBar() {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text("Please Complete All Infomation!"),
      behavior: SnackBarBehavior.floating,
    ));
  }
  
  //Get Data
  String? name = mData.fullname;
  String? gender = mData.gender;
  String? email = mData.email;
  String? birthdate = mData.birthdate;
  String? address = mData.address;

  TextEditingController fullnameController =
      TextEditingController(text: '${mData.fullname}');
  TextEditingController phoneController =
      TextEditingController(text: '${mData.phone}');

  //LocationPicker
  var locationModel = LocationList();

  //Gender Select
  List<String> lst = ['Male', 'Female'];
  String? selectedIndex;

  void changeIndex(String index) {
    setState(() {
      gender = index;
    });
  }

  //DOB Picker
  DateTime selectedDate = DateTime.now();

  var dateFormart = DateFormat('dd-MMM-yyyy');

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: dateFormart.parse(_birthdate),
      firstDate: DateTime(1770, 1),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(primary: primaryColor),
            buttonTheme:
                const ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child!,
        );
      },
    );
    if (picked != selectedDate) {
      setState(() {
        selectedDate = picked!;
        birthdate = dateFormart.format(selectedDate);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var lang = AppLocalizeService.of(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Text(lang.translate('edit_account'),
          style: GoogleFonts.robotoCondensed(
            textStyle: const TextStyle(
              color: Colors.black,
              fontStyle: FontStyle.italic,
              fontSize: 24,
              fontWeight: FontWeight.w700,
            )
          ),
        ),
        leading: Builder(builder: (BuildContext context) {
          return IconButton(
              icon: const Icon(
                Iconsax.arrow_left_2,
                color: Colors.black,
              ),
              onPressed: () {
                Navigator.pop(context);
              });
        }),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 5.0),
            child: GestureDetector(
              child: IconButton(
                icon: const Icon(
                  Icons.check,
                  color: Colors.blueAccent,
                ),
                onPressed: () async {
                  setState(() {
                    fullnameController.text.isEmpty || gender!.isEmpty || gender!.isEmpty || address!.isEmpty ?
                    comingSoonSnackBar()
                    : 
                    _submitValidate();
                  });
                },
              ),
            ),
          ),
        ],
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 2,
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
                      height: 10.0,
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: CircleAvatar(
                        radius: 50.0,
                        backgroundColor: const Color(0xff476cfb),
                        child: ClipOval(
                          child: SizedBox(
                            width: 100.0,
                            height: 100.0,
                            child: (imageUrl != null)
                                ? Image.file(
                                    File(imageUrl!),
                                    fit: BoxFit.cover,
                                  )
                                : CircleAvatar(
                                    backgroundImage: mData.image == null
                                        ? const AssetImage(
                                            'assets/images/avatar.png')
                                        : NetworkImage(
                                                "${ApiService.getAvatar}/${mData.image}")
                                            as ImageProvider<Object>,
                                  ),
                          ),
                        ),
                      ),
                    ),
                    Center(
                      child: TextButton(
                        child: Text(lang.translate('edit_profile_picture'),
                            style: TextStyle(
                                color: primaryColor,
                                fontSize: 20.0,
                                fontFamily: 'Medium')),
                        onPressed: () => pickImage(),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    // Text(_lang.translate('fullname')),
                    const SizedBox(height: 10.0),
                    TextFormField(
                      validator: (val) => val!.length < 3
                          ? lang.translate('fullname_validate')
                          : null,
                      onSaved: (val) => fullnameController.text = val!,
                      autovalidateMode: AutovalidateMode.always,
                      controller: fullnameController,
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Iconsax.user,
                          color: primaryColor,
                        ),
                        hintText: lang.translate('fullname'),
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
                    // Text(_lang.translate('phone_number_tf')),
                    const SizedBox(height: 10.0),
                    TextFormField(
                      readOnly: true,
                      controller: phoneController,
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Iconsax.call,
                          color: primaryColor,
                        ),
                        hintText: lang.translate('phone_number_tf'),
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
                    // Text(_lang.translate('dateofbirth')),
                    const SizedBox(height: 10.0),
                    dateOfbirth(selectedDate, _selectDate, dateFormart, context),
                    const SizedBox(height: 16.0),
                    // Text(_lang.translate('locaton')),
                    const SizedBox(height: 10.0),
                    locationPicker(context),
                    const SizedBox(height: 16.0),
                    // Text(_lang.translate('gender')),
                    const SizedBox(height: 10.0),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: GestureDetector(
                            onTap: () => setState(() => changeIndex('Male')),
                            child: Container(
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                  boxShadow: const [
                                    BoxShadow(
                                        color: Colors.black, blurRadius: 1),
                                  ],
                                  color: gender == 'Male'
                                      ? HexColor('0CACDA')
                                      : Colors.white,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(12)),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Iconsax.man),
                                    Text(lang.translate('male'),
                                        style: TextStyle(
                                            fontFamily: "Medium",
                                            color: gender == 'Male'
                                                ? Colors.black
                                                : Colors.grey))
                                  ],
                                )),
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => setState(() => changeIndex('Female')),
                            child: Container(
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                  boxShadow: const [
                                    BoxShadow(
                                        color: Colors.black, blurRadius: 1),
                                  ],
                                  color: gender == 'Female'
                                      ? HexColor('0CACDA')
                                      : Colors.white,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(12)),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Iconsax.woman),
                                    Text(lang.translate('female'),
                                        style: TextStyle(
                                            fontFamily: "Medium",
                                            color: gender == 'Female'
                                                ? Colors.black
                                                : Colors.grey))
                                  ],
                                )),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 50.0),
                    // name == null ?
                    // Row(
                    //   crossAxisAlignment: CrossAxisAlignment.end,
                    //   mainAxisAlignment: MainAxisAlignment.start,
                    //   children: const <Widget>[
                    //     Icon(
                    //       LineIcons.info,
                    //       color: Color.fromARGB(255, 255, 125, 125),
                    //     ),
                    //     Text('Complated all information to receveie SEL Token',
                    //         style: TextStyle(
                    //             fontFamily: 'Medium',
                    //             fontSize: 12.0,
                    //             color: Colors.grey)),
                    //   ],
                    // )
                    // :
                    // Container(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget locationPicker(BuildContext context) {
    return LocationDropdown(
      valueText: address ?? locationModel.selectedKhLocation.toString(),
      onPressed: () => showMaterialScrollPicker(
        context: context,
        title: "Pick Your Location",
        items: locationModel.khLocation,
        selectedItem: address,
        onChanged: (value) =>
            setState(() => locationModel.selectedKhLocation = value.toString()),
        onCancelled: () => Navigator.canPop(context),
        onConfirmed: () => address = locationModel.selectedKhLocation,
      ),
    );
  }

  Widget dateOfbirth(DateTime selectedDate, selectDate, dateFormart, context) {
    return DateDropdown(
      valueText: birthdate ?? 'Select Date of Birth',
      onPressed: () {
        selectDate(context);
      },
    );
  }
}
