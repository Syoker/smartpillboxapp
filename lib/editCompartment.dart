import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:day_night_time_picker/day_night_time_picker.dart';

import 'dataBase.dart';

enum SelectOptions { option_1, option_2, option_3 }

typedef SavedCallback = void Function();

class EditCompartment extends StatefulWidget {
  final Compartment compartment;
  final SavedCallback onSaved;

  EditCompartment({
    @required this.compartment,
    this.onSaved,
  });

  @override
  _EditCompartmentState createState() => _EditCompartmentState();
}

class _EditCompartmentState extends State<EditCompartment> {

  DateTime _dateStart = DateTime.now();
  DateTime _dateEnd = DateTime.now();
  DateTime _dateTomorrow = DateTime.now().add(Duration(days: 1));
  TimeOfDay _time = TimeOfDay.now();
  TimeOfDay _controllerTimes = TimeOfDay.now();
  DateTime _controllerDate = DateTime.now();
  DateTime _finalDateEnd = DateTime.now();
  DateTime _finalDateStart = DateTime.now();
  double repetitionsEnd;
  SelectOptions _currentOption = SelectOptions.option_1;
  int repetitionsText;
  final titleController = TextEditingController();
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

  void onTimeChanged(TimeOfDay newTime) {
    setState(() {
      _time = newTime;
    });
  }

  @override
  void dispose() {
    titleController.dispose();
    super.dispose();
  }

  Future<Null> _selectDateStart(BuildContext context) async {
    DateTime _datePicker = await showDatePicker(
        context: context,
        initialDate: _dateStart,
        firstDate: DateTime.now(),
        lastDate: DateTime(2198),
        initialDatePickerMode: DatePickerMode.day);

    if (_datePicker != null && _datePicker != _dateStart) {
      setState(
        () {
          _dateStart = _datePicker;
          _dateEnd = _datePicker;
        },
      );
    }
  }

  Future<Null> _selectDateEnd(BuildContext context) async {
    DateTime _datePicker = await showDatePicker(
        context: context,
        initialDate: _dateEnd,
        firstDate: _dateStart,
        lastDate: DateTime(2198),
        initialDatePickerMode: DatePickerMode.day);

    if (_datePicker != null && _datePicker != _dateEnd) {
      setState(
        () {
          _dateEnd = _datePicker;
        },
      );
    }
  }

  String horaToString(TimeOfDay hora) {
    var horaEnTexto = hora.hour < 10 ? '0${hora.hour}' : hora.hour.toString();
    var minutoEnTexto =
        hora.minute < 10 ? '0${hora.minute}' : hora.minute.toString();

    return '$horaEnTexto:$minutoEnTexto';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Editar compartimento ${widget.compartment.id}',
          style: Theme.of(context).textTheme.headline6,
        ),
        actions: [
          Container(
            margin: EdgeInsets.fromLTRB(0, 12, 16, 12),
            child: ElevatedButton(
              style: Theme.of(context).elevatedButtonTheme.style,
              onPressed: () async {
                var myDb = MyDatabase.instance;

                if (!myDb.initialized) {
                  await myDb.initialize();
                }

                double repetitions;

                switch (_currentOption) {
                  case SelectOptions.option_1:
                    _finalDateEnd = null;
                    repetitionsEnd = null;
                    repetitions = repetitionsText != null ? repetitionsText : 8;
                    repetitionsText =
                        repetitionsText != null && repetitionsText != 0
                            ? repetitionsText
                            : 8;
                    break;
                  case SelectOptions.option_2:
                    if (repetitionsText != null && repetitionsText != 0) {
                      Duration difference = _dateEnd.difference(_dateStart);
                      int hoursDifference =
                          difference.inDays != 0 ? 24 * difference.inDays : 24;
                      repetitions =
                          ((hoursDifference - _time.hour) / repetitionsText) +
                              1;
                      repetitionsEnd = null;
                    } else {
                      Duration difference = _dateEnd.difference(_dateStart);
                      int hoursDifference =
                          difference.inDays != 0 ? 24 * difference.inDays : 24;
                      repetitions = ((hoursDifference - _time.hour) / 8) + 1;
                      repetitionsEnd = null;
                    }
                    _finalDateEnd = _dateEnd;
                    break;
                  case SelectOptions.option_3:
                    _finalDateEnd = null;
                    repetitions = repetitionsEnd != null ? repetitionsEnd : 10;
                    repetitionsEnd =
                        repetitionsEnd != null ? repetitionsEnd : 10;
                    repetitionsText =
                        repetitionsText != null && repetitionsText != 0
                            ? repetitionsText
                            : 8;
                    break;
                }

                _finalDateStart = _time.hour == _controllerTimes.hour &&
                        _time.minute == _controllerTimes.minute &&
                        _dateStart.day == _controllerDate.day &&
                        _dateStart.month == _controllerDate.month &&
                        _dateStart.year == _controllerDate.year
                    ? _dateTomorrow
                    : _dateStart;

                await myDb.updateCompartment(
                  Compartment(
                    id: widget.compartment.id,
                    name: titleController.text.toString(),
                    repetitions: repetitions.toInt(),
                    hour: _time,
                    startDate: _finalDateStart,
                    repetitionsNum: repetitionsText,
                    endDate: _finalDateEnd,
                    repetitionsEnd: repetitionsEnd?.toInt(),
                  ),
                );

                widget.onSaved();

                Navigator.pop(context);
              },
              child: Text(
                "Guardar",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontFamily: 'SourceSansPro',
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
        ],
        backgroundColor: Theme.of(context).appBarTheme.color,
        iconTheme: Theme.of(context).iconTheme,
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.fromLTRB(56, 16, 16, 0),
              child: TextField(
                controller: titleController,
                style: Theme.of(context).textTheme.bodyText1.copyWith(
                      fontSize: 28,
                    ),
                decoration: InputDecoration(
                  hintText: widget.compartment.name != null
                      ? widget.compartment.name != 'null'
                          ? widget.compartment.name != ''
                              ? widget.compartment.name
                              : 'Ingresar nombre de pastilla'
                          : 'Ingresar nombre de pastilla'
                      : 'Ingresar nombre de pastilla',
                  border: InputBorder.none,
                  hintStyle: Theme.of(context).textTheme.headline4,
                ),
              ),
            ),
            Divider(
              color: Theme.of(context).dividerColor,
              height: 0,
              thickness: 1,
              indent: 16,
              endIndent: 0,
            ),
            Row(
              children: [
                Container(
                  margin: EdgeInsets.all(16),
                  child: Icon(
                    Icons.schedule,
                    color: Theme.of(context).iconTheme.color,
                  ),
                ),
                Text(
                  'Empieza desde',
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.fromLTRB(56, 0, 16, 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      _selectDateStart(context);
                    },
                    style: Theme.of(context).textButtonTheme.style,
                    child: Text(
                      widget.compartment.startDate != null
                          ? '${_weekday[widget.compartment.startDate.weekday - 1]}, ${widget.compartment.startDate.day} de ${_yearMonth[widget.compartment.startDate.month - 1]} del ${widget.compartment.startDate.year}'
                          : '${_weekday[_dateStart.weekday - 1]}, ${_dateStart.day} de ${_yearMonth[_dateStart.month - 1]} del ${_dateStart.year}',
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        showPicker(
                          context: context,
                          value: _time,
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
                          : horaToString(_time),
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              color: Theme.of(context).dividerColor,
              height: 0,
              thickness: 1,
              indent: 56,
            ),
            Container(
              margin: EdgeInsets.fromLTRB(56, 16, 16, 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Se repite cada  ',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  Card(
                    color: Theme.of(context).hintColor,
                    elevation: 0,
                    child: Container(
                      width: 56,
                      height: 48,
                      child: TextField(
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyText1,
                        decoration: InputDecoration(
                          hintText: widget.compartment.repetitionsNum != null
                              ? widget.compartment.repetitionsNum != null
                                  ? '${widget.compartment.repetitionsNum}'
                                  : '8'
                              : '8',
                          border: InputBorder.none,
                          hintStyle: Theme.of(context).textTheme.bodyText2,
                        ),
                        onSubmitted: (String value) {
                          repetitionsText = int.tryParse(value);
                        },
                      ),
                    ),
                  ),
                  Text(
                    '  horas',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ],
              ),
            ),
            Divider(
              color: Theme.of(context).dividerColor,
              height: 16,
              thickness: 1,
              indent: 56,
            ),
            Container(
              margin: EdgeInsets.fromLTRB(56, 16, 0, 8),
              child: Text(
                'Finaliza',
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 28),
              child: Column(
                children: <Widget>[
                  RadioListTile<SelectOptions>(
                    title: Text(
                      'Nunca',
                      style: Theme.of(context).textTheme.bodyText1.copyWith(
                            color: _currentOption == SelectOptions.option_1
                                ? Theme.of(context).textTheme.bodyText1.color
                                : Theme.of(context).textTheme.headline4.color,
                          ),
                    ),
                    activeColor: Theme.of(context).accentColor,
                    value: SelectOptions.option_1,
                    groupValue: _currentOption,
                    onChanged: (SelectOptions value) {
                      setState(
                        () {
                          _currentOption = value;
                        },
                      );
                    },
                  ),
                  Divider(
                    color: Theme.of(context).dividerColor,
                    height: 0,
                    thickness: 1,
                    indent: 72,
                  ),
                  RadioListTile<SelectOptions>(
                    title: Row(
                      children: [
                        Text(
                          'El   ',
                          style: Theme.of(context).textTheme.bodyText1.copyWith(
                                color: _currentOption == SelectOptions.option_2
                                    ? Theme.of(context)
                                        .textTheme
                                        .bodyText1
                                        .color
                                    : Theme.of(context)
                                        .textTheme
                                        .headline4
                                        .color,
                              ),
                        ),
                        TextButton(
                          onPressed: () {
                            _currentOption != SelectOptions.option_2
                                ? _nothing()
                                : _selectDateEnd(context);
                          },
                          style: Theme.of(context).textButtonTheme.style,
                          child: Text(
                            widget.compartment.endDate != null
                                ? '${_weekday[widget.compartment.endDate.weekday - 1]}, ${widget.compartment.endDate.day} de ${_yearMonth[widget.compartment.endDate.month - 1]} del ${widget.compartment.endDate.year}'
                                : '${_weekday[_dateEnd.weekday - 1]}, ${_dateEnd.day} de ${_yearMonth[_dateEnd.month - 1]} del ${_dateEnd.year}',
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1
                                .copyWith(
                                  color:
                                      _currentOption == SelectOptions.option_2
                                          ? Theme.of(context)
                                              .textTheme
                                              .bodyText2
                                              .color
                                          : Theme.of(context)
                                              .textTheme
                                              .headline4
                                              .color,
                                ),
                          ),
                        ),
                      ],
                    ),
                    activeColor: Theme.of(context).accentColor,
                    value: SelectOptions.option_2,
                    groupValue: _currentOption,
                    onChanged: (SelectOptions value) {
                      setState(
                        () {
                          _currentOption = value;
                        },
                      );
                    },
                  ),
                  Divider(
                    color: Theme.of(context).dividerColor,
                    height: 0,
                    thickness: 1,
                    indent: 72,
                  ),
                  RadioListTile<SelectOptions>(
                    title: Row(
                      children: [
                        Text(
                          'Después de  ',
                          style: Theme.of(context).textTheme.bodyText1.copyWith(
                                color: _currentOption == SelectOptions.option_3
                                    ? Theme.of(context)
                                        .textTheme
                                        .bodyText1
                                        .color
                                    : Theme.of(context)
                                        .textTheme
                                        .headline4
                                        .color,
                              ),
                        ),
                        Card(
                          color: Theme.of(context).hintColor,
                          elevation: 0,
                          child: Container(
                            width: 56,
                            height: 48,
                            child: TextField(
                              textAlign: TextAlign.center,
                              readOnly: _currentOption != SelectOptions.option_3
                                  ? true
                                  : false,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1
                                  .copyWith(
                                    color:
                                        _currentOption == SelectOptions.option_3
                                            ? Theme.of(context)
                                                .textTheme
                                                .bodyText1
                                                .color
                                            : Theme.of(context)
                                                .textTheme
                                                .headline4
                                                .color,
                                  ),
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: widget.compartment.repetitionsEnd !=
                                        null
                                    ? widget.compartment.repetitionsEnd != null
                                        ? '${widget.compartment.repetitionsEnd}'
                                        : '10'
                                    : '10',
                                hintStyle: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    .copyWith(
                                      color: _currentOption ==
                                              SelectOptions.option_3
                                          ? Theme.of(context)
                                              .textTheme
                                              .bodyText2
                                              .color
                                          : Theme.of(context)
                                              .textTheme
                                              .headline4
                                              .color,
                                    ),
                              ),
                              onSubmitted: (String value) {
                                repetitionsEnd = double.tryParse(value);
                              },
                            ),
                          ),
                        ),
                        Text(
                          '  repeticiones',
                          style: Theme.of(context).textTheme.bodyText1.copyWith(
                                color: _currentOption == SelectOptions.option_3
                                    ? Theme.of(context)
                                        .textTheme
                                        .bodyText1
                                        .color
                                    : Theme.of(context)
                                        .textTheme
                                        .headline4
                                        .color,
                              ),
                        ),
                      ],
                    ),
                    activeColor: Theme.of(context).accentColor,
                    value: SelectOptions.option_3,
                    groupValue: _currentOption,
                    onChanged: (SelectOptions value) {
                      setState(
                        () {
                          _currentOption = value;
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
            widget.compartment.repetitions != null
                ? _buttonDelete()
                : _nothing(),
          ],
          crossAxisAlignment: CrossAxisAlignment.start,
        ),
      ),
    );
  }

  _buttonDelete() {
    return Container(
      margin: EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: ListTile(
        title: ElevatedButton(
          style: Theme.of(context).elevatedButtonTheme.style.copyWith(
                backgroundColor:
                    MaterialStateProperty.all(Theme.of(context).buttonColor),
              ),
          onPressed: () async {
            var myDb = MyDatabase.instance;

            if (!myDb.initialized) {
              await myDb.initialize();
            }

            await myDb.updateCompartment(
              Compartment(
                id: widget.compartment.id,
                name: null,
                repetitions: null,
                hour: null,
                startDate: null,
                repetitionsNum: null,
                endDate: null,
                repetitionsEnd: null,
              ),
            );
            widget.onSaved();
            Navigator.pop(context);
          },
          child: Text(
            "Borrar alarma",
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontFamily: 'SourceSansPro',
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }

  _nothing() {
    return Container();
  }
}
