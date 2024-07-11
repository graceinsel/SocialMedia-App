import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:provider/provider.dart';
import 'package:social_media_app/components/custom_image.dart';
import 'package:social_media_app/view_models/auth/posts_view_model.dart';
import 'package:social_media_app/widgets/indicators.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:social_media_app/components/text_form_builder.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:social_media_app/screens/mainscreen.dart';

class ProfilePicture extends StatefulWidget {
  @override
  _ProfilePictureState createState() => _ProfilePictureState();
}

class _ProfilePictureState extends State<ProfilePicture> {
  @override
  Widget build(BuildContext context) {
    PostsViewModel viewModel = Provider.of<PostsViewModel>(context);
    return PopScope(
      onPopInvoked: (bool value) async {
        viewModel.resetPost();
      },
      child: LoadingOverlay(
        progressIndicator: circularProgress(context),
        isLoading: viewModel.loading,
        child: Scaffold(
          key: viewModel.scaffoldKey,
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              // TODO(bug): back should go back to earlier signup page with information prefilled.
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: Text(
              'More about you',
              textAlign: TextAlign.center, // Center text horizontally
              style: GoogleFonts.robotoSerif(
                fontWeight: FontWeight.w400,
                fontSize: 16.0,
              ),
            ),
            centerTitle: true,
            automaticallyImplyLeading: false,
            actions: [
              TextButton(onPressed: () {
                Navigator.of(context)
                    .pushReplacement(CupertinoPageRoute(builder: (_) => TabScreen()));
                }, child: Text("Add later"))
            ],
          ),
          body: ListView(
            padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
            children: [
              viewModel.imgLink != null
                  ? CircleAvatar(
                      radius: 60.0,
                      backgroundImage:
                          CachedNetworkImageProvider('${viewModel.imgLink}'),
                    )
                  : viewModel.mediaUrl == null
                      ? CircleAvatar(
                          radius: 60.0, // Adjust the radius for size
                          backgroundColor:
                              Colors.blue, // Background color of the circle
                          child: Icon(
                            Icons.person, // The icon you want to display
                            color: Colors.white, // Color of the icon
                            size: 50.0, // Size of the icon
                          ),
                        )
                      : CircleAvatar(
                          radius: 60.0, // Adjust radius as needed
                          backgroundImage: FileImage(viewModel
                              .mediaUrl!), // Use FileImage with the file path
                          backgroundColor: Colors
                              .transparent, // Optional: Set background color
                        ),
              SizedBox(height: 12.0),
              InkWell(
                  onTap: () => showImageChoices(context, viewModel),
                  child: Center(
                      child: Text(
                    'Add/Edit your profile picture',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ))),
              SizedBox(height: 30.0),
              // Add highlight
              TextFormBuilder(
                enabled: !viewModel.loading,
                hintText: "Add a brief introduction about yourself",
                textInputAction: TextInputAction.next,
                onSaved: (String val) {
                  viewModel.setBio(val);
                },
                maxLines: 5,
                maxLength: 200,
                borderRadius: 5.0,
                defaultBorderColor: Colors.grey,
              ),
              SizedBox(height: 24.0),
              Center(
                child: ElevatedButton(
                  style: ButtonStyle(
                    fixedSize: MaterialStateProperty.all(Size(200, 30)),
                    backgroundColor: MaterialStateProperty.all<Color>(
                        Theme.of(context).colorScheme.secondary),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                  ),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 12, horizontal: 0),
                    child: Center(
                      child: Text('done'.toUpperCase(),
                          style: TextStyle(color: Colors.white)),
                    ),
                  ),
                  onPressed: () =>
                      viewModel.uploadProfilePictureAndBio(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  showImageChoices(BuildContext context, PostsViewModel viewModel) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      builder: (BuildContext context) {
        return FractionallySizedBox(
          heightFactor: .55,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 30.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Text(
                  'Select from'.toUpperCase(),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Divider(),
              ListTile(
                leading: Icon(Ionicons.camera_outline),
                title: Text('Camera'),
                onTap: () {
                  Navigator.pop(context);
                  viewModel.pickImage(camera: true);
                },
              ),
              ListTile(
                leading: Icon(Ionicons.image),
                title: Text('Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  viewModel.pickImage();
                  // viewModel.pickProfilePicture();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
