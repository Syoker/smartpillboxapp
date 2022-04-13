import 'package:flutter/material.dart';

import '../dataBase.dart';

typedef SavedCallback = void Function();

class ButtonDelete extends StatefulWidget {
  final Compartment compartment;
  final SavedCallback onSaved;

  ButtonDelete({
    @required this.compartment,
    @required this.onSaved,
  });

  @override
  _ButtonDeleteState createState() => _ButtonDeleteState();
}

class _ButtonDeleteState extends State<ButtonDelete> {
  @override
  Widget build(BuildContext context) {
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
            style: Theme.of(context).textTheme.bodyText1.copyWith(
                  color: Colors.white,
                ),
          ),
        ),
      ),
    );
  }
}
