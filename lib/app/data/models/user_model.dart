import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:godsseo/app/data/helpers/database.dart';
import 'package:nb_utils/nb_utils.dart';

class UserModel extends Database {
  static const String COLLECTION_NAME = "users";

  static const String ID = "ID";
  static const String UID = "UID";
  static const String ROLE = "ROLE";
  static const String NICKNAME = "NICKNAME";
  static const String NAMA = "NAMA";
  static const String EMAIL = "EMAIL";
  static const String GENDER = "GENDER";
  static const String ALAMAT = "ALAMAT";
  static const String SEKOLAH = "SEKOLAH";
  static const String TGL_MASUK = "TGL_MASUK";
  static const String FOTO = "FOTO";
  static const String IS_ACTIVE = "IS_ACTIVE";

  String? id;
  String? uid;
  String? role;
  String? email;
  String? nickname;
  String? nama;
  String? gender;
  String? sekolah;
  DateTime? tglMasuk;
  String? alamat;
  String? foto;
  bool? isActive;

  int countInternDays() {
    return (tglMasuk is DateTime)
        ? DateTime.now().difference(tglMasuk!).inDays + 1
        : 0;
  }

  UserModel({
    this.id,
    this.uid,
    this.role,
    this.email,
    this.nickname,
    this.nama,
    this.sekolah,
    this.tglMasuk,
    this.gender,
    this.alamat,
    this.foto,
    this.isActive,
  }) : super(
          collectionReference: firestore.collection(COLLECTION_NAME),
          storageReference: storage.ref(COLLECTION_NAME),
        );

  static CollectionReference get getCollectionReference =>
      firestore.collection(COLLECTION_NAME);

  // UserModel.fromSnapshot(String? id, Map<String, dynamic> json)
  UserModel.fromSnapshot(DocumentSnapshot doc)
      : id = doc.id,
        super(
            collectionReference: firestore.collection(COLLECTION_NAME),
            storageReference: storage.ref(COLLECTION_NAME)) {
    var json = doc.data() as Map<String, dynamic>?;
    role = json?[ROLE];
    email = json?[EMAIL];
    nickname = json?[NICKNAME];
    nama = json?[NAMA];
    sekolah = json?[SEKOLAH];
    tglMasuk = (json?[TGL_MASUK] as Timestamp?)?.toDate();
    gender = json?[GENDER];
    alamat = json?[ALAMAT];
    foto = json?[FOTO];
    isActive = json?[IS_ACTIVE];
  }

  Map<String, dynamic> toJson() {
    return {
      ID: id,
      UID: uid,
      ROLE: role,
      EMAIL: email,
      NICKNAME: nickname,
      NAMA: nama,
      GENDER: gender,
      ALAMAT: alamat,
      SEKOLAH: sekolah,
      TGL_MASUK: tglMasuk,
      FOTO: foto,
      IS_ACTIVE: isActive,
    };
  }

  Future<UserModel?> getByUid() async {
    return uid.isEmptyOrNull
        ? null
        : await super
            .collectionReference
            .doc(uid)
            .get()
            .then((value) => UserModel.fromSnapshot(value));
  }

  bool hasRole(String value) => role == value;

  bool hasRoles(List<String> value) => value.contains(role);

  Future<UserModel> save({File? file, bool? isSet}) async {
    id.isEmptyOrNull
        ? id = await super.add(toJson())
        : (isSet ?? false)
            ? super.collectionReference.doc(id).set(toJson())
            : await super.edit(toJson());
    if (file != null && !id.isEmptyOrNull) {
      foto = await super.upload(id: id!, file: file);
      await super.edit(toJson());
    }
    return this;
  }

  Future<UserModel?> getUser() async {
    return id.isEmptyOrNull
        ? null
        : UserModel.fromSnapshot(await super.getID(id!));
  }

  Stream<UserModel> stream() {
    return super
        .collectionReference
        .doc(id)
        .snapshots()
        .map((event) => UserModel.fromSnapshot(event));
  }

  Stream<UserModel> streamByUid(pUid) {
    return super
        .collectionReference
        .doc(pUid)
        .snapshots()
        .map((event) => UserModel.fromSnapshot(event));
  }
}

abstract class Role {
  static const magang = 'Magang';
  static const administrator = 'Administrator';
  static const mentor = 'Mentor';
  static const hrd = 'HRD';
  static const employee = 'Employee';

  static const list = [magang, administrator, mentor, hrd, employee];
}
