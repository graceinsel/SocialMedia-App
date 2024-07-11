import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:social_media_app/auth/register/register.dart';
import 'package:social_media_app/components/stream_grid_wrapper.dart';
import 'package:social_media_app/models/post.dart';
import 'package:social_media_app/models/user.dart';
import 'package:social_media_app/screens/edit_profile.dart';
import 'package:social_media_app/screens/list_posts.dart';
import 'package:social_media_app/screens/settings.dart';
import 'package:social_media_app/utils/firebase.dart';
import 'package:social_media_app/widgets/post_tiles.dart';
import 'package:social_media_app/chats/recent_chats.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:social_media_app/widgets/userpost.dart';
import 'package:social_media_app/widgets/indicators.dart';
import 'package:social_media_app/models/enum/page_type.dart';
import 'package:social_media_app/widgets/drawer.dart';

class Profile extends StatefulWidget {
  final profileId;

  Profile({this.profileId});

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  User? user;
  bool isLoading = false;
  int postCount = 0;
  int followersCount = 0;
  // When A follows B and B follows back, we call it a connection.
  // TODO(feature): add connection check count
  int connectionsCount = 0;
  int followingCount = 0;
  bool isFollowing = false;
  UserModel? users;
  final DateTime timestamp = DateTime.now();
  ScrollController controller = ScrollController();
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    checkIfFollowing();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  currentUserId() {
    return firebaseAuth.currentUser?.uid;
  }

  Future<DocumentSnapshot> fetchDocumentWithRetry(
      DocumentReference documentReference,
      {int maxAttempts = 3,
      Duration initialDelay = const Duration(seconds: 1)}) async {
    int attempts = 0;
    Duration delay = initialDelay;

    while (attempts < maxAttempts) {
      try {
        return await documentReference.get();
      } catch (e) {
        attempts++;
        if (attempts >= maxAttempts) {
          rethrow;
        }
        await Future.delayed(delay);
        delay *= 2;
      }
    }
    throw Exception('Failed to fetch document after retries');
  }

// Usage in your checkIfFollowing function
  checkIfFollowing() async {
    try {
      DocumentSnapshot doc = await fetchDocumentWithRetry(
        followersRef
            .doc(widget.profileId)
            .collection('userFollowers')
            .doc(currentUserId()),
      );
      if (mounted) {
        setState(() {
          isFollowing = doc.exists;
        });
      }
    } catch (e) {
      // Handle the exception, e.g., show a message to the user
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Ionicons.menu_outline,
            size: 24.0,
          ),
            onPressed: () {
              scaffoldKey.currentState!.openDrawer(); // Open the drawer
            }
        ),
        // centerTitle: true,
        actions: [
          // TODO(feature): add follow/unfollow, and edit pencil to the right top
          // can reuse buildProfileButton below.
        ],
      ),
      drawer: AppDrawer(),
      body: Column(
        children: <Widget>[
          SizedBox(height: 12.0),
          StreamBuilder(
            stream: usersRef.doc(widget.profileId).snapshots(),
            builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (snapshot.hasData) {
                print(FirebaseFirestore.instance.collection('users').doc('userId').path);
                print(widget.profileId);
                print('debugging');
                print(snapshot.toString());
                print(snapshot.data!.exists);

                print(snapshot.data!.data());
                UserModel user = UserModel.fromJson(
                  snapshot.data!.data() as Map<String, dynamic>,
                );
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment
                          .start, // Align children to start horizontally
                      children: [
                        // Avatar
                        Padding(
                          padding: const EdgeInsets.only(left: 16.0),
                          child: user.photoUrl!.isEmpty
                              ? CircleAvatar(
                                  radius: 40.0,
                                  backgroundColor:
                                      Theme.of(context).colorScheme.secondary,
                                  child: Center(
                                    child: Text(
                                      '${user.username![0].toUpperCase()}',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                )
                              : CircleAvatar(
                                  radius: 40.0,
                                  backgroundImage: CachedNetworkImageProvider(
                                    '${user.photoUrl}',
                                  ),
                                ),
                        ),
                        SizedBox(width: 20.0),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 130.0,
                              child: Text(
                                user.username!,
                                style: GoogleFonts.roboto(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 20.0,
                                    letterSpacing: 0.8),
                                maxLines: 1,
                              ),
                            ),
                            SizedBox(height: 2.0),
                            user.bio!.isEmpty
                                ? Container()
                                : Container(
                                    width:
                                        240, // TODO(UI): make sure this is safe for all browsers
                                    child: Text(
                                      user.bio!,
                                      style: TextStyle(
                                        fontSize: 11.0,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.blueGrey.shade700,
                                        // fontStyle: FontStyle.italic, // This makes the text italic
                                      ),
                                      maxLines: 2,
                                    ),
                                  ),
                            SizedBox(height: 12.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                // TODO(feature): add backend support for connection count.
                                StreamBuilder(
                                  stream: followingRef
                                      .doc(widget.profileId)
                                      .collection('connectionsCount')
                                      .snapshots(),
                                  builder: (context,
                                      AsyncSnapshot<QuerySnapshot> snapshot) {
                                    if (snapshot.hasData) {
                                      QuerySnapshot<Object?>? snap =
                                          snapshot.data;
                                      List<DocumentSnapshot> docs = snap!.docs;
                                      return buildCount(
                                          "connections", docs.length ?? 0);
                                    } else {
                                      return buildCount("connections", 0);
                                    }
                                  },
                                ),
                                SizedBox(width: 12.0),
                                CircleAvatar(
                                  radius: 2.0, // Radius of the dot
                                  backgroundColor:
                                      Colors.blueGrey, // Color of the dot
                                ),
                                SizedBox(width: 12.0),

                                StreamBuilder(
                                  stream: followersRef
                                      .doc(widget.profileId)
                                      .collection('userFollowers')
                                      .snapshots(),
                                  builder: (context,
                                      AsyncSnapshot<QuerySnapshot> snapshot) {
                                    if (snapshot.hasData) {
                                      QuerySnapshot<Object?>? snap =
                                          snapshot.data;
                                      List<DocumentSnapshot> docs = snap!.docs;
                                      return buildCount(
                                          "followers", docs.length ?? 0);
                                    } else {
                                      return buildCount("followers", 0);
                                    }
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    Padding(
                        padding: EdgeInsets.only(top: 28.0, bottom: 4.0),
                        child: Container(
                          height: 0.3, // Height of the line
                          color: Colors.grey, // Color of the line
                          width: MediaQuery.of(context).size.width *
                              0.9, // 90% of screen width
                          // width: double.infinity, // Full width line
                        ))
                  ],
                );
              }
              return Container();
            },
          ),
          Flexible(
            child: DefaultTabController(
              length: 4,
              child: Scaffold(
                appBar: AppBar(
                  title: TabBar(
                    controller: _tabController,
                    tabs: [
                      Tab(text: 'News'),
                      Tab(text: 'Artworks'),
                      Tab(text: 'Event'),
                      Tab(text: 'About'),
                    ],
                    labelStyle: GoogleFonts.roboto(
                        fontWeight: FontWeight.w400,
                        color: Colors.blueGrey,
                        fontSize: 13.0,
                        letterSpacing: 0.7),
                  ),
                ),
                body: TabBarView(
                  controller: _tabController,
                  children: [
                    // TODO(UI): load 5 news post each time when scrolling load next 5. Follow what Feeds does. Better modulize the changes.
                    // TODO(UI): fix scrolling behavior
                    Center(
                      child: RefreshIndicator(
                        color: Theme.of(context).colorScheme.secondary,
                        onRefresh: () => postRef
                            .orderBy('timestamp', descending: true)
                            .limit(5)
                            .get(),
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: MediaQuery.of(context).size.height,
                                child: FutureBuilder(
                                  future: postRef
                                      .where('ownerId',
                                          isEqualTo: widget.profileId)
                                      .orderBy('timestamp', descending: true)
                                      .limit(5)
                                      .get(),
                                  builder: (context,
                                      AsyncSnapshot<QuerySnapshot> snapshot) {
                                    if (snapshot.hasData) {
                                      var snap = snapshot.data;
                                      List docs = snap!.docs;
                                      return ListView.builder(
                                        itemCount: docs.length,
                                        shrinkWrap: true,
                                        itemBuilder: (context, index) {
                                          PostModel posts = PostModel.fromJson(
                                              docs[index].data());
                                          return Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                10.0, 10.0, 10.0, 0.0),
                                            // UserPost is the widget for each post.
                                            child: UserPost(
                                                post: posts,
                                                pageType:
                                                    PageType.PROFILE_PAGE),
                                          );
                                        },
                                      );
                                    } else if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return circularProgress(context);
                                    } else
                                      return Center(
                                        child: Text(
                                          'No Post Yet',
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
                    CustomScrollView(
                      slivers: <Widget>[
                        // Your scrollable content for 'Artworks' tab
                      ],
                    ),
                    CustomScrollView(
                      slivers: <Widget>[
                        // Your scrollable content for 'Event' tab
                      ],
                    ),
                    CustomScrollView(
                      slivers: <Widget>[
                        // Your scrollable content for 'About' tab
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  buildCount(String label, int count) {
    return Row(
      children: <Widget>[
        Text(
          count.toString(),
          style: TextStyle(
            fontSize: 12.0,
          ),
        ),
        SizedBox(width: 4.0),
        Text(
          label,
          style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: Colors.blueGrey.shade600),
        )
      ],
    );
  }

  // TODO(ui): edit profile to side slide, follow/unfollow to top right corner.
  buildProfileButton(user) {
    //if isMe then display "edit profile"
    bool isMe = widget.profileId == firebaseAuth.currentUser!.uid;
    if (isMe) {
      return buildButton(
          text: "Edit Profile",
          function: () {
            Navigator.of(context).push(
              CupertinoPageRoute(
                builder: (_) => EditProfile(
                  user: user,
                ),
              ),
            );
          });
      //if you are already following the user then "unfollow"
    } else if (isFollowing) {
      return buildButton(
        text: "Unfollow",
        function: handleUnfollow,
      );
      //if you are not following the user then "follow"
    } else if (!isFollowing) {
      return buildButton(
        text: "Follow",
        function: handleFollow,
      );
    }
  }

  buildButton({String? text, Function()? function}) {
    return Center(
      child: GestureDetector(
        onTap: function!,
        child: Container(
          height: 40.0,
          width: 200.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.0),
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                Theme.of(context).colorScheme.secondary,
                Color(0xff597FDB),
              ],
            ),
          ),
          child: Center(
            child: Text(
              text!,
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }

  handleUnfollow() async {
    DocumentSnapshot doc = await usersRef.doc(currentUserId()).get();
    users = UserModel.fromJson(doc.data() as Map<String, dynamic>);
    setState(() {
      isFollowing = false;
    });
    //remove follower
    followersRef
        .doc(widget.profileId)
        .collection('userFollowers')
        .doc(currentUserId())
        .get()
        .then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });
    //remove following
    followingRef
        .doc(currentUserId())
        .collection('userFollowing')
        .doc(widget.profileId)
        .get()
        .then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });
    //remove from notifications feeds
    notificationRef
        .doc(widget.profileId)
        .collection('notifications')
        .doc(currentUserId())
        .get()
        .then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });
  }

  handleFollow() async {
    DocumentSnapshot doc = await usersRef.doc(currentUserId()).get();
    users = UserModel.fromJson(doc.data() as Map<String, dynamic>);
    setState(() {
      isFollowing = true;
    });
    //updates the followers collection of the followed user
    followersRef
        .doc(widget.profileId)
        .collection('userFollowers')
        .doc(currentUserId())
        .set({});
    //updates the following collection of the currentUser
    followingRef
        .doc(currentUserId())
        .collection('userFollowing')
        .doc(widget.profileId)
        .set({});
    //update the notification feeds
    notificationRef
        .doc(widget.profileId)
        .collection('notifications')
        .doc(currentUserId())
        .set({
      "type": "follow",
      "ownerId": widget.profileId,
      "username": users?.username,
      "userId": users?.id,
      "userDp": users?.photoUrl,
      "timestamp": timestamp,
    });
  }

  buildPostView() {
    return buildGridPost();
  }

  buildListPost() {
    return StreamGridWrapper(
      shrinkWrap: true,
      padding: const EdgeInsets.symmetric(horizontal: .0),
      stream: postRef
          .where('ownerId', isEqualTo: widget.profileId)
          .orderBy('timestamp', descending: true)
          .snapshots(),
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (_, DocumentSnapshot snapshot) {
        PostModel posts =
            PostModel.fromJson(snapshot.data() as Map<String, dynamic>);
        return Padding(
          padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 20.0),
          // UserPost is the widget for each post.
          child: UserPost(post: posts),
        );
      },
    );
  }

  buildGridPost() {
    return StreamGridWrapper(
      shrinkWrap: true,
      padding: const EdgeInsets.symmetric(horizontal: .0),
      stream: postRef
          .where('ownerId', isEqualTo: widget.profileId)
          .orderBy('timestamp', descending: true)
          .snapshots(),
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (_, DocumentSnapshot snapshot) {
        PostModel posts =
            PostModel.fromJson(snapshot.data() as Map<String, dynamic>);
        return PostTile(
          post: posts,
        );
      },
    );
  }

  buildLikeButton() {
    return StreamBuilder(
      stream: favUsersRef
          .where('postId', isEqualTo: widget.profileId)
          .where('userId', isEqualTo: currentUserId())
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData) {
          List<QueryDocumentSnapshot> docs = snapshot.data?.docs ?? [];
          return GestureDetector(
            onTap: () {
              if (docs.isEmpty) {
                favUsersRef.add({
                  'userId': currentUserId(),
                  'postId': widget.profileId,
                  'dateCreated': Timestamp.now(),
                });
              } else {
                favUsersRef.doc(docs[0].id).delete();
              }
            },
            child: Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 3.0,
                    blurRadius: 5.0,
                  )
                ],
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Padding(
                padding: EdgeInsets.all(3.0),
                child: Icon(
                  docs.isEmpty
                      ? CupertinoIcons.heart
                      : CupertinoIcons.heart_fill,
                  color: Colors.red,
                ),
              ),
            ),
          );
        }
        return Container();
      },
    );
  }
}
