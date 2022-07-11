import 'package:koompi_hotspot/all_export.dart';

class LangProvider with ChangeNotifier {
  Locale? _manualLocale;
  final StorageServices _prefService = StorageServices();
  String? _lang;

  String? get lang => _lang;

  Locale? get manualLocale => _manualLocale;

  //SET LOCALIZE LANGUAGE
  void setLocal(String? languageCode, context) {
    _lang = languageCode;

    if (_lang == '') {
      saveLang(languageCode, context);
    } else {
      switch (languageCode) {
        case 'KH':
          _manualLocale = const Locale('km', 'KH');
          notifyListeners();
          break;
        case 'EN':
          _manualLocale = const Locale('en', 'US');
          notifyListeners();
          break;
      }
      _prefService.saveString('lang', languageCode);
    }

    notifyListeners();
  }

  //GET SAVE LANGUAGE CODE
  void saveLang(String? languageCode, context) async {
    Locale myLocale = Localizations.localeOf(context);
    if (languageCode! != '') {
      _lang = languageCode;
    } else {
      _lang = myLocale.countryCode!;
    }

    notifyListeners();
  }
}
