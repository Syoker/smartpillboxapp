import 'package:flutter/material.dart';
import 'package:day_night_time_picker/day_night_time_picker.dart';

import '../dataBase.dart';

typedef SavedCallback = void Function();

class DatePickerAndTimePicker extends StatefulWidget {
  final Compartment compartment;

  DatePickerAndTimePicker({
    @required this.compartment,
  });

  @override
  _DatePickerAndTimePickerState createState() =>
      _DatePickerAndTimePickerState();
}

class _DatePickerAndTimePickerState extends State<DatePickerAndTimePicker> {
  DateTime dateStart = DateTime.now();
  DateTime dateEnd = DateTime.now();
  TimeOfDay time = TimeOfDay.now();
  
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

  Future<Null> selectDateStart(BuildContext context) async {
    DateTime _datePicker = await showDatePicker(
        context: context,
        initialDate: dateStart,
        firstDate: DateTime.now(),
        lastDate: DateTime(2198),
        initialDatePickerMode: DatePickerMode.day);

    if (_datePicker != null && _datePicker != dateStart) {
      setState(() {
        dateStart = _datePicker;
        dateEnd = _datePicker;
      });
    }
  }

  void onTimeChanged(TimeOfDay newTime) {
    setState(() => time = newTime);
  }

  String horaToString(TimeOfDay hora) {
    var horaEnTexto = hora.hour < 10 ? '0${hora.hour}' : hora.hour.toString();
    var minutoEnTexto =
        hora.minute < 10 ? '0${hora.minute}' : hora.minute.toString();

    return '$horaEnTexto:$minutoEnTexto';
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextButton(
          onPressed: () async => selectDateStart(context),
          style: Theme.of(context).textButtonTheme.style,
          child: Text(
            widget.compartment.startDate != null
                ? '${_weekday[widget.compartment.startDate.weekday - 1]}, ' +
                    '${widget.compartment.startDate.day} de ' +
                    '${_yearMonth[widget.compartment.startDate.month - 1]} del ' +
                    '${widget.compartment.startDate.year}'
                : '${_weekday[dateStart.weekday - 1]}, ' +
                    '${dateStart.day} de ${_yearMonth[dateStart.month - 1]} del ' +
                    '${dateStart.year}',
            style: Theme.of(context).textTheme.bodyText2,
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).push(
              showPicker(
                context: context,
                value: time,
                onChange: onTimeChanged,
                is24HrFormat: true,
                okText: 'Guardar',
                cancelText: 'Cancelar',
              ),
            );
          },
          style: Theme.of(context).textButtonTheme.style,
          child: Text(
            widget.compartment.hour != null
                ? horaToString(widget.compartment.hour)
                : horaToString(time),
            style: Theme.of(context).textTheme.bodyText2,
          ),
        ),
      ],
    );
  }
}
