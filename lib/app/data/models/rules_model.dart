import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:godsseo/app/data/helpers/database.dart';
import 'package:nb_utils/nb_utils.dart';

class RulesModel extends Database {
  static const String COLLECTION_NAME = "rules";

  static const String ID = "ID";
  static const String DATE_IN = "dateIn";
  static const String PIKET_DATE_IN = "piketDateIn"; 
  static const String DATE_OUT = "dateOut";
  static const String COORDINATE = "coordinate";
  static const String DISTANCE_TOLERANCE = "distanceTolerance";
  static const String WEEKLY_OFF = "weeklyOff";

  String? id;
  DateTime dateIn;
  DateTime? piketDateIn;
  DateTime dateOut;
  GeoPoint coordinate;
  int distanceTolerance;
  List<int> weeklyOff;

  RulesModel({
    this.id,
    required this.dateIn,
    this.piketDateIn,
    required this.dateOut,
    required this.coordinate,
    required this.distanceTolerance,
    required this.weeklyOff,
  }) : super(
          collectionReference: firestore.collection(COLLECTION_NAME),
          storageReference: storage.ref(COLLECTION_NAME),
        );

  factory RulesModel.fromSnapshot(DocumentSnapshot doc) {
    var data = doc.data() as Map<String, dynamic>;
    return RulesModel(
      id: doc.id,
      dateIn: (data[DATE_IN] as Timestamp).toDate(),
      piketDateIn: data[PIKET_DATE_IN] != null 
          ? (data[PIKET_DATE_IN] as Timestamp).toDate() 
          : null,
      dateOut: (data[DATE_OUT] as Timestamp).toDate(),
      coordinate: data[COORDINATE],
      distanceTolerance: data[DISTANCE_TOLERANCE],
      weeklyOff: List<int>.from(data[WEEKLY_OFF] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      ID: id,
      DATE_IN: dateIn,
      PIKET_DATE_IN: piketDateIn,
      DATE_OUT: dateOut,
      COORDINATE: coordinate,
      DISTANCE_TOLERANCE: distanceTolerance,
      WEEKLY_OFF: weeklyOff,
    };
  }

  Future<RulesModel> save({File? file, bool? isSet}) async {
    id.isEmptyOrNull
        ? id = await super.add(toJson())
        : (isSet ?? false)
            ? await super.collectionReference.doc(id).set(toJson())
            : await super.edit(toJson());
            
    if (file != null && !id.isEmptyOrNull) {
      await super.edit(toJson());
    }
    return this;
  }

  Future<RulesModel?> getById() async {
    return id.isEmptyOrNull
        ? null
        : RulesModel.fromSnapshot(await super.getID(id!));
  }

  Stream<RulesModel> stream() {
    return super
        .collectionReference
        .doc(id)
        .snapshots()
        .map((event) => RulesModel.fromSnapshot(event));
  }
}

final defaultRules = RulesModel(
  id: 'default', 
  dateIn: DateTime(2023, 1, 1, 8, 0),
  piketDateIn: DateTime(2023, 1, 1, 7, 30),
  dateOut: DateTime(2023, 1, 1, 17, 0),
  coordinate: const GeoPoint(-6.200000, 106.816666),
  distanceTolerance: 100,
  weeklyOff: [7], 
);