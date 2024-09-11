import 'package:flutter/material.dart';
import 'package:emoji_regex/emoji_regex.dart';

class TextWithEmoji extends StatelessWidget {
  final String text;
  final FontWeight fontWeight;
  final double fontSize;
  final Color? color;
  final double? height; // Added height parameter
  final int? maxLines; // Added maxLines parameter
  final TextOverflow? overflow; // Added overflow parameter

  TextWithEmoji({
    required this.text,
    required this.fontWeight,
    required this.fontSize,
    this.color,
    this.height,
    this.maxLines, // Added maxLines to constructor
    this.overflow, // Added overflow to constructor
  });

  @override
  Widget build(BuildContext context) {
    final emojiPattern = emojiRegex();
    final spans = <TextSpan>[];

    text.splitMapJoin(
      emojiPattern,
      onMatch: (match) {
        spans.add(
          TextSpan(
            text: match.group(0),
            style: TextStyle(
              fontFamily: 'NotoColorEmoji',
              fontSize: fontSize,
              fontWeight: fontWeight,
              height: height ?? 24 / 14, // Added height to TextStyle
            ),
          ),
        );
        return '';
      },
      onNonMatch: (nonMatch) {
        // Regular text element
        spans.add(
          TextSpan(
            text: nonMatch,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: fontWeight,
              color: color,
              height: height ?? 24 / 15, // Added height to TextStyle
            ),
          ),
        );
        return '';
      },
    );

    return Text.rich(
      TextSpan(
        children: spans,
      ),
      maxLines: maxLines ?? 100,
      overflow: overflow ?? TextOverflow.ellipsis,
    );
  }
}
