import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class TweetContentHandler extends StatelessWidget {
  final String text;
  final TextStyle? style;
  const TweetContentHandler({
    super.key,
    required this.text,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    final TextStyle linkStyle = TextStyle(color: Colors.blue);

    final List<TextSpan> textSpans = [];

    final RegExp linkRegExp = RegExp(
      r'(?:(?:https?|ftp)://)?[\w/\-?=%.]+\.[\w/\-?=%.]+',
      caseSensitive: false,
    );

    final RegExp hashtagRegExp = RegExp(r'#(\w+)', caseSensitive: false);

    text.splitMapJoin(linkRegExp, onMatch: (match) {
      textSpans.add(TextSpan(
        text: match.group(0),
        style: linkStyle,
        recognizer: TapGestureRecognizer()
          ..onTap = () {
            print('Link tapped: ${match.group(0)}');
          },
      ));
      return '';
    }, onNonMatch: (text) {
      text.splitMapJoin(hashtagRegExp, onMatch: (match) {
        textSpans.add(TextSpan(
          text: match.group(0),
          style: linkStyle,
          recognizer: TapGestureRecognizer()
            ..onTap = () {
              print('Hashtag tapped: ${match.group(0)}');
            },
        ));
        return '';
      }, onNonMatch: (text) {
        textSpans.add(TextSpan(text: text));
        return '';
      });
      return '';
    });

    return RichText(
      text: TextSpan(
        style: style,
        children: textSpans,
      ),
    );
  }
}
