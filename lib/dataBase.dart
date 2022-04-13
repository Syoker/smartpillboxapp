import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class Compartment {
  int id;
  String name;
  int repetitions;
  TimeOfDay hour;
  DateTime startDate;
  int repetitionsNum;
  DateTime endDate;
  int repetitionsEnd;

  Compartment({
    this.id,
    @required this.name,
    @required this.repetitions,
    @required this.hour,
    @required this.startDate,
    @required this.repetitionsNum,
    @required this.endDate,
    @required this.repetitionsEnd,
  });

  static Compartment fromMap(Map<String, dynamic> map) {
    return Compartment(
      id: map['id'],
      name: map['name'] != null ? map['name'] : null,
      repetitions: map['repetitions'] != null ? map['repetitions'] : null,
      hour: map['hour'] != null
          ? TimeOfDay.fromDateTime(DateTime.tryParse(map['hour']))
          : null,
      startDate: map['start_date'] != null
          ? DateTime.tryParse(map['start_date'] ?? '')
          : null,
      repetitionsNum:
          map['repetitions_num'] != null ? map['repetitions_num'] : null,
      endDate: DateTime.tryParse(map['end_date'] ?? ''),
      repetitionsEnd:
          map['repetitions_end'] != null ? map['repetitions_end'] : null,
    );
  }
}

class MyDatabase {
  Database _database;
  bool _initialized = false;
  static MyDatabase _instance;

  MyDatabase._();

  static MyDatabase get instance {
    if (_instance == null) {
      _instance = new MyDatabase._();
    }

    return _instance;
  }

  bool get initialized {
    return this._initialized;
  }

  Future<Null> initialize() async {
    this._database = await openDatabase(
      'spa.db',
      version: 1,
      onCreate: (Database db, int version) async {
        var batch = db.batch();

        batch.execute('''
          CREATE TABLE IF NOT EXISTS Compartment (
            id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
            name TEXT,
            repetitions INTEGER,
            hour TEXT,
            start_date TEXT,
            end_date TEXT,
            repetitions_num INTEGER,
            repetitions_end INTEGER
          );
        ''');

        batch.execute('''
          CREATE TABLE IF NOT EXISTS Days (
            id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
            name TEXT
          );
        ''');

        batch.execute('''
          CREATE TABLE IF NOT EXISTS Compartment_days (
            compartment_id INTEGER NOT NULL,
            days_id INTEGER NOT NULL
          );
        ''');

        batch.rawInsert('''INSERT INTO Compartment (
              hour, repetitions, start_date, end_date, name, repetitions_num, repetitions_end) 
              VALUES (NULL, NULL, NULL, NULL, NULL, NULL, NULL
              );
              ''');

        batch.rawInsert('''INSERT INTO Compartment (
              hour, repetitions, start_date, end_date, name, repetitions_num, repetitions_end) 
              VALUES (NULL, NULL, NULL, NULL, NULL, NULL, NULL
              );
              ''');

        batch.rawInsert('''INSERT INTO Compartment (
              hour, repetitions, start_date, end_date, name, repetitions_num, repetitions_end) 
              VALUES (NULL, NULL, NULL, NULL, NULL, NULL, NULL
              );
              ''');

        batch.rawInsert('''INSERT INTO Compartment (
              hour, repetitions, start_date, end_date, name, repetitions_num, repetitions_end) 
              VALUES (NULL, NULL, NULL, NULL, NULL, NULL, NULL
              );
              ''');

        batch.rawInsert('''INSERT INTO Compartment (
              hour, repetitions, start_date, end_date, name, repetitions_num, repetitions_end) 
              VALUES (NULL, NULL, NULL, NULL, NULL, NULL, NULL
              );
              ''');

        batch.rawInsert('''INSERT INTO Compartment (
              hour, repetitions, start_date, end_date, name, repetitions_num, repetitions_end) 
              VALUES (NULL, NULL, NULL, NULL, NULL, NULL, NULL
              );
              ''');

        await batch.commit(noResult: true);
      },
    );

    this._initialized = true;
  }

  FutureOr<Compartment> updateCompartment(Compartment compartmentValue) async {
    var values = [
      compartmentValue.name.toString(),
      compartmentValue.repetitions != null
          ? compartmentValue.repetitions.toString()
          : null,
      compartmentValue.hour != null
          ? DateTime(1970, 1, 1, compartmentValue.hour.hour,
                  compartmentValue.hour.minute)
              .toIso8601String()
          : null,
      compartmentValue.startDate != null
          ? compartmentValue.startDate.toIso8601String()
          : null,
      compartmentValue.repetitionsNum != null
          ? compartmentValue.repetitionsNum.toString()
          : null,
      compartmentValue.endDate != null
          ? compartmentValue.endDate.toIso8601String()
          : null,
      compartmentValue.repetitionsEnd != null
          ? compartmentValue.repetitionsEnd.toString()
          : null,
      compartmentValue.id.toString()
    ];

    var compartmentId = await this._database.rawUpdate('''
      UPDATE Compartment SET name = ?, 
      repetitions = ?, 
      hour = ?, 
      start_date = ?, 
      repetitions_num = ?, 
      end_date = ?, 
      repetitions_end = ? 
      WHERE id = ?
    ''', values);

    return Compartment.fromMap(
      (await this._database.query('Compartment')).firstWhere(
        (Map<String, dynamic> compartment) {
          return compartment['id'] == compartmentId;
        },
      ),
    );
  }

  FutureOr<List<Compartment>> listCompartment() async {
    var data = await this._database.query('Compartment');
    var compartmentList = <Compartment>[];

    data.forEach((element) {
      compartmentList.add(Compartment.fromMap(element));
    });

    return compartmentList;
  }
}
