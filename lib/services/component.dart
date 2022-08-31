import 'package:http/http.dart' as http;

class Backend {
  Map<String, dynamic> token = {};

  String bodyEncode = "";

  http.Response? response;

  Map<String, dynamic>? mapData;

  List<dynamic>? listData;

  dynamic data;

  Map<String, String> conceteHeader(String key, String value) {
    /* Concete More Content Of Header */
    return key != ''
        ? {
            /* if Parameter != Null = Concete Header With  */
            "Content-Type": "application/json; charset=utf-8",
            key: value
          }
        : {
            /* if Parameter Null = Don't integrate */
            "Content-Type": "application/json; charset=utf-8"
          };
  }
}
