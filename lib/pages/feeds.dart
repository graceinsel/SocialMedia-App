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
  ScrollController _scrollController = ScrollController();
  TabController? _tabController;
  List<PostModel> posts = [];
  bool isLoadingMore = false;
  int pageLimit = 5;
  DocumentSnapshot? lastDocument; // Keeps track of the last document fetched

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _scrollController.addListener(_scrollListener);
    _fetchPosts(); // Initial fetch
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent &&
        !isLoadingMore) {
      setState(() {
        isLoadingMore = true;
      });
      _fetchPosts();
    }
  }

  Future<void> _fetchPosts() async {
    if (isLoadingMore) return; // Prevents duplicate fetches
    setState(() {
      isLoadingMore = true;
    });

    QuerySnapshot querySnapshot;
    if (lastDocument == null) {
      // Fetching the first batch
      querySnapshot = await postRef
          .orderBy('timestamp', descending: true)
          .limit(pageLimit)
          .get();
    } else {
      // Fetching subsequent batches
      querySnapshot = await postRef
          .orderBy('timestamp', descending: true)
          .startAfterDocument(lastDocument!)
          .limit(pageLimit)
          .get();
    }

    if (querySnapshot.docs.isNotEmpty) {
      lastDocument = querySnapshot.docs.last;
      List<PostModel> newPosts = querySnapshot.docs
          .map((doc) => PostModel.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
      setState(() {
        posts.addAll(newPosts);
      });
    }

    setState(() {
      isLoadingMore = false;
    });
  }

  @override
  void dispose() {
    _tabController?.dispose();
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
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
          buildPostsTab(),
          Center(child: Text('Explore Content')),
          Center(child: Text('Artwork Content')),
          Center(child: Text('Events Content')),
        ],
      ),
      // body:
    );
  }

  Widget buildPostsTab() {
    return ListView.builder(
      controller: _scrollController,
      itemCount: posts.length + (isLoadingMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index < posts.length) {
          return UserPost(post: posts[index]); // Your post widget
        } else {
          // TODO(bug): fix the indicator issue. When no post left, should show is bottom.
          return Center(
              child:
                  CircularProgressIndicator()); // Loading indicator at the bottom
        }
      },
    );
  }
}
