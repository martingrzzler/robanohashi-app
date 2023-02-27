import 'package:flutter/material.dart';
import 'package:robanohashi/custom_tab_bar.dart';
import 'mnemonic_text.dart';

class Kanji extends StatelessWidget {
  const Kanji({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Roba no hashi'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(children: const [
          Definition(),
          Divider(),
          RadicalComposition(),
          Expanded(
            child: CustomTabBar(tabs: [
              Text('Meaning'),
              Text('Reading')
            ], children: [
              MnemonicText(
                text:
                    "You use a special spear in winter to give yourself the power to do all of your tasks. It's hard to get a task done in winter. That's why you have this spear to power and motivate you.",
                meanings: {
                  'spear': Token.radical,
                  'winter': Token.radical,
                  'power': Token.radical,
                  'task': Token.kanji,
                },
              ),
              Text('Reading')
            ]),
          )
        ]),
      ),
    );
  }
}

class RadicalComposition extends StatelessWidget {
  const RadicalComposition({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Column(
          children: [
            Card(
              color: Colors.blue[400],
              child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 7.5),
                  child: Text(
                    '矛',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 30.0,
                        fontFamily: 'Noto Sans Japanese'),
                  )),
            ),
            Text(
              'Spear',
              style: TextStyle(color: Colors.grey[600], fontSize: 15.0),
            )
          ],
        ),
        Text(
          '+',
          style: TextStyle(fontSize: 30.0, color: Colors.grey[600]),
        ),
        Column(
          children: [
            Card(
              color: Colors.blue[400],
              child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 7.5),
                  child: Text(
                    '夂',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 30.0,
                        fontFamily: 'Noto Sans Japanese'),
                  )),
            ),
            Text(
              'Winter',
              style: TextStyle(color: Colors.grey[600], fontSize: 15.0),
            )
          ],
        ),
        Text(
          '+',
          style: TextStyle(fontSize: 30.0, color: Colors.grey[600]),
        ),
        Column(
          children: [
            Card(
              color: Colors.blue[400],
              child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 7.5),
                  child: Text(
                    '力',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 30.0,
                        fontFamily: 'Noto Sans Japanese'),
                  )),
            ),
            Text(
              'Power',
              style: TextStyle(color: Colors.grey[600], fontSize: 15.0),
            )
          ],
        ),
      ],
    );
  }
}

class Definition extends StatelessWidget {
  const Definition({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Card(
        color: Colors.purple[400],
        child: const Padding(
          padding: EdgeInsets.only(left: 20, right: 20, bottom: 2),
          child: Text('務',
              style: TextStyle(
                  fontSize: 50,
                  color: Colors.white,
                  fontFamily: 'Noto Sans Japanese')),
        ),
      ),
      const SizedBox(
        width: 10.0,
      ),
      Text(
        'Task',
        style: TextStyle(fontSize: 20.0, color: Colors.grey[600]),
      ),
      const Expanded(child: SizedBox()),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('On\'yomi', style: TextStyle(color: Colors.grey[400])),
          const Text(
            'む',
            style: TextStyle(fontFamily: 'Noto Sans Japanese'),
          ),
          const SizedBox(
            height: 10.0,
          ),
          Text('Kun\'yomi', style: TextStyle(color: Colors.grey[400])),
          const Text(
            'つと',
            style: TextStyle(fontFamily: 'Noto Sans Japanese'),
          )
        ],
      )
    ]);
  }
}
