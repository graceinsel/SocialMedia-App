import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:provider/provider.dart';
import 'package:social_media_app/components/custom_image.dart';
import 'package:social_media_app/view_models/auth/posts_view_model.dart';
import 'package:social_media_app/widgets/indicators.dart';
import 'package:google_fonts/google_fonts.dart';

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
            title: Text('More Details About You',
              textAlign: TextAlign.center, // Center text horizontally
              style: GoogleFonts.crimsonText(
                fontWeight: FontWeight.w400,
                fontSize: 20.0,
              ),
            ),
            centerTitle: true,
            automaticallyImplyLeading: false,
          ),
          body: ListView(
            padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 30),
            children: [
              InkWell(
                onTap: () => showImageChoices(context, viewModel),
                child: Container(
                  // width: MediaQuery.of(context).size.width * 0.5,
                  height: MediaQuery.of(context).size.width - 200,
                  width: 100,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.all(
                      Radius.circular(3.0),
                    ),
                  ),
                  child: viewModel.imgLink != null
                      ? CustomImage(
                          imageUrl: viewModel.imgLink,
                          width: MediaQuery.of(context).size.width - 30,
                          height: MediaQuery.of(context).size.width - 30,
                          fit: BoxFit.cover,
                        )
                      : viewModel.mediaUrl == null
                          ? Center(
                              child: Text(
                                'Tap to add your profile picture',
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.secondary,
                                ),
                              ),
                            )
                          : Image.file(
                              viewModel.mediaUrl!,
                              width: MediaQuery.of(context).size.width - 30,
                              height: MediaQuery.of(context).size.width - 30,
                              fit: BoxFit.cover,
                            ),
                ),
              ),
              SizedBox(height: 10.0),

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
                    padding: const EdgeInsets.symmetric(vertical:12, horizontal: 0),
                    child: Center(
                      child: Text('done'.toUpperCase(), style: TextStyle(
                        color: Colors.white
                      )),
                    ),
                  ),
                  onPressed: () => viewModel.uploadProfilePicture(context),
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
