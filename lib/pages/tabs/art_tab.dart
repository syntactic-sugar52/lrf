import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expandable/expandable.dart';
import 'package:fade_shimmer/fade_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:lrf/pages/widgets/fade_shimmer.dart';
import 'package:lrf/pages/widgets/home/card_widget.dart';

class ArtTab extends StatelessWidget {
  const ArtTab({super.key, required this.user});
  final Map<String, dynamic> user;
  @override
  Widget build(BuildContext context) {
    return user.isNotEmpty
        ? StreamBuilder(
            stream: FirebaseFirestore.instance.collection('posts').where('category', isEqualTo: 'Art').snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const FadeShimmerLoading();
              }
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                shrinkWrap: true,
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
                          user: user,
                        )),
                  ),
                ),
              );
            },
          )
        : const SizedBox.shrink();
  }
}
