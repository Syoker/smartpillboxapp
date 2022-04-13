import 'package:flutter/material.dart';

import 'bodyHomePage.dart';
import 'refillPill.dart';

enum Acciones { recargar_pastillas, configuracion, acerca_de }

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Compartimentos',
          style: Theme.of(context).textTheme.headline6,
        ),
        centerTitle: true,
        elevation: Theme.of(context).appBarTheme.elevation,
        backgroundColor: Theme.of(context).appBarTheme.color,
        actions: [
          PopupMenuButton(
            tooltip: 'Menu',
            icon: Icon(
              Icons.more_vert,
              color: Theme.of(context).iconTheme.color,
            ),
            itemBuilder: (context) {
              return <PopupMenuItem<Acciones>>[
                const PopupMenuItem<Acciones>(
                  value: Acciones.recargar_pastillas,
                  child: Text('Recargar Pastillas'),
                ),
                const PopupMenuItem<Acciones>(
                  value: Acciones.configuracion,
                  child: Text('Configuración'),
                ),
                const PopupMenuItem<Acciones>(
                  value: Acciones.acerca_de,
                  child: Text('Acerca de'),
                ),
              ];
            },
            onSelected: (value) {
              if (value == Acciones.configuracion) {
                Navigator.of(context).pushNamed('/setting');
              } else if (value == Acciones.acerca_de) {
                showAboutDialog(
                  context: context,
                  applicationName: 'Smart Pillbox',
                  applicationVersion: '1.0.0',
                  applicationLegalese: '2020 Ragtal',
                  children: [
                    Container(
                      margin: EdgeInsets.fromLTRB(24, 8, 24, 0),
                      child: Text(
                        'Somos un pequeño grupo empezando ' +
                            'con un proyecto de un pastillero automatizado diferente ' +
                            'a los ya existentes, tratando de abaratar los costos ' +
                            'y que este disponible para la mayor cantidad de personas posibles',
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                    )
                  ],
                );
              } else if (value == Acciones.recargar_pastillas) {
                _refillPill();
              }
            },
          ),
        ],
      ),
      body: Body(),
      backgroundColor: Theme.of(context).backgroundColor,
    );
  }

  Future<void> _refillPill() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return RefillPill();
      },
    );
  }
}
