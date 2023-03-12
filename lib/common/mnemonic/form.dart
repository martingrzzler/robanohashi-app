import 'package:flutter/material.dart';
import 'package:robanohashi/api/meaning_mnemonic.dart';

class FormConfig {
  FormConfig({
    required this.editing,
    this.mnemonic,
  });

  final bool editing;
  final MeaningMnemonicWithUserInfo? mnemonic;
}

class MnemonicForm extends StatefulWidget {
  const MnemonicForm(
      {super.key,
      required this.onClose,
      required this.onSubmit,
      this.defaultText});

  final Function onClose;
  final Function(String text) onSubmit;
  final String? defaultText;

  @override
  State<MnemonicForm> createState() => MnemonicFormState();
}

class MnemonicFormState extends State<MnemonicForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _controller;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.defaultText);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 10, right: 40.0, top: 25),
              child: TextFormField(
                controller: _controller,
                maxLines: 50,
                autofocus: true,
                style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.w500),
                decoration: const InputDecoration(
                    hintText: 'The more absurd the better...'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Material(
                color: Colors.transparent,
                child: IconButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        widget.onSubmit(_controller.text);
                      }
                    },
                    icon: const Icon(Icons.send))),
          ),
          Align(
            alignment: Alignment.topRight,
            child: Material(
              color: Colors.transparent,
              child: IconButton(
                  onPressed: () => widget.onClose(),
                  icon: const Icon(Icons.close)),
            ),
          ),
        ],
      ),
    );
  }
}
