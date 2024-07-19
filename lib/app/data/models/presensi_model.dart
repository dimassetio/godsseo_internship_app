import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:godsseo/app/data/helpers/database.dart';
import 'package:godsseo/app/data/models/user_model.dart';
import 'package:nb_utils/nb_utils.dart';

class PresensiModel extends Database {
  static const String COLLECTION_NAME = "presensi";

  static const String ID = "ID";
  static const String USER_ID = "USER_ID";
  static const String DATE_IN = "DATE_IN";
  static const String DATE_OUT = "DATE_OUT";
  static const String STATUS_IN = "STATUS_IN";
  static const String STATUS_OUT = "STATUS_OUT";
  static const String COORDINATE_IN = "COORDINATE_IN";
  static const String COORDINATE_OUT = "COORDINATE_OUT";
  static const String DISTANCE_IN = "DISTANCE_IN";
  static const String DISTANCE_OUT = "DISTANCE_OUT";

  String? id;
  String userId;
  DateTime? dateIn;
  DateTime? dateOut;
  String? statusIn;
  String? statusOut;
  GeoPoint? coordinateIn;
  GeoPoint? coordinateOut;
  int? distanceIn;
  int? distanceOut;

  UserModel? userModel;

  PresensiModel({
    this.id,
    required this.userId,
    this.dateIn,
    this.dateOut,
    this.statusIn,
    this.statusOut,
    this.coordinateIn,
    this.coordinateOut,
    this.distanceIn,
    this.distanceOut,
  }) : super(
          collectionReference: firestore
              .collection(UserModel.COLLECTION_NAME)
              .doc(userId)
              .collection(COLLECTION_NAME),
          storageReference: storage
              .ref(UserModel.COLLECTION_NAME)
              .child(userId)
              .child(COLLECTION_NAME),
        );

  static Query get collectionGroup => Database.collectionGroup(COLLECTION_NAME);

  factory PresensiModel.fromSnapshot(DocumentSnapshot doc) {
    var json = doc.data() as Map<String, dynamic>?;

    return PresensiModel(
      id: doc.id,
      userId: json?[USER_ID],
      dateIn: (json?[DATE_IN] as Timestamp?)?.toDate(),
      dateOut: (json?[DATE_OUT] as Timestamp?)?.toDate(),
      statusIn: json?[STATUS_IN],
      statusOut: json?[STATUS_OUT],
      coordinateIn: json?[COORDINATE_IN],
      coordinateOut: json?[COORDINATE_OUT],
      distanceIn: json?[DISTANCE_IN],
      distanceOut: json?[DISTANCE_OUT],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      ID: id,
      USER_ID: userId,
      DATE_IN: dateIn,
      DATE_OUT: dateOut,
      STATUS_IN: statusIn,
      STATUS_OUT: statusOut,
      COORDINATE_IN: coordinateIn,
      COORDINATE_OUT: coordinateOut,
      DISTANCE_IN: distanceIn,
      DISTANCE_OUT: distanceOut,
    };
  }

  Future<PresensiModel> save({File? file, bool? isSet}) async {
    id.isEmptyOrNull
        ? id = await super.add(toJson())
        : (isSet ?? false)
            ? super.collectionReference.doc(id).set(toJson())
            : await super.edit(toJson());
    if (file != null && !id.isEmptyOrNull) {
      await super.edit(toJson());
    }
    return this;
  }

  Future<PresensiModel?> getById() async {
    return id.isEmptyOrNull
        ? null
        : PresensiModel.fromSnapshot(await super.getID(id!));
  }

  Future<UserModel?> getUser() async {
    userModel = await UserModel(id: userId).getUser();
    return userModel;
  }

  Stream<PresensiModel> stream() {
    return super
        .collectionReference
        .doc(id)
        .snapshots()
        .map((event) => PresensiModel.fromSnapshot(event));
  }

  void addPresenceData({
    required DateTime dateTime,
    required String status,
    required GeoPoint coordinate,
    required int distance,
  }) {
    if (dateIn == null) {
      dateIn = dateTime;
      statusIn = status;
      coordinateIn = coordinate;
      distanceIn = distance;
    } else {
      dateOut = dateTime;
      statusOut = status;
      coordinateOut = coordinate;
      distanceOut = distance;
    }
  }
}

abstract class StatusPresensi {
  static const inTime = 'Tepat Waktu';
  static const earlier = 'Lebih Awal';
  static const late = 'Terlambat';

  static const list = [inTime, earlier, late];
}
