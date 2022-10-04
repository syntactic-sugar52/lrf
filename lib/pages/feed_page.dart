import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expandable/expandable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

import 'package:lrf/constants/constants.dart';
import 'package:lrf/main.dart';

import 'package:lrf/pages/contact_us_page.dart';
import 'package:lrf/pages/login_page.dart';
import 'package:lrf/pages/request_page.dart';

import 'package:lrf/pages/widgets/home/card_widget.dart';
import 'package:lrf/provider/authentication.dart';

import 'package:lrf/services/database.dart';
import 'package:lrf/utils/utils.dart';

class FeedPage extends StatefulWidget {
  final User user;
  const FeedPage({Key? key, required this.user}) : super(key: key);

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  String? _currentAddress;
  Position? _currentPosition;
  String? _subAdminArea;
  @override
  void initState() {
    // TODO: implement initState
    _getCurrentPosition();
    super.initState();
  }

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      if (mounted) {
        showSnackBar(context, 'Location services are disabled. Please enable the services');
      }

      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        if (mounted) {
          showSnackBar(context, 'Location permissions are denied');
        }

        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      if (mounted) {
        showSnackBar(context, 'Location permissions are permanently denied, we cannot request permissions.');
      }

      return false;
    }
    return true;
  }

  Future<void> _getCurrentPosition() async {
    final hasPermission = await _handleLocationPermission();
    try {
      if (!hasPermission) return;
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
          _subAdminArea = ' ${place.subAdministrativeArea}';
        });
        String res = await Database().updateUserCollection(
            address: _currentAddress.toString(),
            lat: _currentPosition!.latitude.toString(),
            lng: _currentPosition!.longitude.toString(),
            uid: widget.user.uid.toString());
        sharedPreferences.setString('address', _currentAddress.toString());
        sharedPreferences.setString('subAdminArea', _subAdminArea.toString());

        if (res == "success") {
          print('success');
        } else {
          print('error');
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
        backgroundColor: Colors.green,
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
              accountEmail: Text(widget.user.email.toString()),
              accountName: Text(
                widget.user.displayName.toString(),
                style: const TextStyle(fontSize: 16.0),
              ),
              decoration: BoxDecoration(color: Colors.green.shade900),
            ),
            ListTile(
              leading: const Icon(Icons.contact_mail),
              title: const Text(
                'Contact LR',
                style: TextStyle(fontSize: 14.0),
              ),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => ContactUsPage()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text(
                'Log Out',
                style: TextStyle(fontSize: 14.0),
              ),
              onTap: () async {
                await Authentication.signOut(context: context);
                if (mounted) {
                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const LoginPage()), (route) => false);
                }
              },
            ),
          ],
        ),
      ),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(40.0),
        child: AppBar(
          elevation: 0,
          centerTitle: true,
          title: const Text('Last Resrt',
              style: TextStyle(fontSize: 16, color: Colors.green, fontWeight: FontWeight.bold, letterSpacing: 1, fontFamily: 'Roboto')),
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
                    child: CircularProgressIndicator(
                      color: Colors.green,
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
                            subAdministrativeArea: _subAdminArea.toString(),
                          )),
                    ),
                  ),
                );
              },
            )
          : const SizedBox.shrink(),
    );
  }
}
