import 'package:get/get.dart';
import 'package:godsseo/app/data/models/user_model.dart';

class UsersController extends GetxController {
  //TODO: Implement UsersController

  List<UserModel> users = RxList();

  Stream<List<UserModel>> streamUsers() {
    return UserModel()
        .snapshots(sortBy: UserModel.TGL_MASUK, descending: true)
        .map((event) =>
            event.docs.map((e) => UserModel.fromSnapshot(e)).toList());
  }

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
