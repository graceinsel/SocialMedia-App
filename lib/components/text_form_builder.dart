import 'package:flutter/material.dart';
import 'package:social_media_app/components/custom_card.dart';

class TextFormBuilder extends StatefulWidget {
  final String? initialValue;
  final bool? enabled;
  final String? hintText;
  final TextInputType? textInputType;
  final TextEditingController? controller;
  final TextInputAction? textInputAction;
  final bool obscureText;
  final FocusNode? focusNode, nextFocusNode;
  final VoidCallback? submitAction;
  final FormFieldValidator<String>? validateFunction;
  final void Function(String)? onSaved, onChange;
  final Key? key;
  final IconData? prefix;
  final IconData? suffix;
  final int? maxLines; // Added for multi-line input
  final int? maxLength;
  final double borderRadius; // Added to limit the text length
  final Color defaultBorderColor;

  TextFormBuilder(
      {this.prefix,
      this.suffix,
      this.initialValue,
      this.enabled,
      this.hintText,
      this.textInputType,
      this.controller,
      this.textInputAction,
      this.nextFocusNode,
      this.focusNode,
      this.submitAction,
      this.obscureText = false,
      this.validateFunction,
      this.onSaved,
      this.onChange,
      this.key,
      this.maxLength,
      this.maxLines = 1,
      this.borderRadius = 30.0,
      this.defaultBorderColor = Colors.white});

  @override
  _TextFormBuilderState createState() => _TextFormBuilderState();
}

class _TextFormBuilderState extends State<TextFormBuilder> {
  String? error;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomCard(
            onTap: () {
              print('clicked');
            },
            borderRadius: BorderRadius.circular(widget.borderRadius),
            child: Container(
              child: Theme(
                data: ThemeData(
                  primaryColor: Theme.of(context).colorScheme.secondary,
                  colorScheme: ColorScheme.fromSwatch().copyWith(
                      secondary: Theme.of(context).colorScheme.secondary),
                ),
                child: TextFormField(
                  cursorColor: Theme.of(context).colorScheme.secondary,
                  textCapitalization: TextCapitalization.none,
                  initialValue: widget.initialValue,
                  enabled: widget.enabled,
                  onChanged: (val) {
                    if (widget.validateFunction != null) {
                      error = widget.validateFunction!(val);
                    }
                    setState(() {});
                    widget.onSaved!(val);
                  },
                  style: TextStyle(
                    fontSize: 15.0,
                  ),
                  key: widget.key,
                  controller: widget.controller,
                  obscureText: widget.obscureText,
                  keyboardType: widget.textInputType,
                  validator: widget.validateFunction,
                  onSaved: (val) {
                    if (widget.validateFunction != null) {
                      error = widget.validateFunction!(val);
                    }

                    setState(() {});
                    widget.onSaved!(val!);
                  },
                  textInputAction: widget.textInputAction,
                  focusNode: widget.focusNode,
                  onFieldSubmitted: (String term) {
                    if (widget.nextFocusNode != null) {
                      widget.focusNode!.unfocus();
                      FocusScope.of(context).requestFocus(widget.nextFocusNode);
                    } else {
                      if (widget.submitAction != null) {
                        widget.submitAction!();
                      }
                    }
                  },
                  maxLines:
                      widget.maxLines ?? 1, // Set maxLines for multi-line input
                  maxLength: widget.maxLength, // Set maxLength to limit text
                  decoration: InputDecoration(
                    prefixIcon: widget.prefix != null
                        ? Icon(
                            widget.prefix,
                            size: 15.0,
                            color: Theme.of(context).colorScheme.secondary,
                          )
                        : null,
                    suffixIcon: widget.suffix != null
                        ? Icon(
                            widget.suffix,
                            size: 15.0,
                            color: Theme.of(context).colorScheme.secondary,
                          )
                        : null,
                    filled: true,
                    hintText: widget.hintText,
                    hintStyle: TextStyle(
                      color: Colors.grey[400],
                    ),
                    contentPadding: ((widget.maxLines ?? 1) > 1)
                        ? EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0)
                        : EdgeInsets.symmetric(horizontal: 20.0),
                    border: border(context, widget.borderRadius,
                        widget.defaultBorderColor),
                    enabledBorder: border(context, widget.borderRadius,
                        widget.defaultBorderColor),
                    focusedBorder: focusBorder(context, widget.borderRadius),
                    errorStyle: TextStyle(height: 0.0, fontSize: 0.0),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 4.0),
          Visibility(
            visible: error != null,
            child: Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Text(
                '$error',
                style: TextStyle(
                  color: Colors.red[700],
                  fontSize: 12.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  border(BuildContext context, double borderRadius, Color defaultBorderColor) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(borderRadius),
      ),
      borderSide: BorderSide(
        color: defaultBorderColor,
        width: 0.0,
      ),
    );
  }

  focusBorder(BuildContext context, double borderRadius) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(borderRadius),
      ),
      borderSide: BorderSide(
        color: Theme.of(context).colorScheme.secondary,
        width: 1.0,
      ),
    );
  }
}
