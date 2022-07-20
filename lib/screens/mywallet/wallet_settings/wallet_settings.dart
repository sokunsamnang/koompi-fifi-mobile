import 'package:koompi_hotspot/all_export.dart';
import 'package:koompi_hotspot/screens/confirm_password/confirm_password.dart';
import 'package:koompi_hotspot/screens/mywallet/wallet_settings/restore_key.dart';

class WalletSettingsPage extends StatefulWidget {
  const WalletSettingsPage({Key? key}) : super(key: key);

  @override
  State<WalletSettingsPage> createState() => _WalletSettingsPageState();
}

class _WalletSettingsPageState extends State<WalletSettingsPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Iconsax.arrow_left_2, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Settings',
          style: GoogleFonts.robotoCondensed(
            fontSize: 24,
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
      ),
      body: _getSetting(),
    );
  }

  Widget _getSetting(){
    return Column(
      children: [
        _getBackupKey(),
        _getRestoreKey(),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const MyText(
              text: "Powerd By",
              color: "#000000",
              fontSize: 18,
            ),
            Image.asset("assets/images/sld.png", width: 25, height: 25),
            const MyText(
              text: "Selendra Chain",
              color: "#000000",
              fontSize: 18,
            ),
          ],
        ),
      ],
    );
  }

  Widget _getBackupKey(){
    return GestureDetector(
      onTap: (){
        Navigator.push(
          context,
          PageTransition(
            type: PageTransitionType.bottomToTop,
            child: const ConfirmPassword()
          )
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            border: Border.all(color: primaryColor.withOpacity(0.8)),
            borderRadius: BorderRadius.circular(12),
            color: Colors.white,
          ),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.8),
                  borderRadius: const BorderRadius.only(topRight: Radius.circular(10), topLeft: Radius.circular(10))
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    MyText(
                      text: 'Backup',
                      color: '#000000',
                      fontWeight: FontWeight.w600,
                    ),
                    Icon(
                      Iconsax.arrow_right_3,
                      color: Colors.black,
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(12),
              ),
              Container(
                child: const MyText(
                  text: "Your 12-word/24-word Seed Phrase is the ONLY way to recover your funds if you lose access to your wallet.",
                  color: '#777777',
                  fontSize: 14,
                  textAlign: TextAlign.start,
                ),
                padding: const EdgeInsets.all(12),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _getRestoreKey(){
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          PageTransition(
            type: PageTransitionType.bottomToTop,
            child: const RestoreKey(title: "Restore",)
          )
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            border: Border.all(color: primaryColor.withOpacity(0.8)),
            borderRadius: BorderRadius.circular(12),
            color: Colors.white,
          ),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.8),
                  borderRadius: const BorderRadius.only(topRight: Radius.circular(10), topLeft: Radius.circular(10))
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    MyText(
                      text: 'Restore Wallet',
                      color: '#000000',
                      fontWeight: FontWeight.w600,
                    ),
                    Icon(
                        Iconsax.arrow_right_3,
                        color: Colors.black,
                      ),
                  ],
                ),
                padding: const EdgeInsets.all(12),
              ),
              Container(
                child: const MyText(
                  text: "Overwrite your current Mobile wallet using a Seed Phrase.",
                  color: '#777777',
                  fontSize: 14,
                  textAlign: TextAlign.start,
                ),
                padding: const EdgeInsets.all(12),
              )
            ],
          ),
        ),
      ),
    );
  }

}