import 'package:flutter/material.dart';

import '../dataBase.dart';

class CardCompartmentDisabled extends StatefulWidget {
  final Compartment compartment;

  CardCompartmentDisabled({
    @required this.compartment,
  });

  @override
  _CardCompartmentDisabledState createState() =>
      _CardCompartmentDisabledState();
}

class _CardCompartmentDisabledState extends State<CardCompartmentDisabled> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).cardColor,
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          Text(
            'Compartimento ${widget.compartment.id}',
            style: Theme.of(context).textTheme.bodyText1,
          ),
          Icon(
            Icons.alarm_off,
            color: Theme.of(context).iconTheme.color,
            size: 80,
          ),
          Text(
            'Sin configurar alarma',
            style: Theme.of(context).textTheme.bodyText1,
          ),
        ],
      ),
    );
  }
}
