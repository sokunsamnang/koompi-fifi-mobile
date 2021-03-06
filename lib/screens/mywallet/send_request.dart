import 'package:koompi_hotspot/all_export.dart';

class SendRequest extends StatefulWidget {
  final String walletKey;
  final String assetName;
  final String amount;
  const SendRequest(this.walletKey, this.assetName, this.amount, {Key? key})
      : super(key: key);
  @override
  _SendRequestState createState() => _SendRequestState();
}

class _SendRequestState extends State<SendRequest> {
  TextEditingController? recieveWallet;
  String asset = "";
  TextEditingController? amount;
  TextEditingController memo = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final Backend _backend = Backend();

  final List<TokenTypeModel> _tokenTypeModelList = [
    TokenTypeModel(
        tokenName: 'SEL',
        imageToken: Image.asset(
          'assets/images/sel-coin-icon.png',
          width: 22,
        )),
    // TokenTypeModel(
    //     tokenName: 'LUY',
    //     imageToken: Image.asset(
    //       'assets/images/rise-coin-icon.png',
    //       width: 22,
    //     )),
  ];

  TokenTypeModel _tokenTypeModel = TokenTypeModel();
  List<DropdownMenuItem<TokenTypeModel>>? _tokenTypeModelDropdownList;
  List<DropdownMenuItem<TokenTypeModel>> _buildTokenTypeModelDropdown(
      List tokenTypeModelList) {
    List<DropdownMenuItem<TokenTypeModel>> items = [];
    for (TokenTypeModel tokenTypeModel in tokenTypeModelList) {
      items.add(DropdownMenuItem(
        value: tokenTypeModel,
        child: Row(
          children: [
            tokenTypeModel.imageToken!,
            const SizedBox(width: 10.0),
            Text(tokenTypeModel.tokenName!),
          ],
        ),
      ));
    }
    return items;
  }

  _onChangetokenTypeModelDropdown(TokenTypeModel? tokenTypeModel) {
    setState(() {
      _tokenTypeModel = tokenTypeModel!;
      asset = _tokenTypeModel.tokenName!;
      amount!.clear();
    });
  }

  GlobalKey<ScaffoldState> globalKey = GlobalKey<ScaffoldState>();

  final formKey = GlobalKey<FormState>();
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;

  void _submitValidate() {
    final form = formKey.currentState;

    if (form!.validate()) {
      form.save();
      _showDialogPassword(context, recieveWallet!, amount!, memo);
    } else {
      setState(() {
        autovalidateMode = AutovalidateMode.always;
      });
    }
  }

  Future<void> _onSubmit() async {
    var _lang = AppLocalizeService.of(context);

    dialogLoading(context);
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        if (kDebugMode) {
          print('Internet connected');
        }
        _backend.response = await PostRequest().sendPayment(
            _passwordController.text,
            recieveWallet!.text,
            asset,
            amount!.text,
            memo.text);
        var responseJson = json.decode(_backend.response!.body);
        if (_backend.response!.statusCode == 200) {
          Navigator.pushAndRemoveUntil(
            context,
            PageTransition(
              type: PageTransitionType.bottomToTop,
              child: const CompletePayment(),
            ),
            ModalRoute.withName('/navbar'),
          );
        } else if (_backend.response!.statusCode == 500) {
          await Components.dialog(
              context,
              textAlignCenter(text: 'Something went wrong. Please try again.'),
              warningTitleDialog());
          Navigator.of(context).pop();
          _passwordController.clear();
        } else {
          await Components.dialog(
              context,
              textAlignCenter(text: responseJson['message']),
              warningTitleDialog());
          Navigator.of(context).pop();
          _passwordController.clear();
        }
      }
    } on SocketException catch (_) {
      await Components.dialog(
          context,
          textAlignCenter(text: _lang.translate('no_internet_message')),
          warningTitleDialog());
      Navigator.of(context).pop();
      _passwordController.clear();
    }
  }

  Future _showDialogPassword(
    BuildContext context,
    TextEditingController recieveWallet,
    TextEditingController amount,
    TextEditingController memo,
  ) {
    var _lang = AppLocalizeService.of(context);
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        // return object of type Dialog
        return WillPopScope(
          onWillPop: () async => false,
          child: AlertDialog(
            // backgroundColor: Col,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0)),
            contentPadding:
                const EdgeInsets.only(left: 10, top: 15, right: 10, bottom: 5),
            title: const Text(
              'Enter Password',
              textAlign: TextAlign.center,
            ),
            content: TextFormField(
              controller: _passwordController,
              onSaved: (val) => _passwordController.text = val!,
              keyboardType: TextInputType.visiblePassword,
              decoration: InputDecoration(
                fillColor: Colors.grey[100],
                filled: true,
                hintText: _lang.translate('password_tf'),
                hintStyle: const TextStyle(color: Colors.black, fontSize: 12.0),
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
              obscureText: true,
            ),
            actions: <Widget>[
              // usually buttons at the bottom of the dialog
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                      style: ButtonStyle(
                        foregroundColor: MaterialStateProperty.all<Color>(
                            HexColor('0CACDA')),
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.white),
                        padding: MaterialStateProperty.all(
                            const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 35)),
                      ),
                      child: const Text('CANCEL'),
                      onPressed: () => {
                            Navigator.of(context).pop(),
                            _passwordController.clear(),
                          }),
                  TextButton(
                      style: ButtonStyle(
                        foregroundColor:
                            MaterialStateProperty.all<Color>(Colors.white),
                        backgroundColor: MaterialStateProperty.all<Color>(
                            HexColor('0CACDA')),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        )),
                        padding: MaterialStateProperty.all(
                            const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 50)),
                      ),
                      child: const Text('OK'),
                      onPressed: () => {
                            Navigator.of(context).pop(),
                            dialogLoading(context),
                            _onSubmit(),
                            Navigator.of(context).pop(),
                          }),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();

    AppServices.noInternetConnection(globalKey);
    recieveWallet = TextEditingController(text: widget.walletKey);
    amount = TextEditingController(text: widget.amount.toString());

    // Value Dropdown
    _tokenTypeModelDropdownList =
        _buildTokenTypeModelDropdown(_tokenTypeModelList);
    _tokenTypeModel = _tokenTypeModelList[0];
    asset = _tokenTypeModel.tokenName!;

    if (widget.assetName == "SEL") {
      _tokenTypeModel = _tokenTypeModelList[0];
      asset = _tokenTypeModel.tokenName!;
    }

    // if (widget.assetName == "LUY") {
    //   _tokenTypeModel = _tokenTypeModelList[1];
    //   asset = _tokenTypeModel.tokenName!;
    // }



  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var _lang = AppLocalizeService.of(context);
    return Scaffold(
      backgroundColor: Colors.white,
      key: globalKey,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.pop(context);
            }),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(
          color: Colors.black, //change your color here
        ),
        title: Text(
          _lang.translate('send_request'),
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
                    // Text(_lang.translate('receive_address')),
                    const SizedBox(height: 10.0),
                    TextFormField(
                      validator: (val) => val!.isEmpty
                          ? _lang.translate('receive_address_validate')
                          : null,
                      onSaved: (val) => recieveWallet!.text = val!,
                      autovalidateMode: AutovalidateMode.always,
                      maxLength: null,
                      controller: recieveWallet,
                      decoration: InputDecoration(
                        prefixIcon:
                            Icon(Icons.contact_page, color: HexColor('0CACDA')),
                        hintText: _lang.translate('receive_address'),
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
                    // Text(_lang.translate('asset')),
                    const SizedBox(height: 10.0),
                    CustomDropdown(
                      dropdownMenuItemList: _tokenTypeModelDropdownList,
                      onChanged: _onChangetokenTypeModelDropdown,
                      value: _tokenTypeModel,
                      isEnabled: true,
                    ),
                    const SizedBox(height: 16.0),
                    // Text(_lang.translate('amount')),
                    const SizedBox(height: 10.0),
                    TextFormField(
                      validator: (val) => val!.isEmpty
                          ? _lang.translate('amount_validate')
                          : null,
                      onSaved: (val) => amount!.text = val!,
                      autovalidateMode: AutovalidateMode.always,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        // _tokenTypeModel == _tokenTypeModelList[0]
                        //     ? FilteringTextInputFormatter.allow(
                        //         RegExp(r'^\d+\.?\d{0,3}'))
                        //     : 
                            FilteringTextInputFormatter.allow(
                                RegExp(r'^\d+\.?\d{0,4}'))
                      ],
                      controller: amount,
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          FontAwesomeIcons.coins,
                          color: primaryColor,
                        ),
                        hintText: _lang.translate('amount'),
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
                    // const Text('Memo'),  
                    const SizedBox(height: 10.0),
                    TextFormField(
                      controller: memo,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.my_library_books,
                            color: HexColor('0CACDA')),
                        hintText: 'Memo (Optional)',
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
                                _submitValidate();
                              },
                              child: Center(
                                child: Text(_lang.translate('send'),
                                    style: const TextStyle(
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
