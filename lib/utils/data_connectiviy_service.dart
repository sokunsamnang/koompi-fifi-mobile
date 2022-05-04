import 'package:koompi_hotspot/all_export.dart';

class DataConnectivityService {
  StreamController<InternetConnectionStatus> connectivityStreamController = StreamController<InternetConnectionStatus>();
  DataConnectivityService() {
    InternetConnectionChecker().onStatusChange.listen((dataConnectionStatus) {
      connectivityStreamController.add(dataConnectionStatus);
    });
  }
}
