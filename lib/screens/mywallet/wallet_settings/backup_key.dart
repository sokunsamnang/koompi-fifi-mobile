import 'package:koompi_hotspot/all_export.dart';

class BackUpKey extends StatefulWidget {
  const BackUpKey({Key? key}) : super(key: key);

  @override
  State<BackUpKey> createState() => _BackUpKeyState();
}

class _BackUpKeyState extends State<BackUpKey> {
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
          'Backup',
          style: GoogleFonts.robotoCondensed(
            fontSize: 24,
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
      ),
      body: _backupKeyPage(),
    );
  }

  Widget _backupKeyPage() {
    return Column(
      children: [
        _getContent(),
        _getBackupKey(),
      ],
    );
  }

  Widget _getContent() {
    return const Padding(
      padding: EdgeInsets.all(20.0),
      child: MyText(
        text: "Write these words down on paper, Keep the backup paper safe. These words allows anyone to recover this account and access its funds.",
        color: "#777777",
        fontSize: 14,
        textAlign: TextAlign.start,
        
      ),
    );
  }

  Widget _getBackupKey() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          GestureDetector(
            onTap: () {
              print("On Tap Copy");
            },
            child: const MyText(
              text: "Copy",
              color: "#0CACDA",
              fontSize: 14,
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              border: Border.all(color: primaryColor.withOpacity(0.8)),
              borderRadius: BorderRadius.circular(12),
              color: Colors.white,
            ),
            child: Container(
              child: const MyText(
                text: "Seed Phrase is the ONLY way to recover your funds if you lose access to your wallet.",
                color: '#777777',
                fontSize: 14,
                textAlign: TextAlign.start,
              ),
              padding: const EdgeInsets.all(12),
            ),
          )
        ],
      ),
    );
  }

}