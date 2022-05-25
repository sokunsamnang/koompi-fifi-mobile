class ApiService {
  // Production API
  static const url = 'https://api-hotspot.koompi.org/api';
  static const getAvatar = 'https://api-hotspot.koompi.org/uploads';
  static const notiImage = 'https://api-hotspot.koompi.org/uploads/noti';

  // Development API
  // static const url = 'https://api-hotspot-dev.koompi.org/api';
  // static const getAvatar = 'https://api-hotspot-dev.koompi.org/uploads';
  // static const notiImage = 'https://api-hotspot-dev.koompi.org/uploads/noti';
}

class ApiHeader {
  static const headers = <String, String>{
    "accept": "application/json",
    "Content-Type": "application/json"
  };
}
