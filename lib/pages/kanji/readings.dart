import 'package:flutter/material.dart';

import '../../api/kanji.dart';

class KanjiReadings extends StatelessWidget {
  const KanjiReadings({
    super.key,
    required this.readings,
  });

  final List<KanjiReading> readings;

  KanjiReading? _findByType(String type) {
    final res = readings.where((element) => element.type == type);
    return res.isNotEmpty ? res.first : null;
  }

  Widget _buildReading(String type, String label) {
    final reading = _findByType(type);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SelectableText(
          reading?.reading ?? 'None',
          style: TextStyle(
              fontSize: 18,
              height: 1.2,
              fontWeight: reading != null ? FontWeight.bold : FontWeight.normal,
              color: reading != null ? Colors.grey[700] : Colors.grey[400]),
        ),
        Text(label, style: TextStyle(color: Colors.grey[400])),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        _buildReading("onyomi", "On'yomi"),
        _buildReading('kunyomi', 'Kun\'yomi'),
        _buildReading('nanori', 'Nanori'),
      ],
    );
  }
}
