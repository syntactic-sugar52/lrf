import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expandable/expandable.dart';
import 'package:fade_shimmer/fade_shimmer.dart';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

import 'package:lrf/constants/constants.dart';

import 'package:lrf/main.dart';

import 'package:lrf/pages/general_widgets.dart';
import 'package:lrf/pages/login_page.dart';

import 'package:lrf/pages/search_page.dart';

import 'package:lrf/pages/widgets/home/card_widget.dart';
import 'package:lrf/provider/authentication.dart';

import 'package:lrf/services/database.dart';
import 'package:lrf/utils/utils.dart';

import 'package:random_avatar/random_avatar.dart';

class FeedPage extends StatefulWidget {
  const FeedPage({
    Key? key,
  }) : super(key: key);

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> with AutomaticKeepAliveClientMixin<FeedPage> {
  Map<String, dynamic>? currentUser;
  String? currentUserId;
  String? currentUserPhotoUrl;
  late Database db;
  String? email;
  String? username;

  String? _country;
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
    db = Database();
    currentUserId = sharedPreferences.getString('currentUserUid');
    username = sharedPreferences.getString('currentUserName');
    currentUserPhotoUrl = sharedPreferences.getString('currentUserPhotoUrl');
    email = sharedPreferences.getString('currentUserEmail');
    _getCurrentPosition();
    getUser(currentUserId.toString());
    super.initState();
  }

  @override
  bool get wantKeepAlive => true;

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

        if (mounted) {
          showLocationPermissionRequired(context);
        }
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
        return Future.error('Location service is disabled');
      }
    } else {
      // when permission granted and location service is enabled - get user location
      _currentPosition = await _geolocator.getCurrentPosition();
    }

    if (_currentPosition != null) {
      return true;
    } else {
      _geolocator.getServiceStatusStream().listen((ServiceStatus status) async {
        switch (status) {
          case ServiceStatus.enabled:
            _currentPosition = await _geolocator.getCurrentPosition();
            break;
          case ServiceStatus.disabled:
            if (mounted) {
              showSnackBar(context, 'Warning: Location service is disabled. Please enable it to continue with the app.');
            }
            break;
        }
      });
      if (mounted) {
        showSnackBar(context, 'Warning: Your location can\'t be detected.');
      }
      return false;
    }
  }

  Future<Map<String, dynamic>> getUser(String currentUserId) async {
    var details = await db.getUserDetails(uid: currentUserId);
    setState(() {
      currentUser = details;
    });

    return currentUser ?? {};
  }

  Future<void> _getCurrentPosition() async {
    final hasPermission = await getUserLocation(context);

    try {
      if (!hasPermission) {
        Position? position = await _geolocator.getLastKnownPosition();
        if (mounted) {
          setState(() {
            _currentPosition = position;
          });
          _getAddressFromLatLng(_currentPosition!);
        }
      }
      await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.bestForNavigation).then((Position position) {
        setState(() {
          _currentPosition = position;
        });
        _getAddressFromLatLng(_currentPosition!);
      }).catchError((e) {
        Future.error(e);
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
          _currentAddress = '${place.street}, ${place.subLocality}, ${place.subAdministrativeArea}, ${place.postalCode},${place.country}';
          _subAdminArea = '${place.subAdministrativeArea}';
          _subLocality = '${place.subLocality}';
          _postalCode = '${place.postalCode}';
          _country = '${place.country}';
        });

        String res = await db.updateUserCollection(
            address: _currentAddress.toString(),
            lat: _currentPosition!.latitude.toString(),
            lng: _currentPosition!.longitude.toString(),
            uid: currentUserId!);
        sharedPreferences.setString('address', _currentAddress.toString());
        sharedPreferences.setString('subAdminArea', _subAdminArea == null ? _subAdminArea.toString() : _subLocality.toString());
        sharedPreferences.setString('postalCode', _postalCode == null ? _postalCode.toString() : '');
        sharedPreferences.setString('country', _country ?? '');
        if (res == "success") {
          return;
        } else {
          if (mounted) {
            showSnackBar(context, 'Something went wrong. Try again.');
          }
        }
      }).catchError((e) {
        Future.error(e);
      });
    } catch (e) {
      Future.error(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.green.shade800,
          highlightElevation: 50,
          elevation: 8,
          onPressed: () => Navigator.pushNamed(context, '/post'),
          child: const Icon(
            Icons.add,
            size: 30,
            color: kAppBackgroundColor,
          ),
        ),
        drawer: Drawer(
            backgroundColor: kAppBackgroundColor,
            child: ListView(padding: EdgeInsets.zero, children: [
              UserAccountsDrawerHeader(
                currentAccountPicture: randomAvatar(currentUser?['photoUrl'] ?? currentUserPhotoUrl),
                accountEmail: Text(
                  email ?? currentUser?['email'],
                ),
                accountName: Text(
                  username ?? currentUser?['displayName'],
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
                onTap: () => Navigator.pushNamed(context, '/contactUs'),
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
                      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const LoginPage()));
                    }
                  } catch (e) {
                    if (mounted) {
                      showSnackBar(context, 'Something went wrong.');
                    }

                    Future.error(e);
                  }
                },
              )
            ])),
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(40.0),
          child: AppBar(
            actions: [
              IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SearchPage(
                                  currentUser: currentUser,
                                  currentUserId: currentUserId,
                                )));
                  },
                  icon: const Icon(Icons.search))
            ],
            centerTitle: true,
            title: Container(padding: const EdgeInsets.all(5), width: 100, height: 50, child: Image.asset('assets/LRlogo.png')),
            backgroundColor: kAppBackgroundColor,
          ),
        ),
        body: _currentAddress != null
            ? StreamBuilder(
                stream: FirebaseFirestore.instance.collection('posts').orderBy('datePublished', descending: true).snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: Hero(
                        tag: 'loading',
                        child: CircularProgressIndicator(
                          color: Colors.greenAccent,
                          backgroundColor: Colors.green,
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
                              user: currentUser,
                              postalCode: _postalCode.toString(),
                              country: _country.toString(),
                              subAdministrativeArea: _subAdminArea.toString(),
                            )),
                      ),
                    ),
                  );
                },
              )
            : Center(
                child: ListView.separated(
                  itemBuilder: (_, i) {
                    final delay = (i * 300);
                    return Container(
                      decoration: BoxDecoration(color: const Color(0xff242424), borderRadius: BorderRadius.circular(4)),
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      padding: const EdgeInsets.all(18),
                      child: Row(
                        children: [
                          FadeShimmer.round(
                            size: 40,
                            fadeTheme: FadeTheme.dark,
                            millisecondsDelay: delay,
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              FadeShimmer(
                                height: 8,
                                width: 150,
                                radius: 4,
                                millisecondsDelay: delay,
                                fadeTheme: FadeTheme.dark,
                              ),
                              const SizedBox(
                                height: 6,
                              ),
                              FadeShimmer(
                                height: 8,
                                millisecondsDelay: delay,
                                width: 170,
                                radius: 4,
                                fadeTheme: FadeTheme.dark,
                              ),
                            ],
                          )
                        ],
                      ),
                    );
                  },
                  itemCount: 20,
                  separatorBuilder: (_, __) => const SizedBox(
                    height: 16,
                  ),
                ),
              ));
  }
}
