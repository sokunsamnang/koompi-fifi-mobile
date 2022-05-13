import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:koompi_hotspot/utils/app_localization.dart';
import 'package:koompi_hotspot/utils/connection.dart';
import 'package:koompi_hotspot/widgets/reuse_widgets/dialog.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';

class MyLocationView extends StatefulWidget {
  const MyLocationView({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return MyLocationViewState();
  }
}

class MyLocationViewState extends State<MyLocationView>
    with TickerProviderStateMixin {
  ///=========================================[Declare]=============================================
  /// Controller for FloatActionButtons
  AnimationController? _controller;

  /// Icons List For FloatActionButtons
  List<IconData> icons = [
    Icons.gps_fixed,
    // Icons.favorite,
    // Icons.content_copy,
  ];

  // final Geolocator geolocator = Geolocator();

  double lat = 0.0;
  double long = 0.0;
  final double _outZoom = 3.0;
  final double _inZoom = 15.0;
  final double _maxZoom = 18.0;
  final double _minZoom = 5.0;
  MapController mapController = MapController();

  /// Is camera Position Lock is enabled default false
  bool isMoving = false;

  final PopupController _popupController = PopupController();

  // Marker Map
  final List<LatLng> _latLngList = [
    // S'ang school
    LatLng(11.357523855156012, 105.00719501166897),

    // The Natte
    LatLng(11.55810367571426, 104.91961299234609),
  ];
  List<Marker> _markers = [];

  // final LocationSettings locationSettings = const LocationSettings(
  //   accuracy: LocationAccuracy.high,
  //   distanceFilter: 100,
  // );

  ///=========================================[initState]=============================================

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    initLocationService();

    AppServices.noInternetConnection(mykey);
    _markers = _latLngList
        .map((point) => Marker(
              point: point,
              width: 50,
              height: 50,
              builder: (context) => Image.asset(
                'assets/images/KOOMPI-Hotspot-Point.png',
              ),
              anchorPos: AnchorPos.align(AnchorAlign.top),
            ))
        .toList();
        
    // setState(() {
    //   if (long == 0.0 || lat == 0.0) {
    //   ///checks GPS then call localize
    //   _checkGPS();
    //   }
    // });

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }

  _moveCamera() {
    isMoving = true;
    if (lat != 0.0 && long != 0.0) {
      mapController.onReady.then((result) {
        mapController.move(LatLng(lat, long), _inZoom);
        icons[0] = Icons.gps_fixed;
      });
    }
  }

  // void _checkGPS() async {
  //   var status = await Geolocator.checkPermission();
  //   bool isGPSOn = await Geolocator.isLocationServiceEnabled();
  //   if (status == LocationPermission.denied && !isGPSOn) {
  //     loc.Location locationR = loc.Location();
  //     locationR.requestService();
  //   } else if (isGPSOn == false) {
  //     loc.Location locationR = loc.Location();
  //     locationR.requestService();
  //   } else {
  //     // localize();
  //     _moveCamera();
  //   }
  // }

  LocationData? _currentLocation;
  late final MapController _mapController;

  bool _liveUpdate = false;
  bool _permission = false;

  String? _serviceError = '';

  var interActiveFlags = InteractiveFlag.all;

  final Location _locationService = Location();


  void initLocationService() async {
    await _locationService.changeSettings(
      accuracy: LocationAccuracy.high,
      interval: 1000,
    );

    LocationData? location;
    bool serviceEnabled;
    bool serviceRequestResult;

    try {
      serviceEnabled = await _locationService.serviceEnabled();

      if (serviceEnabled) {
        var permission = await _locationService.requestPermission();
        _permission = permission == PermissionStatus.granted;

        if (_permission) {
          location = await _locationService.getLocation();
          _currentLocation = location;
          _locationService.onLocationChanged
              .listen((LocationData result) async {
            if (mounted) {
              setState(() {
                _currentLocation = result;

                // If Live Update is enabled, move map center
                if (_liveUpdate) {
                  _mapController.move(
                      LatLng(_currentLocation!.latitude!,
                          _currentLocation!.longitude!),
                      _mapController.zoom);
                }
              });
            }
          });
        }
      } else {
        serviceRequestResult = await _locationService.requestService();
        if (serviceRequestResult) {
          initLocationService();
          return;
        }
      }
    } on PlatformException catch (e) {
      debugPrint(e.toString());
      if (e.code == 'PERMISSION_DENIED') {
        _serviceError = e.message;
      } else if (e.code == 'SERVICE_STATUS_ERROR') {
        _serviceError = e.message;
      }
      location = null;
    }
  }


  // void _checkGPS() async {
  //   var status = await Geolocator.checkPermission();
  //   bool isGPSOn = await Geolocator.isLocationServiceEnabled();
  //   if (status == LocationPermission.denied || !isGPSOn) {
  //     loc.Location locationR = loc.Location();
  //     locationR.requestService();
  //   }
  // }

  // void localize() {
  //   Geolocator.getPositionStream(locationSettings: locationSettings)
  //       .listen((Position position) {
  //     /// To not call setState when this state is not active
  //     if (!mounted) {
  //       return;
  //     }
  //     if (mounted) {
  //       setState(() {
  //         lat = position.latitude;
  //         long = position.longitude;
  //         long = long;
  //         lat = lat;
  //         if (isMoving == true) {
  //           mapController.move(LatLng(lat, long), _inZoom);
  //           icons[0] = Icons.gps_fixed;
  //         }
  //       });
  //     }
  //     print("localize $mounted");
  //   });
  // }

  ///to show a snackBar after copy
  final GlobalKey<ScaffoldState> mykey = GlobalKey<ScaffoldState>();

  ///=========================================[BUILD]=============================================

  @override
  Widget build(BuildContext context) {
    var _lang = AppLocalizeService.of(context);
    LatLng currentLatLng;

    // Until currentLocation is initially updated, Widget can locate to 0, 0
    // by default or store previous location value to show.
    if (_currentLocation != null) {
      currentLatLng = LatLng(_currentLocation!.latitude!, _currentLocation!.longitude!);
    } else {
      currentLatLng = LatLng(11.5564, 104.9282);
    }
    
    Widget _loadBuild() {
      ///[Position Found Render Marker]
      if (lat != 0 && long != 0) {
        return Expanded(
          child: FlutterMap(
            mapController: mapController,
            options: MapOptions(
              interactiveFlags:
                  InteractiveFlag.pinchZoom | InteractiveFlag.drag,
              center: LatLng(lat, long),
              zoom: _inZoom,
              maxZoom: _maxZoom,
              minZoom: _minZoom,
              plugins: [
                MarkerClusterPlugin(),
              ],
              onTap: (_, markers) => _popupController.hideAllPopups(),
            ),
            layers: [
              TileLayerOptions(
                  urlTemplate:
                      "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                  subdomains: ['a', 'b', 'c']),
              MarkerLayerOptions(
                markers: [
                  ///========[Live Location]==========
                  Marker(
                    width: 50.0,
                    height: 50.0,
                    point: LatLng(lat, long),
                    builder: (ctx) => Container(
                      child: Column(
                        children: const <Widget>[
                          IconButton(
                              icon: Icon(
                                Icons.adjust,
                                color: Colors.blue,
                              ),
                              onPressed: null),
                        ],
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100.0),
                        color: Colors.blue[100]?.withOpacity(0.7),
                      ),
                    ),
                  ),
                ],
              ),
              MarkerClusterLayerOptions(
                maxClusterRadius: 190,
                disableClusteringAtZoom: 16,
                size: const Size(50, 50),
                fitBoundsOptions: const FitBoundsOptions(
                  padding: EdgeInsets.all(50),
                ),
                markers: _markers,
                polygonOptions: const PolygonOptions(
                    borderColor: Colors.transparent,
                    color: Colors.transparent,
                    borderStrokeWidth: 0.0),
                popupOptions: PopupOptions(
                    popupSnap: PopupSnap.markerTop,
                    popupController: _popupController,
                    popupBuilder: (_, marker) => Container()),
                builder: (context, markers) {
                  return Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: primaryColor, shape: BoxShape.circle),
                    child: Text('${markers.length}'),
                  );
                },
              ),
            ],
          ),
        );
      } else {
        setState(() {
          icons[0] = Icons.gps_not_fixed;
        });

        ///[Position Not Found/Not Found yet]
        return Expanded(
          child: FlutterMap(
            mapController: mapController,
            options: MapOptions(
              interactiveFlags: InteractiveFlag.pinchZoom | InteractiveFlag.drag,
              center: LatLng(11.5564, 104.9282),
              zoom: _outZoom,
              minZoom: _minZoom,
              maxZoom: _maxZoom
            ),
            layers: [
              TileLayerOptions(
                  urlTemplate:
                      "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                  subdomains: ['a', 'b', 'c']),
            ],
          ),
        );
      }
    }

    ///Float Action Button Background Color
    Color backgroundColor = Theme.of(context).cardColor;
    Color foregroundColor = Theme.of(context).colorScheme.secondary;

    /// Show Snack Bar Messages
    _showSnackBar(String message) {
      final snackBar = SnackBar(
          content: Text(message), duration: const Duration(seconds: 1));

      // ignore: deprecated_member_use
      mykey.currentState?.showSnackBar(snackBar);
    }

    /// returned build
    return Scaffold(
      key: mykey,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text(_lang.translate('fifi_map'),
          style: GoogleFonts.robotoCondensed(
            textStyle: const TextStyle(
              color: Colors.black,
              fontStyle: FontStyle.italic,
              fontSize: 24,
              fontWeight: FontWeight.w700,
            )
          ),
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(
          color: Colors.black, //change your color here
        ),
      ),
      body: Column(
        children: <Widget>[
          _loadBuild(),
        ],
      ),

      ///floatingActionButtons
      floatingActionButton: FloatingActionButton(
        heroTag: null,
        backgroundColor: backgroundColor,
        mini: false,
        child: Icon(
          icons[0],
          color: foregroundColor,
        ),
        onPressed: () {
          ///onPress LockCamera button
          if (isMoving == false) {
            /// if position not null [LatLng]
            if (lat != 0.0 && long != 0.0) {
              setState(() {
                ///change icon to lockedCamera
                icons[0] = Icons.gps_fixed;
                isMoving = true;
              });
              mapController.move(LatLng(lat, long), _inZoom);
              _showSnackBar(_lang.translate('lock_camera'));
            } else {
              _showSnackBar(_lang.translate('no_position'));
            }
          } else {
            setState(() {
              icons[0] = Icons.gps_not_fixed;
              isMoving = false;
            });

            _showSnackBar(_lang.translate('unlock_camera'));
          }
        },
      ),
    );
  }
}
