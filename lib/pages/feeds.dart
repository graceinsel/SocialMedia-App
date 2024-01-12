import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:ionicons/ionicons.dart';
import 'package:social_media_app/chats/recent_chats.dart';
import 'package:social_media_app/models/post.dart';
import 'package:social_media_app/utils/firebase.dart';
import 'package:social_media_app/widgets/indicators.dart';
import 'package:social_media_app/widgets/userpost.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:social_media_app/widgets/drawer.dart';

void printDocumentSnapshot(QueryDocumentSnapshot documentSnapshot) {
  // Extract the data directly
  var data = documentSnapshot.data();

  // Print the data
  print(data.toString());
}

class Feeds extends StatefulWidget {
  @override
  _FeedsState createState() => _FeedsState();
}

class _FeedsState extends State<Feeds> with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  int page = 5;
  bool loadingMore = false;
  ScrollController scrollController = ScrollController();
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    scrollController.addListener(() async {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        setState(() {
          page = page + 5;
          loadingMore = true;
        });
      }
    });
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController?.dispose();
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(
            Ionicons.menu_outline,
            size: 24.0,
          ),
          onPressed: () {
            scaffoldKey.currentState!.openDrawer(); // Open the drawer
          },
        ),
        title: TabBar(
            controller: _tabController,
            tabs: [
              Tab(text: 'Follow'),
              Tab(text: 'Explore'),
              Tab(text: 'Artwork'),
              Tab(text: 'Events'),
            ],
            labelStyle: GoogleFonts.robotoSerif(
              fontWeight: FontWeight.w400,
              color: Colors.blueGrey,
              fontSize: 14.0,
            ),
            labelPadding: EdgeInsets.symmetric(horizontal: 4),
            padding: EdgeInsets.symmetric(horizontal: 12)),
        centerTitle: true,
        titleSpacing: -12,
        actions: [
          IconButton(
            // TODO(graceyao): when has mail in, add red dot.
            icon: Icon(
              Ionicons.mail_outline,
              size: 24.0,
            ),
            onPressed: () {
              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (_) => Chats(),
                ),
              );
            },
          ),
          SizedBox(width: 8.0),
        ],
      ),
      drawer: AppDrawer(),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Replace these with your actual content for each tab
          Center(
            child:
            RefreshIndicator(
              color: Theme.of(context).colorScheme.secondary,
              onRefresh: () => postRef
                  .orderBy('timestamp', descending: true)
                  .limit(page)
                  .get(),
              child: SingleChildScrollView(
                controller: scrollController,
                physics: NeverScrollableScrollPhysics(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height,
                      child: FutureBuilder(
                        future: postRef
                            .orderBy('timestamp', descending: true)
                            .limit(page)
                            .get(),
                        builder:
                            (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.hasData) {
                            var snap = snapshot.data;
                            List docs = snap!.docs;
                            // TODO(UI): scroller not working well. Fix the bug.
                            return ListView.builder(
                              // controller: scrollController,
                              itemCount: docs.length,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                PostModel posts =
                                PostModel.fromJson(docs[index].data());
                                return Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      10.0, 10.0, 10.0, 20.0),
                                  // UserPost is the widget for each post.
                                  child: UserPost(post: posts),
                                );
                              },
                            );
                          } else if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return circularProgress(context);
                          } else
                            return Center(
                              child: Text(
                                'No Feeds',
                                style: TextStyle(
                                  fontSize: 26.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Center(child: Text('Explore Content')),
          Center(child: Text('Artwork Content')),
          Center(child: Text('Events Content')),
        ],
      ),
      // body:
    );
  }

  @override
  bool get wantKeepAlive => true;
}