import 'package:koompi_hotspot/all_export.dart';
import 'package:koompi_hotspot/screens/mywallet/wallet_settings/backup_key.dart';
import 'package:koompi_hotspot/screens/mywallet/wallet_settings/restore_key.dart';
import 'package:polkawallet_sdk/polkawallet_sdk.dart';
import 'package:polkawallet_sdk/storage/keyring.dart';

class WalletSettingsPage extends StatefulWidget {
  const WalletSettingsPage({Key? key}) : super(key: key);

  @override
  State<WalletSettingsPage> createState() => _WalletSettingsPageState();
}

class _WalletSettingsPageState extends State<WalletSettingsPage> {

  final WalletSDK sdk = WalletSDK();
  final Keyring keyring = Keyring();


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
        const Padding(
          padding: EdgeInsets.all(20),
          child: MyText(
            text: "Powered By Selendra Chain",
            fontSize: 18,
            color: '#000000',
            fontWeight: FontWeight.w700,
          ),
        )
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
            child: const BackUpKey()
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