import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:godsseo/app/data/helpers/database.dart';
import 'package:godsseo/app/data/helpers/formatter.dart';
import 'package:godsseo/app/data/models/user_model.dart';
import 'package:nb_utils/nb_utils.dart';

RulesModel defaultRules = RulesModel(
  id: 'defaultRules',
  coordinate: GeoPoint(-8.021201935999994, 112.6264289394021),
  distanceTolerance: 20,
  dateIn: TimeOfDay(hour: 8, minute: 0),
  dateOut: TimeOfDay(hour: 16, minute: 30),
);

class RulesModel extends Database {
  static const String COLLECTION_NAME = "rules";

  static const String ID = "ID";
  static const String COORDINATE = "COORDINATE";
  static const String DISTANCE_TOLERANCE = "DISTANCE_TOLERANCE";
  static const String DATE_IN = "DATE_IN";
  static const String DATE_OUT = "DATE_OUT";

  String id;
  TimeOfDay dateIn;
  TimeOfDay dateOut;
  GeoPoint coordinate;
  int distanceTolerance;

  UserModel? userModel;

  RulesModel({
    required this.id,
    required this.dateIn,
    required this.dateOut,
    required this.coordinate,
    required this.distanceTolerance,
  }) : super(
          collectionReference: firestore.collection(COLLECTION_NAME),
          storageReference: storage.ref(COLLECTION_NAME),
        );

  factory RulesModel.fromSnapshot(DocumentSnapshot doc) {
    var json = doc.data() as Map<String, dynamic>?;

    return RulesModel(
      id: doc.id,
      dateIn: dateToTime((json?[DATE_IN] as Timestamp).toDate())!,
      dateOut: dateToTime((json?[DATE_OUT] as Timestamp).toDate())!,
      coordinate: json?[COORDINATE],
      distanceTolerance: json?[DISTANCE_TOLERANCE],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      ID: id,
      DATE_IN: timeToDate(dateIn),
      DATE_OUT: timeToDate(dateOut),
      COORDINATE: coordinate,
      DISTANCE_TOLERANCE: distanceTolerance,
    };
  }

  Future<RulesModel> save({File? file, bool? isSet}) async {
    id.isEmptyOrNull
        ? id = await super.add(toJson()) ?? id
        : (isSet ?? false)
            ? super.collectionReference.doc(id).set(toJson())
            : await super.edit(toJson());
    if (file != null && !id.isEmptyOrNull) {
      // foto = await super.upload(id: id!, file: file);
      await super.edit(toJson());
    }
    return this;
  }

  Future<RulesModel?> getById() async {
    return id.isEmptyOrNull
        ? null
        : RulesModel.fromSnapshot(await super.getID(id));
  }

  Stream<RulesModel> stream() {
    return super
        .collectionReference
        .doc(id)
        .snapshots()
        .map((event) => RulesModel.fromSnapshot(event));
  }
}
