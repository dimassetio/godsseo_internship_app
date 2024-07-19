import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:godsseo/app/data/helpers/database.dart';
import 'package:nb_utils/nb_utils.dart';

class Gaji {
  static const String POKOK = "POKOK";
  static const String TUNJANGAN_MAKAN = "TUNJANGAN_MAKAN";
  static const String TUNJANGAN_TRANSPORT = "TUNJANGAN_TRANSPORT";
  static const String TUNJANGAN_KESEHATAN = "TUNJANGAN_KESEHATAN";
  static const String BONUS_PROFESSIONAL = "BONUS_PROFESSIONAL";
  static const String POTONGAN_TERLAMBAT = "POTONGAN_TERLAMBAT";
  static const String POTONGAN_SAKIT = "POTONGAN_SAKIT";
  static const String POTONGAN_IZIN = "POTONGAN_IZIN";
  static const String POTONGAN_ABSEN = "POTONGAN_ABSEN";

  int pokok;
  int tunjMakan;
  int tunjTransport;
  int tunjKesehatan;
  int bonusPro;
  int potTerlambat;
  int potSakit;
  int potIzin;
  int potAbsen;

  Gaji({
    required this.pokok,
    required this.tunjMakan,
    required this.tunjTransport,
    required this.tunjKesehatan,
    required this.bonusPro,
    required this.potTerlambat,
    required this.potSakit,
    required this.potIzin,
    required this.potAbsen,
  });

  Map<String, dynamic> toJson() {
    return {
      POKOK: pokok,
      TUNJANGAN_MAKAN: tunjMakan,
      TUNJANGAN_TRANSPORT: tunjTransport,
      TUNJANGAN_KESEHATAN: tunjKesehatan,
      BONUS_PROFESSIONAL: bonusPro,
      POTONGAN_TERLAMBAT: potTerlambat,
      POTONGAN_SAKIT: potSakit,
      POTONGAN_IZIN: potIzin,
      POTONGAN_ABSEN: potAbsen,
    };
  }

  factory Gaji.fromSnapshot(DocumentSnapshot doc) {
    Map<String, dynamic> json = doc.data() as Map<String, dynamic>;
    return Gaji(
        pokok: json[POKOK],
        tunjMakan: json[TUNJANGAN_MAKAN],
        tunjTransport: json[TUNJANGAN_TRANSPORT],
        tunjKesehatan: json[TUNJANGAN_KESEHATAN],
        bonusPro: json[BONUS_PROFESSIONAL],
        potTerlambat: json[POTONGAN_TERLAMBAT],
        potSakit: json[POTONGAN_SAKIT],
        potIzin: json[POTONGAN_IZIN],
        potAbsen: json[POTONGAN_ABSEN]);
  }
}

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
