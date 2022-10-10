import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expandable/expandable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

import 'package:lrf/constants/constants.dart';

import 'package:lrf/main.dart';

import 'package:lrf/pages/contact_us_page.dart';

import 'package:lrf/pages/general_widgets.dart';
import 'package:lrf/pages/login_page.dart';
import 'package:lrf/pages/request_page.dart';
import 'package:lrf/pages/search_page.dart';

import 'package:lrf/pages/widgets/home/card_widget.dart';
import 'package:lrf/provider/authentication.dart';

import 'package:lrf/services/database.dart';
import 'package:lrf/utils/utils.dart';

class FeedPage extends StatefulWidget {
  const FeedPage({Key? key, required this.user}) : super(key: key);

  final User user;

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  String? _currentAddress;
  Position? _currentPosition;
  final GeolocatorPlatform _geolocator = GeolocatorPlatform.instance;
  bool _locationServiceEnabled = false;
  LocationPermission? _permissionStatus;
  String? _postalCode;
  String? _subAdminArea;
  String? _subLocality;

  @override
  void initState() {
    _getCurrentPosition();
    super.initState();
  }

  Future<bool> getUserLocation(BuildContext context) async {
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
        if (mounted) {
          showLocationPermissionRequired(context);
        }

        return Future.error('Location permissions are permanently denied');
      }
    } else if (_permissionStatus == LocationPermission.deniedForever) {
      setState(() {
        _permissionStatus == LocationPermission.deniedForever;
      });
      if (mounted) {
        showLocationPermissionRequired(context);
      }

      return Future.error('Location permissions are permanently denied');
    }
    // check access to location service
    _locationServiceEnabled = await _geolocator.isLocationServiceEnabled();
    if (!_locationServiceEnabled) {
      try {
        // if location service is not enabled, try to get it enabled
        _currentPosition = await _geolocator.getCurrentPosition();
      } catch (e) {
        if (mounted) {
          showSnackBar(context, 'Warning: Location service is disabled. Please enable it to continue with the app.');
        }

        return Future.error('Location service is disabled');
      }
    } else {
      // when permission granted and location service is enabled - get user location and show on map
      _currentPosition = await _geolocator.getCurrentPosition();
    }

    if (_currentPosition != null) {
      return true;
    } else {
      if (mounted) {
        showSnackBar(context, 'Warning: Your location can\'t be detected.');
      }

      return false;
    }
  }

  Future<void> _getCurrentPosition() async {
    final hasPermission = await getUserLocation(context);
    try {
      if (!hasPermission) {
        StreamSubscription<ServiceStatus> serviceStatusStream = Geolocator.getServiceStatusStream().listen((ServiceStatus status) async {
          bool locationSettingEnabled = await Geolocator.openLocationSettings();
          if (locationSettingEnabled == true) {
            await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high).then((Position position) {
              setState(() => _currentPosition = position);
              _getAddressFromLatLng(_currentPosition!);
            });
          }
        });
      }
      await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high).then((Position position) {
        setState(() => _currentPosition = position);
        _getAddressFromLatLng(_currentPosition!);
      }).catchError((e) {
        debugPrint(e);
      });
    } catch (e) {
      Future.error(e);
      if (mounted) {
        showSnackBar(context, 'Something went wrong');
      }
    }
  }

  Future<void> _getAddressFromLatLng(Position position) async {
    try {
      await placemarkFromCoordinates(_currentPosition!.latitude, _currentPosition!.longitude).then((List<Placemark> placemarks) async {
        Placemark place = placemarks[0];
        setState(() {
          _currentAddress = '${place.street}, ${place.subLocality}, ${place.subAdministrativeArea}, ${place.postalCode}';
          _subAdminArea = '${place.subAdministrativeArea}';
          _subLocality = '${place.subLocality}';
          _postalCode = '${place.postalCode}';
        });
        String res = await Database().updateUserCollection(
            address: _currentAddress.toString(),
            lat: _currentPosition!.latitude.toString(),
            lng: _currentPosition!.longitude.toString(),
            uid: widget.user.uid.toString());
        sharedPreferences.setString('address', _currentAddress.toString());
        sharedPreferences.setString('subAdminArea', _subAdminArea == null ? _subAdminArea.toString() : _subLocality.toString());
        sharedPreferences.setString('postalCOde', _postalCode == null ? _postalCode.toString() : '');
        if (res == "success") {
        } else {
          if (mounted) {
            showSnackBar(context, 'Something went wrong. Try again.');
          }
        }
      }).catchError((e) {
        debugPrint(e);
      });
    } catch (e) {
      Future.error(e);
    }
  }

//todo: change to service enabled instead
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green.shade800,
        highlightElevation: 50,
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const RequestPage()));
        },
        child: const Icon(
          Icons.add,
          size: 28,
          color: kAppBackgroundColor,
        ),
      ),
      drawer: Drawer(
        backgroundColor: kAppBackgroundColor,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              currentAccountPicture: CircleAvatar(
                backgroundImage: NetworkImage(widget.user.photoURL.toString()),
                radius: 14,
              ),
              accountEmail: Text(
                widget.user.email.toString(),
              ),
              accountName: Text(
                widget.user.displayName.toString(),
                style: const TextStyle(
                  fontSize: 16.0,
                ),
              ),
              decoration: BoxDecoration(color: Colors.green.shade900),
            ),
            ListTile(
              leading: const Icon(
                Icons.contact_mail_outlined,
                size: 18,
                color: Colors.green,
              ),
              title: const Text(
                'Contact LR',
                style: TextStyle(
                  fontSize: 14.0,
                ),
              ),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const ContactUsPage()));
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.logout,
                color: Colors.green,
                size: 18,
              ),
              title: const Text(
                'Log Out',
                style: TextStyle(fontSize: 14.0),
              ),
              onTap: () async {
                try {
                  await Authentication.signOut(context: context);
                  if (mounted) {
                    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const LoginPage()), (route) => false);
                  }
                } catch (e) {
                  showSnackBar(context, 'Something went wrong.');
                  Future.error(e);
                }
              },
            ),
          ],
        ),
      ),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(40.0),
        child: AppBar(
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const SearchPage()));
                },
                icon: const Icon(Icons.search))
          ],
          elevation: 0,
          centerTitle: true,
          title: Container(padding: const EdgeInsets.all(5), width: 100, height: 50, child: Image.asset('assets/LRlogo.png')),
          backgroundColor: kAppBackgroundColor,
        ),
      ),
      body: _currentAddress != null
          ? StreamBuilder(
              stream: FirebaseFirestore.instance.collection('posts').snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  // todo: add shimmer loading effect
                  return const Center(
                    child: Hero(
                      tag: 'loading',
                      child: CircularProgressIndicator(
                        color: Colors.green,
                      ),
                    ),
                  );
                }
                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  physics: const ClampingScrollPhysics(),
                  itemBuilder: (ctx, index) => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: ExpandableTheme(
                          data: const ExpandableThemeData(
                            iconColor: Colors.lightGreenAccent,
                            useInkWell: true,
                          ),
                          child: Card2(
                            snap: snapshot.data!.docs[index].data(),
                            user: widget.user,
                            postalCode: _postalCode.toString(),
                            subAdministrativeArea: _subAdminArea.toString(),
                          )),
                    ),
                  ),
                );
              },
            )
          : const Center(
              child: CircularProgressIndicator(
                color: Colors.green,
              ),
            ),
    );
  }
}
