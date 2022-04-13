import 'package:flutter/material.dart';

import '../dataBase.dart';
import 'bodyEditCompartmentNew.dart';
import 'radioListEndAlarm.dart';
import 'datePickerAndTimePicker.dart';

typedef SavedCallback = void Function();

class ButtonSave extends StatefulWidget {
  final Compartment compartment;
  final SavedCallback onSaved;

  ButtonSave({
    @required this.compartment,
    @required this.onSaved,
  });

  @override
  _ButtonSaveState createState() => _ButtonSaveState();
}

class _ButtonSaveState extends State<ButtonSave> {
  TimeOfDay _controllerTimes = TimeOfDay.now();
  DateTime _controllerDate = DateTime.now();
  DateTime _finalDateEnd = DateTime.now();
  DateTime _finalDateStart = DateTime.now();
  DateTime _dateTomorrow = DateTime.now().add(Duration(days: 1));

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 12, 16, 12),
      child: ElevatedButton(
        onPressed: () async {
          // var myDb = MyDatabase.instance;

          // if (!myDb.initialized) {
          //   await myDb.initialize();
          // }

          // double repetitions;

          // switch (currentOption) {
          //   case SelectOptions.option_1:
          //     _finalDateEnd = null;
          //     repetitionsEnd = null;
          //     repetitions = repetitionsText != null ? repetitionsText : 8;
          //     repetitionsText = repetitionsText != null && repetitionsText != 0
          //         ? repetitionsText
          //         : 8;
          //     break;
          //   case SelectOptions.option_2:
          //     if (repetitionsText != null && repetitionsText != 0) {
          //       Duration difference = dateEnd.difference(dateStart);
          //       int hoursDifference =
          //           difference.inDays != 0 ? 24 * difference.inDays : 24;
          //       repetitions =
          //           ((hoursDifference - time.hour) / repetitionsText) + 1;
          //       repetitionsEnd = null;
          //     } else {
          //       Duration difference = dateEnd.difference(dateStart);
          //       int hoursDifference =
          //           difference.inDays != 0 ? 24 * difference.inDays : 24;
          //       repetitions = ((hoursDifference - time.hour) / 8) + 1;
          //       repetitionsEnd = null;
          //     }
          //     _finalDateEnd = dateEnd;
          //     break;
          //   case SelectOptions.option_3:
          //     _finalDateEnd = null;
          //     repetitions = repetitionsEnd != null ? repetitionsEnd : 10;
          //     repetitionsEnd = repetitionsEnd != null ? repetitionsEnd : 10;
          //     repetitionsText = repetitionsText != null && repetitionsText != 0
          //         ? repetitionsText
          //         : 8;
          //     break;
          // }

          // _finalDateStart = time.hour == _controllerTimes.hour &&
          //         time.minute == _controllerTimes.minute &&
          //         dateStart.day == _controllerDate.day &&
          //         dateStart.month == _controllerDate.month &&
          //         dateStart.year == _controllerDate.year
          //     ? _dateTomorrow
          //     : dateStart;

          // await myDb.updateCompartment(
          //   Compartment(
          //     id: widget.compartment.id,
          //     name: titleController.text.toString(),
          //     repetitions: repetitions.toInt(),
          //     hour: time,
          //     startDate: _finalDateStart,
          //     repetitionsNum: repetitionsText,
          //     endDate: _finalDateEnd,
          //     repetitionsEnd: repetitionsEnd?.toInt(),
          //   ),
          // );

          // widget.onSaved();

          Navigator.pop(context);
        },
        child: Text(
          'Guardar',
          style: Theme.of(context).textTheme.bodyText1,
        ),
      ),
    );
  }
}
