import 'package:flutter/material.dart';

class FullScreenLoader extends StatelessWidget {
  const FullScreenLoader({super.key});

  Stream<String> getLoadingMessages() {
    final message = <String>[
      'Loading movies',
      'Buying popcorn',
      'Searching for seats',
      'It is taking longer than expected',
    ];

    return Stream.periodic(const Duration(seconds: 2), (step) {
      return message[step];
    }).take(message.length);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('Loading...'),
        const SizedBox(height: 10),
        const CircularProgressIndicator(strokeWidth: 2),
        const SizedBox(height: 10),

        StreamBuilder(
          stream: getLoadingMessages(), 
          builder: (context, snapshot) {
            if (!snapshot.hasData) return const Text('Loading...');
            
            return Text(snapshot.data!);
          },
        )
      ],
    ));
  }
}
