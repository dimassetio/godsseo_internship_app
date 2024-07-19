import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:godsseo/app/data/helpers/database.dart';
import 'package:nb_utils/nb_utils.dart';

class DayOffModel extends Database {
  static const String COLLECTION_NAME = "dayOff";

  static const String ID = "ID";
  static const String DATE = "DATE";
  static const String DESCRIPTION = "DESCRIPTION";
  static const String CREATED_AT = "CREATED_AT";

  String? id;
  DateTime date;
  String? description;
  DateTime? lastModified;

  DayOffModel({
    this.id,
    required this.date,
    this.description,
    this.lastModified,
  }) : super(
          collectionReference: firestore.collection(COLLECTION_NAME),
          storageReference: storage.ref(COLLECTION_NAME),
        );

  static CollectionReference<Map<String, dynamic>> get collection =>
      firestore.collection(COLLECTION_NAME);

  factory DayOffModel.fromSnapshot(DocumentSnapshot doc) {
    var json = doc.data() as Map<String, dynamic>?;

    return DayOffModel(
      id: doc.id,
      date: (json?[DATE] as Timestamp).toDate(),
      lastModified: (json?[CREATED_AT] as Timestamp?)?.toDate(),
      description: json?[DESCRIPTION],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      ID: id,
      DATE: date,
      DESCRIPTION: description,
      CREATED_AT: lastModified,
    };
  }

  Future<DayOffModel> save({File? file, bool? isSet}) async {
    id.isEmptyOrNull
        ? (id = await super.add(toJson()))
        : (isSet ?? false)
            ? super.collectionReference.doc(id).set(toJson())
            : await super.edit(toJson());
    if (file != null && !id.isEmptyOrNull) {
      await super.edit(toJson());
    }
    return this;
  }

  Future<DayOffModel?> getById() async {
    return id.isEmptyOrNull
        ? null
        : DayOffModel.fromSnapshot(await super.getID(id!));
  }

  Stream<DayOffModel> stream() {
    return super
        .collectionReference
        .doc(id)
        .snapshots()
        .map((event) => DayOffModel.fromSnapshot(event));
  }
}
