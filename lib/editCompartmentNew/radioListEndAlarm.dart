import 'package:flutter/material.dart';

import '../dataBase.dart';
import 'datePickerAndTimePicker.dart';

typedef SavedCallback = void Function();

class RadioListEndAlarm extends StatefulWidget {
  final Compartment compartment;

  RadioListEndAlarm({
    @required this.compartment,
  });

  @override
  _RadioListEndAlarmState createState() => _RadioListEndAlarmState();
}

enum SelectOptions { option_1, option_2, option_3 }

class _RadioListEndAlarmState extends State<RadioListEndAlarm> {
  SelectOptions currentOption = SelectOptions.option_1;
  double repetitionsEnd;
  
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

  // Future<Null> _selectDateEnd(BuildContext context) async {
  //   DateTime _datePicker = await showDatePicker(
  //       context: context,
  //       initialDate: dateEnd,
  //       firstDate: dateStart,
  //       lastDate: DateTime(2198),
  //       initialDatePickerMode: DatePickerMode.day);

  //   if (_datePicker != null && _datePicker != dateEnd) {
  //     setState(() => dateEnd = _datePicker);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RadioListTile<SelectOptions>(
          title: Text(
            'Nunca',
            style: Theme.of(context).textTheme.bodyText1.copyWith(
                  color: currentOption == SelectOptions.option_1
                      ? Theme.of(context).textTheme.bodyText1.color
                      : Theme.of(context).textTheme.headline4.color,
                ),
          ),
          activeColor: Theme.of(context).accentColor,
          value: SelectOptions.option_1,
          groupValue: currentOption,
          onChanged: (SelectOptions value) =>
              setState(() => currentOption = value),
        ),
        Divider(
          color: Theme.of(context).dividerColor,
          height: 0,
          thickness: 1,
          indent: 72,
        ),
        // RadioListTile<SelectOptions>(
        //   title: Row(
        //     children: [
        //       Text(
        //         'El   ',
        //         style: Theme.of(context).textTheme.bodyText1.copyWith(
        //               color: currentOption == SelectOptions.option_2
        //                   ? Theme.of(context).textTheme.bodyText1.color
        //                   : Theme.of(context).textTheme.headline4.color,
        //             ),
        //       ),
        //       TextButton(
        //         onPressed: () => currentOption != SelectOptions.option_2
        //             ? Container()
        //             : _selectDateEnd(context),
        //         style: Theme.of(context).textButtonTheme.style,
        //         child: Text(
        //           widget.compartment.endDate != null
        //               ? '${_weekday[widget.compartment.endDate.weekday - 1]}, ' +
        //                   '${widget.compartment.endDate.day} de ' +
        //                   '${_yearMonth[widget.compartment.endDate.month - 1]} del ' +
        //                   '${widget.compartment.endDate.year}'
        //               : '${_weekday[dateEnd.weekday - 1]}, ' +
        //                   '${dateEnd.day} de ' +
        //                   '${_yearMonth[dateEnd.month - 1]} del ' +
        //                   '${dateEnd.year}',
        //           style: Theme.of(context).textTheme.bodyText1.copyWith(
        //                 color: currentOption == SelectOptions.option_2
        //                     ? Theme.of(context).textTheme.bodyText2.color
        //                     : Theme.of(context).textTheme.headline4.color,
        //               ),
        //         ),
        //       ),
        //     ],
        //   ),
        //   activeColor: Theme.of(context).accentColor,
        //   value: SelectOptions.option_2,
        //   groupValue: currentOption,
        //   onChanged: (SelectOptions value) =>
        //       setState(() => currentOption = value),
        // ),
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
                      color: currentOption == SelectOptions.option_3
                          ? Theme.of(context).textTheme.bodyText1.color
                          : Theme.of(context).textTheme.headline4.color,
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
                    readOnly:
                        currentOption != SelectOptions.option_3 ? true : false,
                    style: Theme.of(context).textTheme.bodyText1.copyWith(
                          color: currentOption == SelectOptions.option_3
                              ? Theme.of(context).textTheme.bodyText1.color
                              : Theme.of(context).textTheme.headline4.color,
                        ),
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: widget.compartment.repetitionsEnd != null
                          ? widget.compartment.repetitionsEnd != null
                              ? '${widget.compartment.repetitionsEnd}'
                              : '10'
                          : '10',
                      hintStyle: Theme.of(context).textTheme.bodyText1.copyWith(
                            color: currentOption == SelectOptions.option_3
                                ? Theme.of(context).textTheme.bodyText2.color
                                : Theme.of(context).textTheme.headline4.color,
                          ),
                    ),
                    onSubmitted: (String value) =>
                        repetitionsEnd = double.tryParse(value),
                  ),
                ),
              ),
              Text(
                '  repeticiones',
                style: Theme.of(context).textTheme.bodyText1.copyWith(
                      color: currentOption == SelectOptions.option_3
                          ? Theme.of(context).textTheme.bodyText1.color
                          : Theme.of(context).textTheme.headline4.color,
                    ),
              ),
            ],
          ),
          activeColor: Theme.of(context).accentColor,
          value: SelectOptions.option_3,
          groupValue: currentOption,
          onChanged: (SelectOptions value) =>
              setState(() => currentOption = value),
        ),
      ],
    );
  }
}
