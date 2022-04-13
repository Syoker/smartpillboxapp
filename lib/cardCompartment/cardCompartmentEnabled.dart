import 'package:flutter/material.dart';

import '../dataBase.dart';

class CardCompartmentEnabled extends StatefulWidget {
  final Compartment compartment;

  CardCompartmentEnabled({
    @required this.compartment,
  });

  @override
  _CardCompartmentEnabledState createState() => _CardCompartmentEnabledState();
}

class _CardCompartmentEnabledState extends State<CardCompartmentEnabled> {
  bool pauseAlarm = true;
  DateTime _controllDateNow = DateTime.now();
  DateTime _controllDateTomorrow = DateTime.now().add(Duration(days: 1));
  List<String> _weekday = <String>[
    'Lun.',
    'Mar.',
    'Mie.',
    'Jue.',
    'Vie.',
    'Sáb.',
    'Dom.',
  ];

  List<String> _yearMonth = <String>[
    'ene.',
    'feb.',
    'mar.',
    'abr.',
    'may.',
    'jun.',
    'jul.',
    'ago.',
    'sep.',
    'oct.',
    'nov.',
    'dic.',
  ];

  String horaToString(TimeOfDay hora) {
    var horaEnTexto = hora.hour < 10 ? '0${hora.hour}' : hora.hour.toString();
    var minutoEnTexto =
        hora.minute < 10 ? '0${hora.minute}' : hora.minute.toString();

    return '$horaEnTexto:$minutoEnTexto';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).cardColor,
      padding: EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(bottom: 8),
                child: Text('COMPARTIMENTO ${widget.compartment.id}',
                    style: Theme.of(context).textTheme.overline.copyWith(
                          fontWeight: FontWeight.w600,
                        )),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 8),
                child: Text(
                  horaToString(widget.compartment.hour),
                  style: Theme.of(context).textTheme.headline5,
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 12),
                child: Text(
                  '${widget.compartment.name == null || widget.compartment.name == '' ? 'Sin nombre' : widget.compartment.name} - ${widget.compartment.startDate.day == _controllDateNow.day ? 'Hoy' : widget.compartment.startDate.day == _controllDateTomorrow.day ? 'Mañana' : _weekday[widget.compartment.startDate.weekday - 1]}, ${widget.compartment.startDate.day} de ${_yearMonth[widget.compartment.startDate.month - 1]} del ${widget.compartment.startDate.year}',
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ),
              Text(
                widget.compartment.repetitionsEnd == null
                    ? widget.compartment.endDate == null
                        ? 'LAS REPETICIONES SON INFINITAS'
                        : 'QUEDAN ${widget.compartment.repetitions} REPETICIONES'
                    : 'QUEDAN ${widget.compartment.repetitions} REPETICIONES',
                style: Theme.of(context).textTheme.overline,
              ),
            ],
          ),
          Switch(
            activeColor: Theme.of(context).accentColor,
            value: pauseAlarm,
            onChanged: (value) => setState(() => this.pauseAlarm = value),
          ),
        ],
      ),
    );
  }
}
