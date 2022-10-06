import 'package:device_info_plus/device_info_plus.dart';
import 'package:koompi_hotspot/all_export.dart';
import 'package:mac_address/mac_address.dart';

class DeviceSession extends StatefulWidget {
  const DeviceSession({Key? key}) : super(key: key);

  @override
  State<DeviceSession> createState() => _DeviceSessionState();
}

class _DeviceSessionState extends State<DeviceSession> {

  String _platformVersion = 'Unknown';


  @override
  void initState() {
    super.initState();
    initPlatformState();

    PostRequest().loginUnifyController().then((value) => {
      GetRequest().getListGuestLogin(),
    });
    Future.delayed(const Duration(seconds: 3), () {
      GetRequest().getListGuestLogin();
    });

    print("_platformVersion $_platformVersion");
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await GetMac.macAddress;

      print("platformVersion $platformVersion");
    } on PlatformException {
      platformVersion = 'Failed to get Device MAC Address.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    print("platformVersion $platformVersion");
    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Device Session"
          ),
        ),
        body: Center(
          child: Text('MAC Address : $_platformVersion\n'),
        ),
      ),
    );
  }
}

