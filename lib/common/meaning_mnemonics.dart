import 'dart:math';
import 'package:robanohashi/common/tagged_mnemonic.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'package:flutter/material.dart';
import 'package:robanohashi/api/api.dart';
import 'package:robanohashi/api/meaning_mnemonic.dart';

class MeaningMnemonics extends StatefulWidget {
  const MeaningMnemonics({
    super.key,
    required this.subjectId,
  });

  final int subjectId;

  @override
  State<MeaningMnemonics> createState() => _MeaningMnemonicsState();
}

class _MeaningMnemonicsState extends State<MeaningMnemonics> {
  bool _showForm = false;
  final _formKey = GlobalKey<FormState>();
  late Future<List<MeaningMnemonic>> _mnemonics;

  @override
  void initState() {
    super.initState();

    _mnemonics = Api.fetchMeaningMnemonics(widget.subjectId);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _mnemonics,
      builder: (context, snapshot) {
        if (_showForm) {
          return _buildForm();
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (snapshot.hasError) {
          return Center(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.error),
              SizedBox(width: 10),
              Text('Oops, something went wrong!'),
            ],
          ));
        }

        final data = snapshot.data as List<MeaningMnemonic>;

        return ListView.builder(
            itemCount: data.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) {
                return ElevatedButton.icon(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    setState(() {
                      _showForm = true;
                    });
                  },
                  label: const Text('Add a mnemonic'),
                );
              }

              final mnemonic = data[index - 1];

              return Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.star_border)),
                      Row(children: [
                        Transform.rotate(
                          angle: pi / 2,
                          child: IconButton(
                            iconSize: 30,
                            onPressed: () {},
                            icon: const Icon(
                              Icons.chevron_left,
                            ),
                          ),
                        ),
                        const Text('16'),
                        Transform.rotate(
                            angle: -pi / 2,
                            child: IconButton(
                                iconSize: 30,
                                onPressed: () {},
                                icon: const Icon(Icons.chevron_left)))
                      ]),
                      Expanded(
                        child: Container(),
                      ),
                      const Text(
                        'username',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 5),
                      Text(timeago.format(DateTime.fromMillisecondsSinceEpoch(
                          mnemonic.updatedAt * 1000))),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: TaggedMnemonic(
                            mnemonic: mnemonic.text,
                            tags: const {
                              Tag.kanji,
                              Tag.radical,
                              Tag.vocabulary,
                              Tag.ja,
                            }),
                      ),
                    ],
                  ),
                  const Divider()
                ],
              );
            });
      },
    );
  }

  Form _buildForm() {
    return Form(
      key: _formKey,
      child: Stack(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 10, right: 40.0, top: 25),
                child: TextFormField(
                  maxLines: 50,
                  autofocus: true,
                  style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.w500),
                  decoration: const InputDecoration(
                      hintText: 'The more absurd the better...'),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Material(
                color: Colors.transparent,
                child:
                    IconButton(onPressed: () {}, icon: const Icon(Icons.send))),
          ),
          Align(
            alignment: Alignment.topRight,
            child: Material(
              color: Colors.transparent,
              child: IconButton(
                  onPressed: () => setState(() {
                        _showForm = false;
                      }),
                  icon: const Icon(Icons.close)),
            ),
          ),
        ],
      ),
    );
  }
}
