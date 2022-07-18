import 'package:koompi_hotspot/all_export.dart';

class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {

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
    return mData.wallet != null
        ? const WalletChoice()
        : const MyWallet(walletKey: '',);
  }
}
