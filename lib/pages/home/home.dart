import 'package:flutter/material.dart';
import 'package:robanohashi/pages/home/donkey.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        Center(
          child: Text(
            '驢馬の橋',
            style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        SizedBox(height: 50),
        Center(
          child: Text(
            '9000 Kanji',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Center(
          child: Text(
            '75000 Vocabulary',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        SizedBox(height: 50),
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            'Learn with existing mnemonics or create your own and share them with the community!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        SizedBox(height: 50),
        Donkey()
      ],
    );
  }
}
