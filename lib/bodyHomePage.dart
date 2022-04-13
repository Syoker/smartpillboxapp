import 'dart:math';
import 'package:animations/animations.dart';
import 'package:flutter/material.dart';

import 'editCompartment.dart';
import 'editCompartmentNew/editCompartmentNew.dart';
import 'cardCompartment/cardCompartmentEnabled.dart';
import 'cardCompartment/cardCompartmentDisabled.dart';
import 'dataBase.dart';

typedef WhiteCallback = void Function();

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  var list;
  var random;
  var refreshKey = GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    random = Random();
    refreshList();
  }

  Future<Null> refreshList() async {
    refreshKey.currentState?.show();
    await Future.delayed(Duration(seconds: 2));
    setState(() {
      list = List.generate(random.nextInt(10), (i) => "Item $i");
    });
    return null;
  }

  Future<List<Compartment>> getListCompartment() async {
    var myDb = MyDatabase.instance;

    if (!myDb.initialized) {
      await myDb.initialize();
    }

    return await myDb.listCompartment();
  }

  @override
  Widget build(BuildContext context) {
    return list != null
        ? RefreshIndicator(
            key: refreshKey,
            onRefresh: refreshList,
            child: FutureBuilder(
              builder: (context, compartmentSnap) {
                if (compartmentSnap.connectionState != ConnectionState.done) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return ListView.builder(
                    itemCount: compartmentSnap.data.length,
                    itemBuilder: (BuildContext context, index) {
                      return Container(
                        color: Theme.of(context).backgroundColor,
                        margin: EdgeInsets.fromLTRB(16, 4, 16, 8),
                        child: OpenContainer(
                          openElevation: 8,
                          transitionDuration: Duration(milliseconds: 300),
                          transitionType: ContainerTransitionType.fadeThrough,
                          closedColor: Theme.of(context).cardColor,
                          closedElevation: 2,
                          openColor: Theme.of(context).cardColor,
                          openShape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(8),
                            ),
                          ),
                          closedShape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(8),
                            ),
                          ),
                          closedBuilder: (BuildContext context,
                              VoidCallback openContainer) {
                            return compartmentSnap.data[index].name != null
                                ? compartmentSnap.data[index].name != 'null'
                                    ? CardCompartmentEnabled(
                                        compartment:
                                            compartmentSnap.data[index],
                                      )
                                    : CardCompartmentDisabled(
                                        compartment:
                                            compartmentSnap.data[index],
                                      )
                                : CardCompartmentDisabled(
                                    compartment: compartmentSnap.data[index],
                                  );
                          },
                          openBuilder: (BuildContext context, VoidCallback _) {
                            return
                                // EditCompartmentNew(
                                //   compartment: compartmentSnap.data[index],
                                //   onSaved: () => setState(() {}),
                                // );
                                EditCompartment(
                              compartment: compartmentSnap.data[index],
                              onSaved: () => setState(() {}),
                            );
                          },
                        ),
                      );
                    },
                  );
                }
              },
              future: getListCompartment(),
            ),
          )
        : Center(
            child: CircularProgressIndicator(),
          );
  }
}
