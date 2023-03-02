import 'package:flutter/material.dart';
import 'package:robanohashi/api/vocabulary.dart';

class Examples extends StatelessWidget {
  const Examples({
    super.key,
    required this.examples,
  });

  final List<ContextSentence> examples;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: examples.length,
        itemBuilder: (context, index) {
          final example = examples[index];

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(example.ja,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[700],
                  )),
              const SizedBox(height: 5),
              Text(example.hiragana,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  )),
              const SizedBox(height: 5),
              Text(example.en,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  )),
              const SizedBox(height: 5),
              const Divider(),
            ],
          );
        });
  }
}
