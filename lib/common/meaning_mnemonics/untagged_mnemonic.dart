import 'package:flutter/material.dart';
import 'package:robanohashi/common/colors.dart';

enum Token { radical, kanji, plain, vocabulary }

class UntaggedMnemonic extends StatelessWidget {
  const UntaggedMnemonic(
      {super.key, required this.text, required this.meanings});

  final String text;
  final Map<String, Token> meanings;

  dynamic _getSpecialTokenStyle(Token token) {
    switch (token) {
      case Token.radical:
        return TextStyle(
            fontWeight: FontWeight.w900,
            color: getSubjectBackgroundColor("radical"));
      case Token.kanji:
        return TextStyle(
            fontWeight: FontWeight.w900,
            color: getSubjectBackgroundColor("kanji"));
      case Token.vocabulary:
        return TextStyle(
            fontWeight: FontWeight.w900,
            color: getSubjectBackgroundColor("vocabulary"));
      default:
        throw Exception('unsupported token');
    }
  }

  List<TextSpan> _constructText() {
    final tokens = text.split(' ');
    final spans = <TextSpan>[];
    final tokenMask = _createTokenMask(tokens);

    var lastMeaningIndex = 0;

    for (var j = 0; j < tokens.length; j++) {
      if (tokenMask[j] != Token.plain) {
        final plainTokens = [...tokens.sublist(lastMeaningIndex, j), ' '];

        spans.add(TextSpan(text: plainTokens.join(' ')));

        spans.add(TextSpan(
          text: '${tokens[j]} ',
          style: _getSpecialTokenStyle(tokenMask[j]),
        ));
        lastMeaningIndex = j + 1;
      }
    }

    final plainTokens = tokens.sublist(lastMeaningIndex, tokens.length);
    spans.add(TextSpan(text: plainTokens.join(' ')));

    return spans;
  }

  List<Token> _createTokenMask(List<String> tokens) {
    final List<Token> tokenMask = [];

    for (var i = 0; i < tokens.length; i++) {
      final token = tokens[i];

      final mask = meanings.entries
          .firstWhere(
            (entry) => token.toLowerCase().startsWith(entry.key.toLowerCase()),
            orElse: () => MapEntry(token, Token.plain),
          )
          .value;
      tokenMask.add(mask);
    }

    return tokenMask;
  }

  @override
  Widget build(BuildContext context) {
    final spans = _constructText();

    return RichText(
      text: TextSpan(
          children: spans,
          style: TextStyle(color: Colors.grey[700], fontSize: 16)),
    );
  }
}
