import 'package:flutter/material.dart';
import 'package:smartpillboxapp/editCompartmentNew/buttonDelete.dart';

import '../dataBase.dart';
import 'datePickerAndTimePicker.dart';
import 'radioListEndAlarm.dart';

typedef SavedCallback = void Function();

class BodyEditCompartmentNew extends StatefulWidget {
  final Compartment compartment;
  final SavedCallback onSaved;

  BodyEditCompartmentNew({
    @required this.compartment,
    @required this.onSaved,
  });

  @override
  _BodyEditCompartmentNewState createState() => _BodyEditCompartmentNewState();
}

class _BodyEditCompartmentNewState extends State<BodyEditCompartmentNew> {
  int repetitionsText;
  final titleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(56, 16, 16, 0),
            child: TextField(
              controller: titleController,
              style: Theme.of(context).textTheme.headline4.copyWith(
                    color: Theme.of(context).textTheme.bodyText1.color,
                  ),
              decoration: InputDecoration(
                hintText: widget.compartment.name != null
                    ? widget.compartment.name != 'null'
                        ? widget.compartment.name != ''
                            ? widget.compartment.name
                            : 'Ingresar nombre de pastilla'
                        : 'Ingresar nombre de pastilla'
                    : 'Ingresar nombre de pastilla',
                hintStyle: Theme.of(context).textTheme.headline4,
                border: InputBorder.none,
              ),
            ),
          ),
          Divider(
            color: Theme.of(context).dividerColor,
            thickness: 1,
            indent: 16,
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
              )
            ],
          ),
          Container(
            margin: EdgeInsets.fromLTRB(56, 0, 16, 16),
            child: DatePickerAndTimePicker(compartment: widget.compartment),
          ),
          Divider(
            color: Theme.of(context).dividerColor,
            thickness: 1,
            indent: 56,
          ),
          Container(
            margin: EdgeInsets.fromLTRB(56, 8, 16, 8),
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
                      onSubmitted: (String value) =>
                          repetitionsText = int.tryParse(value),
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
            child: RadioListEndAlarm(
              compartment: widget.compartment,
            ),
          ),
          widget.compartment.repetitions != null
              ? ButtonDelete(
                  compartment: widget.compartment,
                  onSaved: widget.onSaved,
                )
              : Container(),
        ],
      ),
    );
  }
}
