import 'package:expandable/expandable.dart';
import 'package:firestore_search/firestore_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:glass/glass.dart';
import 'package:lrf/constants/constants.dart';
import 'package:lrf/models/data_model.dart';
import 'package:lrf/pages/comment_screen.dart';
import 'package:lrf/services/database.dart';
import 'dart:math' as math;
import 'package:intl/intl.dart';
import 'package:lrf/utils/utils.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({
    super.key,
  });

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late Database db;

  @override
  void initState() {
    db = Database();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FirestoreSearchScaffold(
      searchIconColor: Colors.transparent,
      searchTextColor: Colors.black,
      appBarBackgroundColor: kAppBackgroundColor,
      firestoreCollectionName: 'posts',
      searchTextHintColor: Colors.blueGrey,
      showSearchIcon: false,
      backButtonColor: Colors.green,
      clearSearchButtonColor: Colors.black,
      searchBodyBackgroundColor: kAppBackgroundColor,
      searchBackgroundColor: Colors.white70,
      searchBy: 'title',
      scaffoldBody: Container(
        padding: const EdgeInsets.all(12),
        height: 100,
        width: MediaQuery.of(context).size.width,
        child: Card(
          elevation: 8,
          color: Colors.black87,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 5,
              ),
              Text('Search for a Title',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.white70,
                    // color: Colors.white70,
                    shadows: [
                      Shadow(
                        blurRadius: 1.0,
                        color: Theme.of(context).primaryColor,
                        offset: const Offset(0.4, 0.2),
                      ),
                    ],
                  )),
              const SizedBox(
                height: 5,
              ),
              Text('All Title Start with an Uppercase Letter',
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    // color: Colors.white70,
                    shadows: [
                      Shadow(
                        blurRadius: 1.0,
                        color: Theme.of(context).primaryColor,
                        offset: const Offset(0.4, 0.4),
                      ),
                    ],
                  )),
              const SizedBox(
                height: 5,
              ),
            ],
          ),
        ).asGlass(),
      ),
      scaffoldBackgroundColor: kAppBackgroundColor,
      dataListFromSnapshot: DataModel().dataListFromSnapshot,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final List<DataModel>? dataList = snapshot.data;

          if (dataList!.isEmpty) {
            return const Center(
              child: Text('No Title Found'),
            );
          }
          return ListView.builder(
              itemCount: dataList.length,
              itemBuilder: (context, index) {
                final DataModel data = dataList[index];

                return ExpandableNotifier(
                    child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: ScrollOnExpand(
                    child: Card(
                      clipBehavior: Clip.antiAlias,
                      child: Column(
                        children: <Widget>[
                          ExpandablePanel(
                            theme: const ExpandableThemeData(
                              headerAlignment: ExpandablePanelHeaderAlignment.center,
                              tapBodyToExpand: true,
                              hasIcon: false,
                            ),
                            header: Container(
                              color: Colors.green.shade900,
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Row(
                                  children: [
                                    ExpandableIcon(
                                      theme: const ExpandableThemeData(
                                          expandIcon: Icons.arrow_right,
                                          collapseIcon: Icons.arrow_drop_down,
                                          iconColor: Colors.white,
                                          iconSize: 28.0,
                                          iconRotationAngle: math.pi / 2,
                                          iconPadding: EdgeInsets.only(right: 5),
                                          hasIcon: false,
                                          tapBodyToExpand: true),
                                    ),
                                    Expanded(
                                      child: Text(
                                        data.title ?? '',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1!
                                            .copyWith(color: Colors.blueGrey.shade100, overflow: TextOverflow.ellipsis),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            collapsed: Container(),
                            expanded: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  db.user.uid == data.userId
                                      ? Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            TextButton(
                                                onPressed: () async {
                                                  try {
                                                    String res = await db.deletePostRequest(postId: data.postId!);

                                                    if (res == 'success') {
                                                      if (mounted) {
                                                        showSnackBar(context, 'Post Deleted!');
                                                      }
                                                    } else {
                                                      if (mounted) {
                                                        showSnackBar(context, 'Delete Unsuccessful. Try Agin.');
                                                      }
                                                    }
                                                  } catch (e) {
                                                    if (mounted) {
                                                      showSnackBar(context, 'Something went wrong. Try again');
                                                    }
                                                    Future.error(e);
                                                  }
                                                },
                                                child: const Text(
                                                  'Delete',
                                                  style: TextStyle(color: Colors.white54),
                                                )),
                                          ],
                                        )
                                      : const SizedBox.shrink(),
                                  ListTile(
                                    leading: Icon(
                                      Icons.date_range,
                                      color: Colors.red.shade900,
                                      size: 22,
                                    ),
                                    title: Text(
                                      DateFormat.yMMMd().format(
                                        data.datePublished!.toDate(),
                                      ),
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.blueGrey.shade100,
                                      ),
                                    ),
                                  ),
                                  ListTile(
                                    leading: Icon(
                                      Icons.person_outline,
                                      color: Colors.orange.shade700,
                                    ),
                                    title: Row(
                                      children: [
                                        CircleAvatar(
                                          backgroundImage: NetworkImage(data.profImage ?? ''),
                                          radius: 14,
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          data.username ?? '',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.blueGrey.shade100,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  ListTile(
                                    leading: Icon(
                                      Icons.location_pin,
                                      color: Colors.yellow.shade700,
                                      size: 22,
                                    ),
                                    title: Text(
                                      data.subAdminArea ?? '',
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.blueGrey.shade100,
                                      ),
                                    ),
                                  ),
                                  ListTile(
                                    leading: Icon(
                                      Icons.mail_outline,
                                      color: Colors.green.shade700,
                                      size: 22,
                                    ),
                                    trailing: InkWell(
                                        onTap: () async {
                                          try {
                                            if (db.user.uid.toString() != data.userId.toString()) {
                                              String res = await db.updateContactedCollection(
                                                  userPostedId: db.user.uid.toString(),
                                                  postOwnerId: data.userId.toString(),
                                                  isEmail: true,
                                                  isSms: false,
                                                  isSearchPage: true,
                                                  postId: data.postId.toString());
                                              if (res == 'success') {
                                                db.sendEmail(data.contactEmail ?? '');
                                              } else {
                                                if (mounted) {
                                                  showSnackBar(context, res);
                                                  Clipboard.setData(ClipboardData(text: data.contactEmail ?? '')).then((_) {
                                                    showSnackBar(context, "Copied to clipboard");
                                                  });
                                                }
                                              }
                                            } else {
                                              if (mounted) {
                                                showSnackBar(context, 'Contacting yourself is not allowed.');
                                              }
                                            }
                                          } catch (e) {
                                            if (mounted) {
                                              showSnackBar(context, e.toString());
                                            }

                                            Future.error(e);
                                          }
                                        },
                                        child: CircleAvatar(
                                            backgroundColor: Colors.black87,
                                            child: Icon(
                                              Icons.contact_page_outlined,
                                              size: 18,
                                              color: Colors.blueGrey.shade100,
                                            ))),
                                    title: Text(
                                      data.contactEmail ?? '',
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.blueGrey.shade100,
                                      ),
                                    ),
                                  ),
                                  ListTile(
                                    leading: Icon(
                                      Icons.numbers_outlined,
                                      color: Colors.blue.shade700,
                                      size: 22,
                                    ),
                                    trailing: InkWell(
                                        onTap: () async {
                                          try {
                                            if (db.user.uid.toString() != data.userId.toString()) {
                                              String res = await db.updateContactedCollection(
                                                  userPostedId: db.user.uid.toString(),
                                                  postOwnerId: data.userId.toString(),
                                                  isEmail: true,
                                                  isSearchPage: true,
                                                  isSms: false,
                                                  postId: data.postId.toString());
                                              if (res == 'success') {
                                                if (mounted) {
                                                  db.sendSms("sms:${data.contactNumber.toString()}", mounted, context);
                                                }
                                              } else {
                                                if (mounted) {
                                                  Clipboard.setData(ClipboardData(text: data.contactNumber ?? '')).then((_) {
                                                    showSnackBar(context, "Copied to clipboard");
                                                  });
                                                }
                                              }
                                            } else {
                                              if (mounted) {
                                                showSnackBar(context, 'Contacting yourself is not allowed.');
                                              }
                                            }
                                          } catch (e) {
                                            if (mounted) {
                                              showSnackBar(context, e.toString());
                                            }
                                            Future.error(e);
                                          }
                                        },
                                        child: CircleAvatar(
                                            backgroundColor: Colors.black,
                                            child: Icon(
                                              Icons.contact_page_outlined,
                                              size: 18,
                                              color: Colors.blueGrey.shade100,
                                            ))),
                                    title: Text(
                                      data.contactNumber ?? '',
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.blueGrey.shade100,
                                      ),
                                    ),
                                  ),
                                  ListTile(
                                    leading: Icon(
                                      Icons.arrow_upward_outlined,
                                      color: Colors.indigoAccent.shade100,
                                      size: 22,
                                    ),
                                    title: Text(
                                      data.upvote?.length.toString() ?? '',
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.blueGrey.shade100,
                                      ),
                                    ),
                                  ),
                                  ListTile(
                                    leading: Icon(
                                      Icons.arrow_downward_outlined,
                                      color: Colors.purpleAccent.shade400,
                                      size: 22,
                                    ),
                                    title: Text(
                                      data.downVote?.length.toString() ?? '',
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.blueGrey.shade100,
                                      ),
                                    ),
                                  ),
                                  ListTile(
                                    leading: Icon(
                                      Icons.comment,
                                      color: Colors.teal.shade700,
                                      size: 22,
                                    ),
                                    title: Text(
                                      'Comments',
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.blueGrey.shade100,
                                      ),
                                    ),
                                    trailing: InkWell(
                                      onTap: () {
                                        Navigator.push(
                                            context, MaterialPageRoute(builder: (context) => CommentScreen(postId: data.postId.toString())));
                                      },
                                      child: CircleAvatar(
                                          backgroundColor: Colors.black87,
                                          child: Icon(
                                            Icons.arrow_forward,
                                            size: 18,
                                            color: Colors.blueGrey.shade100,
                                          )),
                                    ),
                                  ),
                                  ListTile(
                                    title: Text(
                                      data.description ?? '',
                                      style: TextStyle(
                                        fontSize: 16,
                                        letterSpacing: .2,
                                        color: Colors.blueGrey.shade100,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ));
              });
        }

        if (snapshot.connectionState == ConnectionState.done) {
          if (!snapshot.hasData) {
            return const Center(
              child: Text('No Results Found'),
            );
          }
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
