import 'package:flutter/material.dart';
import 'package:robanohashi/common/colors.dart';

enum Tag {
  ja,
  kanji,
  reading,
  radical,
}

extension TagExtension on Tag {
  String get string {
    switch (this) {
      case Tag.ja:
        return 'ja';
      case Tag.kanji:
        return 'kanji';
      case Tag.reading:
        return 'reading';
      case Tag.radical:
        return 'radical';
      default:
        throw Exception('unsupported tag');
    }
  }
}

// takes in a mnemonic that includes special tokens like <ja> and <kanji> which need highlighting
class TaggedMnemonic extends StatelessWidget {
  const TaggedMnemonic({
    super.key,
    required this.mnemonic,
    required this.tags,
  });

  final String mnemonic;
  final Set<Tag> tags;

  _buildFindRegex() {
    var regex = '';
    for (var tag in tags) {
      regex += '<${tag.string}>(?:(?!<${tag.string}>).)*?<\/${tag.string}>|';
    }
    return RegExp(regex.substring(0, regex.length - 1));
  }

  _buildRemoveRegex() {
    var regex = '';
    for (var tag in tags) {
      regex += '<${tag.string}>|<\/${tag.string}>|';
    }
    return RegExp(regex.substring(0, regex.length - 1));
  }

  TextStyle _getSpecialTokenStyle(String token) {
    if (token.contains("<${Tag.ja.string}>")) {
      return const TextStyle(
        color: Colors.brown,
        fontWeight: FontWeight.w900,
      );
    } else if (token.contains("<${Tag.kanji.string}>")) {
      return TextStyle(
          fontWeight: FontWeight.w900,
          color: getSubjectBackgroundColor('kanji'));
    } else if (token.contains("<${Tag.reading.string}>")) {
      return const TextStyle(color: Colors.black, fontWeight: FontWeight.w900);
    } else if (token.contains("<${Tag.radical.string}>")) {
      return TextStyle(
          fontWeight: FontWeight.w900,
          color: getSubjectBackgroundColor('radical'));
    } else {
      throw Exception('unsupported token');
    }
  }

  @override
  Widget build(BuildContext context) {
    print('LOG: ${_buildFindRegex()}');
    RegExp findExp = _buildFindRegex();
    RegExp removeExp = _buildRemoveRegex();

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
