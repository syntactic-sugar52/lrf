import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lrf/helper/ui_helper.dart';

import 'package:lrf/pages/widgets/home/card_widget.dart';
import 'package:lrf/pages/widgets/home/card_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with AutomaticKeepAliveClientMixin {
  List<String> docId = [];
  final GeolocatorPlatform _geolocator = GeolocatorPlatform.instance;
  bool _locationServiceEnabled = false;
  LocationPermission? _permissionStatus;
  LocationPermission? permission;
  bool? serviceEnabled;
//todo: change to service enabled instead
  Position? _currentPosition;
// DataStore? _dataStore;
  Future<void> _determinePosition(BuildContext context) async {
    // _dataStore = Provider.of(context, listen: false);
    // get permission if not provided
    _permissionStatus = await _geolocator.checkPermission();
    // if inital permission denied, request permission
    if (_permissionStatus == LocationPermission.denied) {
      _permissionStatus = await _geolocator.requestPermission();
      // if denied, dont ask again
      if (_permissionStatus == LocationPermission.denied) {
        setState(() {
          _permissionStatus == LocationPermission.denied;
        });
        return Future.error("Location permission denied");
      } else if (_permissionStatus == LocationPermission.deniedForever) {
        setState(() {
          _permissionStatus == LocationPermission.deniedForever;
        });

        showLocationPermissionRequired(context);
        return Future.error('Location permissions are permanently denied');
      }
    } else if (_permissionStatus == LocationPermission.deniedForever) {
      setState(() {
        _permissionStatus == LocationPermission.deniedForever;
      });
      showLocationPermissionRequired(context);
      return Future.error('Location permissions are permanently denied');
    }
    // check access to location service
    _locationServiceEnabled = await _geolocator.isLocationServiceEnabled();
    if (!_locationServiceEnabled) {
      showToast('Warning: Location service is disabled. Please enable it to navigate to your location.');
      return Future.error('Location service is disabled');
    }
    // when permission granted and location service is enabled - get user location and show on map
    _currentPosition = await _geolocator.getCurrentPosition();
    if (_currentPosition != null) {
      setState(() {
        userPosition = _currentPosition;
      });
    } else {
      showToast('Warning: Your location can\'t be detected.');
    }
  }

  Position? userPosition;
  @override
  void initState() {
    super.initState();
    _determinePosition(context);
  }

  @override
  bool get wantKeepAlive => true;

  Future<void> getUsers() async {
    await FirebaseFirestore.instance.collection('request').get().then((snapshot) => snapshot.docs.forEach((element) {
          docId.add(element.reference.id);
        }));
  }

  final ScrollController _scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Center(
        child: ExpandableTheme(
      data: const ExpandableThemeData(
        iconColor: Colors.lightGreenAccent,
        useInkWell: true,
      ),
      //todo: convert to stream
      child: _currentPosition != null
          ? FutureBuilder(
              future: getUsers(),
              builder: (context, snapshot) {
                return ListView.builder(
                  // controller: _scrollController,
                  itemBuilder: ((context, index) {
                    return Card2(
                      documentId: docId[index],
                      currentUserPosition: _currentPosition,
                    );
                  }),
                  itemCount: docId.length,
                  physics: const ClampingScrollPhysics(),
                );
              },
            )
          : const Center(
              child: CircularProgressIndicator(color: Colors.black),
            ),
    ));
  }
}
