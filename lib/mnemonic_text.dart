import 'package:flutter/material.dart';

enum Token { radical, kanji, plain }

class MnemonicText extends StatelessWidget {
  const MnemonicText({super.key, required this.text, required this.meanings});

  final String text;
  final Map<String, Token> meanings;

  List<TextSpan> _constructText() {
    final tokens = text.split(' ');
    final spans = <TextSpan>[];
    final tokenMask = _createTokenMask(tokens);

    var lastMeaningIndex = 0;

    for (var j = 0; j < tokens.length; j++) {
      if (tokenMask[j] != Token.plain) {
        final plainTokens = [...tokens.sublist(lastMeaningIndex, j), ' '];

        spans.add(TextSpan(
            text: plainTokens.join(' '),
            style: TextStyle(color: Colors.grey[600])));

        spans.add(TextSpan(
          text: '${tokens[j]} ',
          style: TextStyle(
              fontWeight: FontWeight.w700,
              color: tokenMask[j] == Token.kanji
                  ? Colors.purple[400]
                  : Colors.blue),
        ));
        lastMeaningIndex = j + 1;
      }
    }

    final plainTokens = tokens.sublist(lastMeaningIndex, tokens.length);
    spans.add(TextSpan(
        text: plainTokens.join(' '),
        style: TextStyle(color: Colors.grey[600])));

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

    return RichText(text: TextSpan(children: spans));
  }
}
