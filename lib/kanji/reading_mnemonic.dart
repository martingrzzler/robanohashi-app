import 'package:flutter/material.dart';

class KanjiReadingMnemonic extends StatelessWidget {
  const KanjiReadingMnemonic({
    super.key,
    required this.mnemonic,
  });

  final String mnemonic;

  TextStyle _getSpecialTokenStyle(String token) {
    if (token.contains("<ja>")) {
      return const TextStyle(
        color: Colors.brown,
        fontWeight: FontWeight.w900,
      );
    } else if (token.contains("<kanji>")) {
      return const TextStyle(fontWeight: FontWeight.w900, color: Colors.pink);
    } else if (token.contains("<reading>")) {
      return const TextStyle(color: Colors.black, fontWeight: FontWeight.w900);
    } else {
      throw ErrorHint('unsupported token');
    }
  }

  @override
  Widget build(BuildContext context) {
    RegExp findExp = RegExp(
        r'<ja>(?:(?!<ja>).)*?<\/ja>|<kanji>(?:(?!<kanji>).)*?<\/kanji>|<reading>(?:(?!<reading>).)*?<\/reading>');
    RegExp removeExp =
        RegExp(r'<kanji>|<\/kanji>|<ja>|<\/ja>|<reading>|<\/reading>');

    final List<TextSpan> spans = [];
    var lastStartIndex = 0;

    for (final match in findExp.allMatches(mnemonic)) {
      spans.add(TextSpan(
        text: mnemonic.substring(lastStartIndex, match.start),
      ));
      final specialToken = mnemonic.substring(match.start, match.end);

      spans.add(TextSpan(
          text: specialToken.replaceAll(removeExp, ""),
          style: _getSpecialTokenStyle(specialToken)));

      lastStartIndex = match.end;
    }

    spans.add(TextSpan(
      text: mnemonic.substring(lastStartIndex, mnemonic.length),
    ));

    return Padding(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: RichText(
            text: TextSpan(
                children: spans,
                style: TextStyle(color: Colors.grey[700], fontSize: 16))));
  }
}
