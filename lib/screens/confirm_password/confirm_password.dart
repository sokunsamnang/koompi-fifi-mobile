import 'package:koompi_hotspot/all_export.dart';
import 'package:koompi_hotspot/screens/mywallet/wallet_settings/backup_key.dart';

class ConfirmPassword extends StatefulWidget {
  
  final TextEditingController? confirmPasswordController;

  const ConfirmPassword({
    Key? key,
    this.confirmPasswordController,
  }) : super(key: key);

  @override
  State<ConfirmPassword> createState() => _ConfirmPasswordState();
}

class _ConfirmPasswordState extends State<ConfirmPassword> {

  @override
  Widget build(BuildContext context) {
    var lang = AppLocalizeService.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Iconsax.arrow_left_2, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.only(left: 28.0, right: 28.0, top: 40.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: Image.asset("assets/images/security.png"),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Center(
                      child: Text(
                        'Confirm the password for view backup key!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Medium',
                          fontSize: 23,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 25,
                ),

                TextFormField(
                  validator: (val) {
                    if (val!.isEmpty) {
                      return lang.translate('password_is_required_validate');
                    }
                    if (val.length < 6) {
                      return lang.translate('password_too_short_validate');
                    }
                    if (val != widget.confirmPasswordController!.text) {
                      return lang.translate('password_does_not_match_validate');
                    }
                    return null;
                  },
                  onSaved: (val) => widget.confirmPasswordController!.text = val!,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: widget.confirmPasswordController,
                  keyboardType: TextInputType.visiblePassword,
                  decoration: InputDecoration(
                    fillColor: Colors.grey[100],
                    filled: true,
                    prefixIcon: Icon(Iconsax.key, color: primaryColor),
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
                    disabledBorder: OutlineInputBorder(
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
                    hintText: lang.translate('password_tf'),
                    hintStyle: const TextStyle(color: Colors.black, fontSize: 12.0),
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: InkWell(
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                            colors: [Color(0xFF17ead9), Color(0xFF6078ea)]),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          customBorder: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              PageTransition(
                                type: PageTransitionType.bottomToTop,
                                child: const BackUpKey()
                              )
                            );
                          },
                          child: 
                          const Center(
                            child: Text(
                              'Confirm',
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: "Poppins-Bold",
                                fontSize: 18,
                                letterSpacing: 1.0
                              )
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}