import 'package:koompi_hotspot/all_export.dart';

class RestoreKey extends StatefulWidget {

  final String title;

  const RestoreKey({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  State<RestoreKey> createState() => _RestoreKeyState();
}

class _RestoreKeyState extends State<RestoreKey> {
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
          widget.title,
          style: GoogleFonts.robotoCondensed(
            fontSize: 24,
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },  
        child: _backupKeyPage()
      ),
    );
  }

  Widget _backupKeyPage() {
    return Column(
      
      children: [
        _inputMnemonic(),
        Expanded(child: Container()),
        _getBtnNext(),
      ],
    );
  }


  Widget _inputMnemonic() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const MyText(
            text: "Mnemonic",
            color: "#777777",
            textAlign: TextAlign.start,
            
          ),
          TextField(
            autocorrect: false,
            decoration: InputDecoration(
              focusedBorder: OutlineInputBorder(
                borderRadius: const BorderRadius.all(Radius.circular(12.0)),
                borderSide: BorderSide(color: primaryColor)
              ),
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(12.0)),
              ),
            ),
            maxLines: 5,
          )
        ],
      ),
    );
  }

  Widget _getBtnNext(){
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Center(
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
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                customBorder: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                onTap: () async {
                  
                },
                child: Center(
                  child: Text(
                    'Next',
                    style: GoogleFonts.nunito(
                      textStyle: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                      )
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

}