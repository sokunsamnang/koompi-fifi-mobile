import 'package:koompi_hotspot/all_export.dart';
import 'package:intl/intl.dart';

class CompleteInfo extends StatefulWidget {
  final String phone;
  const CompleteInfo(this.phone, {Key? key}) : super(key: key);

  @override
  _CompleteInfoState createState() => _CompleteInfoState();
}

class _CompleteInfoState extends State<CompleteInfo> {
  final GlobalKey<FormBuilderState> formKey = GlobalKey<FormBuilderState>();
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;
  String lastChoiceChipSelection = '';

  final TextEditingController _usernameController = TextEditingController();
  TextEditingController? _phoneController;

  @override
  void initState() {
    super.initState();
    _birthdate = DateFormat('dd-MMM-yyyy').format(DateTime.now());
    _phoneController = TextEditingController(text: widget.phone);
  }

  @override
  void dispose() {
    super.dispose();
  }

  //Location
  late final String _address;
  var locationModel = LocationList();

  //Image Profile
  File? image;

  //Gender

  List<String> lst = ['Male', 'Female'];
  late final String _gender;
  void changeIndex(String index) {
    setState(() {
      _gender = index;
    });
  }

  //DOB Picker
  DateTime selectedDate = DateTime.now();

  String? _birthdate;

  final dateFormart = DateFormat('dd-MMM-yyyy');

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
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
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        _birthdate = dateFormart.format(selectedDate);
      });
    }
  }

  void _submitValidate(BuildContext context) {
    final form = formKey.currentState;

    if (form!.validate()) {
      form.save();
      _submit();
    } else {
      setState(() {
        autovalidateMode = AutovalidateMode.always;
      });
    }
  }

  Future<void> _submit() async {
    var _lang = AppLocalizeService.of(context);

    // _submit(context);
    dialogLoading(context);
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        var response = await PostRequest().completeInfoUser(
            _usernameController.text,
            widget.phone,
            _gender,
            _birthdate!,
            _address);

        if (response.statusCode == 200) {
          Navigator.pushAndRemoveUntil(
            context,
            PageTransition(
              type: PageTransitionType.rightToLeft,
              child: const LoginPhone(),
            ),
            ModalRoute.withName('/loginPhone'),
          );
        } else {
          await Components.dialog(
              context,
              textAlignCenter(text: _lang.translate('register_error')),
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

  @override
  Widget build(BuildContext context) {
    var _lang = AppLocalizeService.of(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Text(_lang.translate('complete_profile_appbar'),
            style: GoogleFonts.robotoCondensed(
            textStyle: const TextStyle(
              color: Colors.black,
              fontStyle: FontStyle.italic,
              fontSize: 24,
              fontWeight: FontWeight.w700,
            )
          ),
        ),
        automaticallyImplyLeading: false,
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
                  _submitValidate(context);
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
          child: FormBuilder(
            key: formKey,
            autovalidateMode: AutovalidateMode.always,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.only(left: 28.0, right: 28.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const SizedBox(height: 36.0),
                    Text(_lang.translate('fullname')),
                    const SizedBox(height: 10.0),
                    TextFormField(
                      controller: _usernameController,
                      validator: (val) => val!.length < 3
                          ? _lang.translate('fullname_validate')
                          : null,
                      onSaved: (val) => _usernameController.text = val!,
                      autovalidateMode: AutovalidateMode.always,
                      decoration: InputDecoration(
                          prefixIcon: Icon(LineIcons.user, color: primaryColor),
                          hintText: _lang.translate('fullname'),
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
                          )),
                    ),
                    const SizedBox(height: 16.0),
                    Text(
                      _lang.translate('phone_number_tf'),
                    ),
                    const SizedBox(height: 10.0),
                    TextFormField(
                      controller: _phoneController,
                      readOnly: true,
                      decoration: InputDecoration(
                          hintText: _lang.translate('phone_number_tf'),
                          prefixIcon: Icon(Icons.phone, color: primaryColor),
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
                          )),
                    ),
                    const SizedBox(height: 16.0),
                    Text(
                      _lang.translate('dateofbirth'),
                    ),
                    const SizedBox(height: 10.0),
                    dateOfbirth(
                        selectedDate, _selectDate, dateFormart, context),
                    const SizedBox(height: 16.0),
                    Text(
                      _lang.translate('locaton'),
                    ),
                    const SizedBox(height: 10.0),
                    locationPicker(context),
                    const SizedBox(height: 10.0),
                    // FormBuilderChoiceChip(
                    //   validator: (value) =>
                    //       value == null ? 'Please select your gender' : null,
                    //   onSaved: (newValue) => _gender = newValue.toString(),
                    //   decoration: InputDecoration(
                    //       border: InputBorder.none,
                    //       labelText: _lang.translate('gender'),
                    //       labelStyle: const TextStyle(
                    //           color: Colors.black, fontSize: 20)),
                    //   labelStyle: const TextStyle(
                    //       color: Colors.black,
                    //       fontSize: 18,
                    //       fontFamily: "Medium"),
                    //   selectedColor: primaryColor,
                    //   shape: RoundedRectangleBorder(
                    //       borderRadius: BorderRadius.circular(12.0)),
                    //   elevation: 2,
                    //   alignment: WrapAlignment.spaceBetween,
                    //   labelPadding: const EdgeInsets.only(left: 35, right: 35),
                    //   // attribute: "gender",
                    //   options: [
                    //     FormBuilderFieldOption(
                    //         value: 'Male',
                    //         child: Text(_lang.translate('male'))),
                    //     FormBuilderFieldOption(
                    //         value: 'Female',
                    //         child: Text(_lang.translate('female')))
                    //   ],
                    //   onChanged: (value) {
                    //     if (value == null) {
                    //       //* If chip unselected, set value to last selection
                    //       formKey.currentState!.fields['gender']!.value
                    //           .didChange(lastChoiceChipSelection);
                    //     } else {
                    //       //* If chip selected, save the value and rebuild
                    //       setState(() {
                    //         lastChoiceChipSelection = value.toString();
                    //       });
                    //     }
                    //   },
                    //   name: 'gender',
                    // ),
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
      valueText: locationModel.selectedKhLocation.toString(),
      onPressed: () => showMaterialScrollPicker(
        context: context,
        title: "Phnom Penh",
        items: locationModel.khLocation,
        selectedItem: locationModel.selectedKhLocation,
        onChanged: (value) =>
            setState(() => locationModel.selectedKhLocation = value.toString()),
        onCancelled: () => Navigator.canPop(context),
        onConfirmed: () => _address = locationModel.selectedKhLocation,
      ),
    );
  }

  Widget dateOfbirth(DateTime selectedDate, _selectDate, dateFormart, context) {
    return DateDropdown(
      valueText: _birthdate,
      onPressed: () {
        _selectDate(context);
      },
    );
  }
}
