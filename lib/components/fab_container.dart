import 'package:animations/animations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_media_app/view_models/status/status_view_model.dart';
import '../posts/create_post.dart';

class FabContainer extends StatelessWidget {
  final Widget? page;
  final IconData icon;
  final bool mini;

  FabContainer({this.page, required this.icon, this.mini = false});

  @override
  Widget build(BuildContext context) {
    StatusViewModel viewModel = Provider.of<StatusViewModel>(context);
    return OpenContainer(
      transitionType: ContainerTransitionType.fade,
      openBuilder: (BuildContext context, VoidCallback _) {
        return page!;
      },
      closedElevation: 4.0,
      closedShape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(56 / 2),
        ),
      ),
      closedColor: Theme.of(context).scaffoldBackgroundColor,
      closedBuilder: (BuildContext context, VoidCallback openContainer) {
        return FloatingActionButton(
          backgroundColor: Theme.of(context).primaryColor,
          child: Icon(
            icon,
            color: Theme.of(context).colorScheme.secondary,
          ),
          onPressed: () {
            chooseUpload(context, viewModel);
          },
          mini: mini,
        );
      },
    );
  }

  // TODO(UI):make the bottom up better, i.e. glassmorphism
  chooseUpload(BuildContext context, StatusViewModel viewModel) {
    return showModalBottomSheet(
      useSafeArea: true,
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      builder: (BuildContext context) {
        return FractionallySizedBox(
          heightFactor: 0.6,
          child: ListView(
            // Wrap the Column with ListView
            shrinkWrap: true, // Add this line
            children: [
              SizedBox(height: 24.0),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14.0, vertical: 4.0),
                child: Center(
                  child: Text(
                    'Create',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                ),
              ),
              // Divider(),
              ListTile(
                leading: Icon(
                  CupertinoIcons.camera_on_rectangle,
                  size: 25.0,
                ),
                title: Text('Share your thoughts',
                    style:
                        TextStyle(fontWeight: FontWeight.w400, fontSize: 14.0)),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.of(context).push(
                    CupertinoPageRoute(
                      builder: (_) => CreatePost(),
                    ),
                  );
                },
              ),
              ListTile(
                leading: Icon(
                  CupertinoIcons.camera_on_rectangle,
                  size: 25.0,
                ),
                title: Text('Add Art Collection',
                    style:
                        TextStyle(fontWeight: FontWeight.w400, fontSize: 14.0)),
                onTap: () async {
                  // Navigator.pop(context);
                  await viewModel.pickImage(context: context);
                },
              ),
              ListTile(
                leading: Icon(
                  CupertinoIcons.camera_on_rectangle,
                  size: 25.0,
                ),
                title: Text('Schedule Event',
                    style:
                        TextStyle(fontWeight: FontWeight.w400, fontSize: 14.0)),
                onTap: () async {
                  // Navigator.pop(context);
                  await viewModel.pickImage(context: context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
