import 'package:flutter/material.dart';
import 'package:smartpillboxapp/editCompartmentNew/buttonSave.dart';

import '../dataBase.dart';
import 'bodyEditCompartmentNew.dart';

typedef SavedCallback = void Function();

class EditCompartmentNew extends StatefulWidget {
  final Compartment compartment;
  final SavedCallback onSaved;

  EditCompartmentNew({
    @required this.compartment,
    @required this.onSaved,
  });

  @override
  _EditCompartmentNewState createState() => _EditCompartmentNewState();
}

class _EditCompartmentNewState extends State<EditCompartmentNew> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.color,
        elevation: Theme.of(context).appBarTheme.elevation,
        iconTheme: IconThemeData(
          color: Theme.of(context).iconTheme.color,
        ),
        title: Text(
          'Editar Compartimento ${widget.compartment.id}',
          style: Theme.of(context).textTheme.headline6,
        ),
        actions: [
          ButtonSave(
            compartment: widget.compartment,
            onSaved: widget.onSaved,
          )
        ],
      ),
      body: BodyEditCompartmentNew(
        compartment: widget.compartment,
        onSaved: widget.onSaved,
      ),
    );
  }
}
