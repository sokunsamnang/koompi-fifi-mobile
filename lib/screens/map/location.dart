import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:koompi_hotspot/utils/app_localization.dart';
import 'package:koompi_hotspot/widgets/reuse_widgets/dialog.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';

class LocationView extends StatefulWidget {
  const LocationView({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return LocationViewState();
  }
}

class LocationViewState extends State<LocationView> with TickerProviderStateMixin {
  LocationData? _currentLocation;
  late final MapController _mapController;

  // final double _outZoom = 3.0;
  final double _inZoom = 15.0;
  final double _maxZoom = 18.0;
  final double _minZoom = 5.0;

  bool _liveUpdate = false;
  bool _permission = false;

  String? serviceError = '';

  var interActiveFlags = InteractiveFlag.all;

  final Location _locationService = Location();

  final PopupController _popupController = PopupController();


  // Marker Map
  final List<LatLng> _latLngList = [
    // S'ang school
    LatLng(11.357523855156012, 105.00719501166897),

    // The Natte
    LatLng(11.55810367571426, 104.91961299234609),
  ];

  List<Marker> _markers = [];

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    initLocationService();
    
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
        

  }

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
        serviceError = e.message;
      } else if (e.code == 'SERVICE_STATUS_ERROR') {
        serviceError = e.message;
      }
      location = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    LatLng currentLatLng;
    var lang = AppLocalizeService.of(context);
    
    // Until currentLocation is initially updated, Widget can locate to 0, 0
    // by default or store previous location value to show.
    if (_currentLocation != null) {
      currentLatLng = LatLng(_currentLocation!.latitude!, _currentLocation!.longitude!);
    } else {
      currentLatLng = LatLng(11.5564, 104.9282);
    }

    var markers = <Marker>[
      Marker(
        width: 50.0,
        height: 50.0,
        point: currentLatLng,
        builder: (ctx) => Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100.0),
            color: Colors.blue[100]?.withOpacity(0.7),
          ),
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
        ),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text(lang.translate('fifi_map'),
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
      body: FlutterMap(
        mapController: _mapController,
        options: MapOptions(
          center: LatLng(currentLatLng.latitude, currentLatLng.longitude),
          zoom: _inZoom,
          maxZoom: _maxZoom,
          minZoom: _minZoom,
          interactiveFlags: InteractiveFlag.pinchZoom | InteractiveFlag.drag,
          plugins: [
            MarkerClusterPlugin(),
          ],
          onTap: (_, markers) => _popupController.hideAllPopups(),
        ),
        layers: [
          TileLayerOptions(
            urlTemplate:
                'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
            subdomains: ['a', 'b', 'c'],
            // For example purposes. It is recommended to use
            // TileProvider with a caching and retry strategy, like
            // NetworkTileProvider or CachedNetworkTileProvider
            tileProvider: NetworkNoRetryTileProvider(),
          ),
          MarkerLayerOptions(markers: markers),
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
                decoration: BoxDecoration(color: primaryColor, shape: BoxShape.circle),
                child: Text('${markers.length}'),
              );
            },
          ),
        ],
      ),
      floatingActionButton: Builder(builder: (BuildContext context) {
        return FloatingActionButton(
          onPressed: () {
            setState(() {
              _liveUpdate = !_liveUpdate;
              ScaffoldMessenger.of(context).hideCurrentSnackBar();

              if (_liveUpdate) {
                interActiveFlags = InteractiveFlag.pinchZoom | InteractiveFlag.drag;

                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('Locked location is enabled.'),
                  behavior: SnackBarBehavior.floating,
                ));
              } else {
                interActiveFlags = InteractiveFlag.pinchZoom | InteractiveFlag.drag;
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('Locked location is disabled.'),
                  behavior: SnackBarBehavior.floating,
                ));
              }
            });
          },
          child: _liveUpdate
              ? const Icon(Icons.location_on)
              : const Icon(Icons.location_off),
        );
      }),
    );
  }
}
