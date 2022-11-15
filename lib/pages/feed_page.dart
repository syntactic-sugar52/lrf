import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import 'package:lrf/main.dart';
import 'package:lrf/models/push_notification_model.dart';
import 'package:lrf/pages/request_page.dart';

import 'package:lrf/pages/tabs/all_tab.dart';
import 'package:lrf/pages/tabs/antique_tab.dart';
import 'package:lrf/pages/tabs/art_tab.dart';
import 'package:lrf/pages/tabs/my_posts.dart';
import 'package:lrf/pages/tabs/others_tab.dart';
import 'package:lrf/pages/tabs/watches_tab.dart';
import 'package:lrf/pages/widgets/notification_badge.dart';

import 'package:lrf/provider/authentication.dart';
import 'package:lrf/root.dart';

import 'package:lrf/services/database.dart';
import 'package:lrf/utils/utils.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';

import 'package:random_avatar/random_avatar.dart';

Future _firebaseMessagingBackgroundHandler(RemoteMessage message) async {}

class FeedPage extends StatefulWidget {
  const FeedPage({
    Key? key,
  }) : super(key: key);

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  Map<String, dynamic>? currentUser;
  String? currentUserId;

  late Database db;

  String? mtoken = '';
  String? username;

  late final FirebaseMessaging _firebaseMessaging;
  PushNotificationModel? _notificationInfo;
  late int _totalNotifications;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  @override
  void initState() {
    // intitialize database
    db = Database();
    // get values from local
    currentUserId = sharedPreferences.getString('currentUserUid');
    //push notification prompt
    requestAndRegisterNotification();
    onMessageListen();
    // get current user info from database
    getUser(currentUserId ?? _firebaseAuth.currentUser!.uid);

    _totalNotifications = 0;
    super.initState();
  }

  onMessageListen() {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      PushNotificationModel notification = PushNotificationModel(
        title: message.notification?.title,
        body: message.notification?.body,
      );
      if (mounted) {
        setState(() {
          _notificationInfo = notification;
          _totalNotifications++;
        });
      }
    });
  }

  void getToken() async {
    await FirebaseMessaging.instance.getToken().then((token) {
      setState(() {
        mtoken = token;
      });
    });
  }

  Future<void> saveToken(String token) async {
    try {
      await db.usersRef.doc(_firebaseAuth.currentUser!.uid).update({'token': token});
      sharedPreferences.setString('token', token);
    } catch (e) {
      Future.error(e);
    }
  }

  requestAndRegisterNotification() async {
    // instatiate firebase messaging
    _firebaseMessaging = FirebaseMessaging.instance;
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    //  On iOS, this helps to take the user permissions
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      String? token = await _firebaseMessaging.getToken();

      await saveToken(token.toString());
      sharedPreferences.setString('userToken', token.toString());
      // For handling the received notifications

      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        // Parse the message received
        PushNotificationModel notification = PushNotificationModel(
          title: message.notification?.title,
          body: message.notification?.body,
        );

        _notificationInfo = notification;
        _totalNotifications++;
        if (_notificationInfo != null) {
          // For displaying the notification as an overlay
          if (mounted) {
            showSimpleNotification(
              Text(_notificationInfo!.title!),
              leading: NotificationBadge(totalNotifications: _totalNotifications),
              subtitle: Text(_notificationInfo!.body!),
              background: Colors.blue,
              duration: const Duration(seconds: 2),
            );
          }
        }
      });
    } else {
      String? token = await _firebaseMessaging.getToken();
      await saveToken(token.toString());
    }
  }

  Future<Map<String, dynamic>> getUser(String currentUserId) async {
    //get user details from database if userID is the same with locally saved user id
    var details = await db.getUserDetails(uid: currentUserId);
    // move details data to current user variable
    setState(() {
      currentUser = details;
    });

    return currentUser ?? {};
  }

  @override
  Widget build(BuildContext context) {
    return currentUser != null
        ? DefaultTabController(
            length: 6,
            child: Scaffold(
              floatingActionButton: FloatingActionButton(
                highlightElevation: 50,
                elevation: 8,
                backgroundColor: Colors.blue.shade900,
                onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => RequestPage(
                              user: currentUser,
                            ))),
                child: const Icon(
                  Icons.add,
                  size: 30,
                ),
              ),
              drawer: Drawer(
                  child: ListView(padding: EdgeInsets.zero, children: [
                UserAccountsDrawerHeader(
                  decoration: BoxDecoration(
                    color: Colors.blue.shade900,
                  ),
                  currentAccountPicture: randomAvatar(currentUser?['photoUrl']),
                  accountEmail: Text(
                    currentUser?['username'],
                    style: const TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                  accountName: const Text('Username:'),
                ),
                ListTile(
                  leading: const Icon(
                    Icons.contact_mail_outlined,
                    size: 18,
                  ),
                  title: const Text(
                    'Settings',
                    style: TextStyle(
                      fontSize: 14.0,
                    ),
                  ),
                  onTap: () => Navigator.pushNamed(context, '/contactUs'),
                ),
                ListTile(
                  leading: const Icon(
                    Icons.logout,
                    size: 18,
                  ),
                  title: const Text(
                    'Log Out',
                    style: TextStyle(fontSize: 14.0),
                  ),
                  onTap: () async {
                    try {
                      Provider.of<Authentication>(context, listen: false).signOut(context: context);
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const RootPage()));
                    } catch (e) {
                      if (mounted) {
                        showSnackBar(context, 'Something went wrong.');
                      }

                      Future.error(e);
                    }
                  },
                )
              ])),
              body: NestedScrollView(
                headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
                  return <Widget>[
                    SliverAppBar(
                      title: const Text('BountyBay'),
                      pinned: true,
                      centerTitle: false,
                      backgroundColor: Colors.blue.shade900,
                      floating: true,
                      bottom: TabBar(
                        indicator: BoxDecoration(
                            borderRadius: BorderRadius.circular(10), // Creates border
                            color: Colors.blue),
                        isScrollable: true,
                        tabs: const [
                          Tab(child: Text('All')),
                          Tab(child: Text('Art')),
                          Tab(child: Text('Antiques')),
                          Tab(child: Text('Watches')),
                          Tab(child: Text('Others')),
                          Tab(child: Text('My Posts')),
                        ],
                      ),
                    ),
                  ];
                },
                body: TabBarView(
                  children: <Widget>[
                    AllTab(user: currentUser ?? {}),
                    ArtTab(
                      user: currentUser ?? {},
                    ),
                    AntiqueTab(user: currentUser ?? {}),
                    WatchesTab(user: currentUser ?? {}),
                    OthersTab(user: currentUser ?? {}),
                    MyPostsTab(user: currentUser ?? {}),
                  ],
                ),
              ),
            ),
          )
        : Center(
            child: CircularProgressIndicator(
              color: Colors.blue.shade900,
            ),
          );
  }
}
