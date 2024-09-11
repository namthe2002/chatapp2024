import 'package:debounce_throttle/debounce_throttle.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:live_yoko/Global/ColorValue.dart';
import 'package:emoji_regex/emoji_regex.dart';
import '../utils/utils.dart';

class TextFieldWidget extends StatefulWidget {
  const TextFieldWidget(
      {Key? key,
      required this.controller,
      this.textInputAction = TextInputAction.next,
      this.isEnable = true,
      this.autoFocus = false,
      this.onChanged,
      this.isPassword = false,
      this.icon,
      this.errorText,
      this.labelText,
      this.hintText,
      this.inputFormatters,
      this.maxLines,
      this.keyboardType = TextInputType.text,
      this.focusNode,
      this.readOnly = false,
      this.onTap,
      this.fillColor,
      this.onSubmitted,
      this.maxLength,
      this.isCounterText = false,
      this.fillBackground = false,
      this.suffixIcon,
      this.onPressDelete,
      this.titleText,
      this.require = false,
      this.borderColor,
      this.hintStyle,
      this.contentPadding,
      this.labelStyle,
      this.border,
      this.style})
      : super(key: key);

  final TextEditingController controller;
  final bool isEnable;
  final bool autoFocus;
  final bool require;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputAction textInputAction;
  final FormFieldSetter<String>? onChanged;
  final bool isPassword;
  final String? titleText;
  final String? errorText;
  final String? labelText;
  final String? hintText;
  final int? maxLines;
  final TextInputType keyboardType;
  final FocusNode? focusNode;
  final FormFieldSetter<String>? onSubmitted;
  final dynamic icon;
  final bool readOnly;
  final Function()? onTap;
  final Color? fillColor;
  final Color? borderColor;
  final int? maxLength;
  final bool fillBackground;
  final bool? isCounterText;
  final String? suffixIcon;
  final VoidCallback? onPressDelete;
  final TextStyle? labelStyle;
  final TextStyle? hintStyle;
  final EdgeInsetsGeometry? contentPadding;
  final OutlineInputBorder? border;
  final TextStyle? style;

  @override
  _TextFieldWidgetState createState() => _TextFieldWidgetState();
}

class _TextFieldWidgetState extends State<TextFieldWidget> {
  late TextEditingController _controller;


  @override
  void initState() {
    super.initState();
    _controller = widget.controller;
    _controller.addListener(() {
      setState(() {
         _controller.text;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: _controller,
          decoration: InputDecoration(
            hintText: widget.hintText,
            // ... other decoration properties ...
          ),
          // ... other TextField properties ...
        ),
        SizedBox(height: 20),
        _buildStyledText(_controller.text),
      ],
    );
  }

  Widget _buildStyledText(String text) {
    final emojiPattern = emojiRegex(); // Using emoji_regex package
    final spans = <TextSpan>[];

    text.splitMapJoin(
      emojiPattern,
      onMatch: (match) {
        spans.add(
          TextSpan(
            text: match.group(0),
            style: TextStyle(
              fontFamily: 'NotoColorEmoji',
              fontSize: 14,
            ),
          ),
        );
        return '';
      },
      onNonMatch: (nonMatch) {
        spans.add(
          TextSpan(
            text: nonMatch,
            style: TextStyle(
              fontFamily: 'SF Pro Display',
              fontSize: 14,
            ),
          ),
        );
        return '';
      },
    );

    return RichText(
      text: TextSpan(
        children: spans,
        style: TextStyle(fontSize: 14), // General style for the entire text
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
