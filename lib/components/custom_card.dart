import 'package:flutter/material.dart';

// TODO(UI): add separator between each CustomCard for news feeds.
class CustomCard extends StatelessWidget {
  final Widget? child;
  final Function() onTap;
  final BorderRadius? borderRadius;
  final bool elevated;
  final bool hasDivider;

  CustomCard({
    Key? key,
    required this.child,
    required this.onTap,
    this.borderRadius,
    this.elevated = true,
    this.hasDivider = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: elevated
            ? BoxDecoration(
                borderRadius: borderRadius,
                color: Theme.of(context).cardColor,
              )
            : BoxDecoration(
                borderRadius: borderRadius,
                color: Theme.of(context).cardColor,
              ),
        child: Column(children: [
          Material(
            type: MaterialType.transparency,
            borderRadius: borderRadius,
            child: InkWell(
              borderRadius: borderRadius,
              onTap: onTap,
              child: child,
            ),
          ),
          if (hasDivider)
            Padding(
                padding: EdgeInsets.only(top: 28.0, bottom: 4.0),
                child: Container(
                  height: 1.0, // Height of the line
                  color: Colors.blueGrey.shade200, // Color of the line
                  width:
                      MediaQuery.of(context).size.width, // 90% of screen width
                  // width: double.infinity, // Full width line
                ))
        ]));
  }
}
