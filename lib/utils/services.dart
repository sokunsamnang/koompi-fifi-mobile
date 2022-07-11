import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:koompi_hotspot/all_export.dart';
import 'package:koompi_hotspot/providers/contact_list_provider.dart';

class StorageServices {
  // static String _decode;
  // static SharedPreferences _preferences;
  // bool status;

  static String removeZero(String number) {
    if (number.startsWith("0")) {
      number = number.replaceRange(0, 1, '');
    }
    return number;
  }

  // void clearPref() async {
  //   SharedPreferences pref = await SharedPreferences.getInstance();
  //   pref.remove('token');
  // }

  checkUser(BuildContext context) async {
    var _lang = AppLocalizeService.of(context);

    const storage = FlutterSecureStorage();
    final String? token = await storage.read(key: "token");

    if (JwtDecoder.isExpired(token) == true || token == '') {
      // clearToken('token');
      deleteAllKeys();
      Navigator.pushAndRemoveUntil(
        context,
        PageTransition(
          type: PageTransitionType.bottomToTop,
          child: const LoginPhone(),
        ),
        ModalRoute.withName('/loginPhone'),
      );
    } else if (JwtDecoder.isExpired(token) == false) {
      try {
        await GetRequest().getUserProfile(token).then((value) async {
          await Provider.of<GetPlanProvider>(context, listen: false).fetchHotspotPlan();
          await Provider.of<NotificationProvider>(context, listen: false).fetchNotification();
          await Provider.of<BalanceProvider>(context, listen: false).fetchPortfolio();
          await Provider.of<TrxHistoryProvider>(context, listen: false).fetchTrxHistory();
          await Provider.of<ContactListProvider>(context, listen: false).fetchContactList();
        });
      }
      //  on SocketException catch (_) {
      //   if (kDebugMode) {
      //     print('No network socket exception');
      //   }
      //   await Components.dialogNoOption(
      //       context,
      //       textAlignCenter(text: _lang.translate('no_internet_message')),
      //       warningTitleDialog());
      // }
       on TimeoutException catch (_) {
        if (kDebugMode) {
          print('Time out exception');
        }
        await Components.dialogNoOption(
            context,
            textAlignCenter(text: _lang.translate('request_timeout')),
            warningTitleDialog());
      } on FormatException catch (_) {
        if (kDebugMode) {
          print('FormatException');
        }
        await Components.dialogNoOption(
            context,
            textAlignCenter(text: _lang.translate('server_error')),
            warningTitleDialog());
      }

      Navigator.pushAndRemoveUntil(
        context,
        PageTransition(
          type: PageTransitionType.rightToLeft,
          child: const Navbar(0),
        ),
        ModalRoute.withName('/navbar'),
      );
    } else {
      Navigator.pushAndRemoveUntil(
        context,
        PageTransition(
          type: PageTransitionType.bottomToTop,
          child: const LoginPhone(),
        ),
        ModalRoute.withName('/loginPhone'),
      );
    }
  }

  void updateUserData(BuildContext context) {
    read('token').then(
      (value) async {
        String? _token = value;
        if (_token != null) {
          await GetRequest().getUserProfile(_token);

          Navigator.pushAndRemoveUntil(
            context,
            PageTransition(
              type: PageTransitionType.bottomToTop,
              child: const Navbar(0),
            ),
            ModalRoute.withName('/navbar'),
          );
        }
      },
    );
  }

  Future<String?> read(String? key) async {
    const storage = FlutterSecureStorage();
    final String? value = await storage.read(key: key!);
    return value;
    // SharedPreferences pref = await SharedPreferences.getInstance();
    // String? value = pref.getString(key!);
    // return value;
  }

  Future<void> saveString(String? key, String? value) async {
    const storage = FlutterSecureStorage();
    await storage.write(key: key!, value: value!);
    // try {
    //   SharedPreferences pref = await SharedPreferences.getInstance();
    //   pref.setString(key!, value!);
    // } catch (e) {
    //   if (kDebugMode) {
    //     print("error saveString $e");
    //   }
    // }
  }

  Future<void> deleteAllKeys() async {
    const storage = FlutterSecureStorage();
    await storage.deleteAll();
  }  

  Future<void> deleteKeys(String? key) async {
    const storage = FlutterSecureStorage();
    await storage.delete(key: key!);
  }  


  // Future<void> clearToken(String? key) async {
  //   SharedPreferences pref = await SharedPreferences.getInstance();
  //   pref.remove(key!);
  // }
}
