import 'package:flutter/material.dart';

class FutureWrapper<T> extends StatelessWidget {
  const FutureWrapper({super.key, required this.future, required this.onData});

  final Future<T> future;
  final Function(BuildContext, T) onData;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting &&
            !snapshot.hasData) {
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

        return onData(context, snapshot.data as T);
      },
    );
  }
}
