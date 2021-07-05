import 'package:flutter/material.dart';

class MessageView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments ?? 'No data';

    return Scaffold(
        appBar: AppBar(
          title: Text('Alarma'),
        ),
        body: Center(
          child: Text('¡Tienes una alarma programada para $args !'),
        ));
  }
}
