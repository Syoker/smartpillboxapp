import 'package:flutter/material.dart';

class RefillPill extends StatefulWidget {
  @override
  _RefillPillState createState() => _RefillPillState();
}

class _RefillPillState extends State<RefillPill> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Recargar pastillas',
        style: Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 20),
      ),
      contentPadding: EdgeInsets.fromLTRB(24, 16, 16, 0),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Text(
              'Actualmente, el pastillero se puso en modo de recarga de pastillas, lo que significa que todos los compartimentos estan habilitados, una vez que haya recargado las pastillas, precione "Aceptar" para volver al modo normal',
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ],
        ),
      ),
      buttonPadding: EdgeInsets.fromLTRB(16, 0, 16, 16),
      actions: <Widget>[
        TextButton(
          child: Text(
            'Aceptar',
            style: Theme.of(context).textTheme.headline5.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
