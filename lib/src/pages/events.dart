import 'package:flutter/cupertino.dart';

class Events extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _EventsState();
}

class _EventsState extends State<Events> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("Aquí van los eventos próximos"),
    );
  }
}
