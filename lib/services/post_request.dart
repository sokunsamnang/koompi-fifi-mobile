import 'dart:typed_data';

import 'package:koompi_hotspot/all_export.dart';
import 'package:http/http.dart' as http;

class PostRequest with ChangeNotifier {
  final Backend _backend = Backend();
  final _mUser = ModelUserData();
  ModelUserData get mUser => _mUser;
  String? alertText;
  final StorageServices _prefService = StorageServices();

  // Add contact address
  Future<http.Response> postContactAddress(String username, String address) async {
    
    await _prefService.read('token').then((value) {
      _backend.token = Map<String, dynamic>.from({'token': value});
    });

    _backend.bodyEncode = json.encode({
      /* Convert to Json String */
      "contact_name": username,
      "contact_wallet": address
    });

    _backend.response = await http.post(
      Uri.parse('${ApiService.url}/contactlist'),
      headers: _backend.conceteHeader("authorization", "Bearer ${_backend.token['token']}"),
      body: _backend.bodyEncode
    );

    if (kDebugMode) {
      print(_backend.response!.body);
    }
    return _backend.response!;
  }

  Future<http.Response> putContactAddress(String id, String username, String address) async {

    await _prefService.read('token').then((value) {
      _backend.token = Map<String, dynamic>.from({'token': value});
    });

    _backend.bodyEncode = json.encode({
      /* Convert to Json String */
      "id": id,
      "contact_name": username,
      "contact_wallet": address
    });

    _backend.response = await http.put(
      Uri.parse('${ApiService.url}/contactlist'),
      headers: _backend.conceteHeader("authorization", "Bearer ${_backend.token['token']}"),
      body: _backend.bodyEncode
    );

    if (kDebugMode) {
      print(_backend.response!.body);
    }
    return _backend.response!;
  }

  Future<http.Response> deleteContactAddress(int id) async {

    await _prefService.read('token').then((value) {
      _backend.token = Map<String, dynamic>.from({'token': value});
    });

    _backend.bodyEncode = json.encode({
      /* Convert to Json String */
      "id": id,
    });

    _backend.response = await http.delete(
      Uri.parse('${ApiService.url}/contactlist'),
      headers: _backend.conceteHeader("authorization", "Bearer ${_backend.token['token']}"),
      body: _backend.bodyEncode
    );

    if (kDebugMode) {
      print(_backend.response!.body);
    }
    return _backend.response!;
  }


  /*Login Account With Phone Number */

  Future<http.Response> userLogInPhone(String phone, String password) async {
    _backend.bodyEncode = json.encode({
      /* Convert to Json String */
      "phone": '+855$phone',
      "password": password
    });

    _backend.response = await http.post(
        Uri.parse('${ApiService.url}/auth/login-phone'),
        headers: _backend.conceteHeader('', ''),
        body: _backend.bodyEncode);

    if (kDebugMode) {
      print(_backend.response!.body);
    }
    return _backend.response!;
  }

  Future<http.Response> logInPhone(String phone, String password) async {
    _backend.bodyEncode = json.encode({
      /* Convert to Json String */
      "phone": phone,
      "password": password
    });

    _backend.response = await http.post(
        Uri.parse('${ApiService.url}/auth/login-phone'),
        headers: _backend.conceteHeader('', ''),
        body: _backend.bodyEncode);

    if (kDebugMode) {
      print(_backend.response!.body);
    }
    return _backend.response!;
  }

  /* complete User Information */
  Future<http.Response> completeInfoUser(String fullname, String phone,
      String gender, String birthdate, String address) async {
    _backend.bodyEncode = json.encode(/* Convert to Json Data ( String ) */
        {
      "fullname": fullname,
      "gender": gender,
      "phone": phone,
      "email": "",
      "birthdate": birthdate,
      "address": address,
    });
    _backend.response = await http.put(
        Uri.parse('${ApiService.url}/auth/complete-info'),
        headers: _backend.conceteHeader('', ''),
        body: _backend.bodyEncode);
    return _backend.response!;
  }

  /* one signal alert notification id Information */
  Future<http.Response> addOnesignalId(String? token, String? playerid) async {
    _backend.bodyEncode = json.encode({
      /* Convert to Json String */
      "player_id": playerid,
    });

    _backend.response = await http.put(
      Uri.parse('${ApiService.url}/alert-notification'),
      headers: _backend.conceteHeader("authorization", "Bearer $token"),
      body: _backend.bodyEncode
    );

    if (kDebugMode) {
      print(_backend.response!.body);
    }
    return _backend.response!;
  }

  /* Update User Information */
  Future<http.Response> updateInfo(String name, String gender, String phone,
      String birthdate, String address) async {
    _backend.bodyEncode = json.encode(/* Convert to Json Data ( String ) */
        {
      "fullname": name,
      "gender": gender,
      "phone": phone,
      "email": "",
      "birthdate": birthdate,
      "address": address
    });
    _backend.response = await http.put(
        Uri.parse('${ApiService.url}/auth/complete-info'),
        headers: _backend.conceteHeader('', ''),
        body: _backend.bodyEncode);
    return _backend.response!;
  }

  /*register account by phone number */
  Future<http.Response> signUpWithPhone(String phone, String password) async {
    _backend.bodyEncode = json.encode({
      /* Convert to Json String */
      "phone": '+855$phone',
      "password": password
    });

    _backend.response = await http.post(
        Uri.parse('${ApiService.url}/auth/register-phone'),
        headers: _backend.conceteHeader('', ''),
        body: _backend.bodyEncode);

    if (kDebugMode) {
      print(_backend.response!.body);
    }
    return _backend.response!;
  }

  // Confirm User Account By Phone Number
  Future<http.Response> confirmAccountPhone(String phone, String vCode) async {
    _backend.bodyEncode = json.encode({"phone": "+855$phone", "vCode": vCode});
    _backend.response = await http.post(
      Uri.parse('${ApiService.url}/auth/confirm-phone'),
      headers: _backend.conceteHeader('', ''),
    );
    if (kDebugMode) {
      print(_backend.response!.body);
    }
    return _backend.response!;
  }

  /*Forgot Password Verification */
  Future<http.Response> forgotPasswordByPhone(String phone) async {
    _backend.bodyEncode = json.encode({
      /* Convert to Json String */
      "phone": "+855$phone",
    });

    _backend.response = await http.post(
        Uri.parse('${ApiService.url}/forgot-password-phone'),
        headers: _backend.conceteHeader('', ''),
        body: _backend.bodyEncode);

    if (kDebugMode) {
      print(_backend.response!.body);
    }
    return _backend.response!;
  }

  //Hotspot Plan
  Future<http.Response> buyHotspotPlan(String phone, String password, String value, String memo) async {
    await _prefService.read('token').then((value) {
      _backend.token = Map<String, dynamic>.from({'token': value});
    });

    _backend.bodyEncode = json.encode({
      /* Convert to Json String */
      "phone": phone,
      "password": password,
      "simultaneous": "1",
      "value": value,
      "asset": "SEL",
      "memo": memo
    });

    _backend.response = await http.post(
        Uri.parse('${ApiService.url}/hotspot/set-plan'),
        headers: _backend.conceteHeader(
            "authorization", "Bearer ${_backend.token['token']}"),
        body: _backend.bodyEncode);

    if (kDebugMode) {
      print(_backend.response!.body);
    }
    return _backend.response!;
  }

  Future<http.Response> sendPayment(String password, String dest, String asset,
      String amount, String memo) async {
    await _prefService.read('token').then((value) {
      _backend.token = Map<String, dynamic>.from({'token': value});
    });

    _backend.bodyEncode = json.encode({
      /* Convert to Json String */
      "password": password,
      "dest_wallet": dest,
      "asset": asset,
      "amount": amount,
      "memo": memo
    });

    _backend.response = await http.post(
        Uri.parse('${ApiService.url}/selendra/transfer'),
        headers: _backend.conceteHeader(
            "authorization", "Bearer ${_backend.token['token']}"),
        body: _backend.bodyEncode);

    if (kDebugMode) {
      print(_backend.response!.body);
    }
    return _backend.response!;
  }

  Future<http.Response> changePlanHotspot(String password, String value) async {
    await _prefService.read('token').then((value) {
      _backend.token = Map<String, dynamic>.from({'token': value});
    });

    _backend.bodyEncode = json.encode({
      /* Convert to Json String */
      "password": password,
      "value": value
    });

    _backend.response = await http.put(
        Uri.parse('${ApiService.url}/hotspot/change-plan'),
        headers: _backend.conceteHeader(
            "authorization", "Bearer ${_backend.token['token']}"),
        body: _backend.bodyEncode);

    if (kDebugMode) {
      print(_backend.response!.body);
    }
    return _backend.response!;
  }

  Future<http.Response> renewPlanHotspot(String password) async {
    await _prefService.read('token').then((value) {
      _backend.token = Map<String, dynamic>.from({'token': value});
    });

    _backend.bodyEncode = json.encode({
      /* Convert to Json String */
      "password": password,
    });

    _backend.response = await http.put(
        Uri.parse('${ApiService.url}/hotspot/renew'),
        headers: _backend.conceteHeader(
            "authorization", "Bearer ${_backend.token['token']}"),
        body: _backend.bodyEncode);

    if (kDebugMode) {
      print(_backend.response!.body);
    }
    return _backend.response!;
  }

  Future<http.Response> renewOption(bool automatically) async {
    await _prefService.read('token').then((value) {
      _backend.token = Map<String, dynamic>.from({'token': value});
    });

    _backend.bodyEncode = json.encode({
      /* Convert to Json String */
      "automatically": automatically,
    });

    _backend.response = await http.put(
        Uri.parse('${ApiService.url}/hotspot/auto'),
        headers: _backend.conceteHeader(
            "authorization", "Bearer ${_backend.token['token']}"),
        body: _backend.bodyEncode);

    if (kDebugMode) {
      print(_backend.response!.body);
    }
    return _backend.response!;
  }

  Future<http.Response> upVoteAdsPost(String? id) async {
    await _prefService.read('token').then((value) {
      _backend.token = Map<String, dynamic>.from({'token': value});
    });

    _backend.bodyEncode = json.encode({
      /* Convert to Json String */
      "id": id,
      "vote": "Voted Up"
    });

    _backend.response = await http.post(
        Uri.parse('${ApiService.url}/ads/upvote-ads'),
        headers: _backend.conceteHeader(
            "authorization", "Bearer ${_backend.token['token']}"),
        body: _backend.bodyEncode);

    if (kDebugMode) {
      print(_backend.response!.body);
    }
    return _backend.response!;
  }

  Future<http.Response> downVoteAdsPost(String? id) async {
    await _prefService.read('token').then((value) {
      _backend.token = Map<String, dynamic>.from({'token': value});
    });

    _backend.bodyEncode = json.encode({
      /* Convert to Json String */
      "id": id,
      "vote": "Voted Down"
    });

    _backend.response = await http.post(
        Uri.parse('${ApiService.url}/ads/downvote-ads'),
        headers: _backend.conceteHeader(
            "authorization", "Bearer ${_backend.token['token']}"),
        body: _backend.bodyEncode);

    if (kDebugMode) {
      print(_backend.response!.body);
    }
    return _backend.response!;
  }

  Future<http.Response> unVoteAdsPut(String? id) async {
    await _prefService.read('token').then((value) {
      _backend.token = Map<String, dynamic>.from({'token': value});
    });

    _backend.bodyEncode = json.encode({
      /* Convert to Json String */
      "id": id,
      "vote": "Un Voted"
    });

    _backend.response = await http.put(
        Uri.parse('${ApiService.url}/ads/unvote-ads'),
        headers: _backend.conceteHeader(
            "authorization", "Bearer ${_backend.token['token']}"),
        body: _backend.bodyEncode);

    if (kDebugMode) {
      print(_backend.response!.body);
    }
    return _backend.response!;
  }

  // Upload Fil Image To Get Url Image
  Future<String> upLoadImage(File _image) async {
    await _prefService.read('token').then((value) {
      _backend.token = Map<String, dynamic>.from({'token': value});
    });
    /* Compress image file */
    Uint8List? compressImage = await FlutterImageCompress.compressWithFile(
      _image.path,
      minHeight: 900,
      minWidth: 600,
      quality: 100,
    );
    /* Make request */

    var request = http.MultipartRequest(
        'POST', Uri.parse('${ApiService.url}/upload-avatar'));
    request.headers['Authorization'] = "Bearer ${_backend.token['token']}";
    /* Make Form of Multipart */
    var multipartFile = http.MultipartFile.fromBytes(
      'file',
      compressImage!,
      filename: 'image_picker.jpg',
      contentType: MediaType.parse('image/jpeg'),
    );
    request.files.add(multipartFile);
    /* Start send to server */
    String? imageUrl;
    try {
      var r = await request.send();
      imageUrl = await r.stream.bytesToString();
    } catch (e) {
      // print(e);
    }
    return imageUrl!;
  }
}

