import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import 'package:get/get.dart';
import 'package:godsseo/app/data/helpers/themes.dart';
import 'package:godsseo/app/data/models/user_model.dart';
import 'package:godsseo/app/routes/app_pages.dart';
import 'package:nb_utils/nb_utils.dart';

import '../controllers/users_controller.dart';

class UsersView extends GetView<UsersController> {
  const UsersView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Pegawai'),
          centerTitle: true,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Get.toNamed(Routes.USERS_FORM);
          },
          backgroundColor: primaryColor(context),
          child: Icon(Icons.add),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                StreamBuilder<List<UserModel>>(
                  stream: controller.streamUsers(),
                  builder: (context, snapshot) {
                    if (snapshot.data is List<UserModel>) {
                      List<UserModel> users = snapshot.data!;
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: ScrollPhysics(),
                        itemCount: users.length,
                        itemBuilder: (context, index) {
                          return Container(
                            child: UsersCard(
                              user: users[index],
                            ),
                            margin: EdgeInsets.only(bottom: 16),
                          );
                        },
                      );
                    } else {
                      return Center(child: CircularProgressIndicator());
                    }
                  },
                ),
              ],
            ),
          ),
        ));
  }
}

class UsersCard extends StatelessWidget {
  UsersCard({
    super.key,
    required this.user,
  });
  final UserModel user;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: EdgeInsets.zero,
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        leading: CircleAvatar(
          child: Icon(Icons.person),
          foregroundImage: user.foto.isEmptyOrNull
              ? null
              : CachedNetworkImageProvider(user.foto!),
        ),
        onTap: () {
          // toast("Go to detail users");
          Get.toNamed(Routes.USERS_DETAIL, arguments: user);
        },
        title: Text(user.nickname ?? "--"),
        subtitle: Row(
          children: [
            Expanded(
              child: Text(
                user.email ?? "--",
                overflow: TextOverflow.ellipsis,
              ),
            ),
            4.width,
            Icon(
              Icons.verified_rounded,
              size: 16,
              color: (user.isActive ?? false)
                  ? primaryColor(context)
                  : theme(context).disabledColor,
            )
          ],
        ),
        trailing: Container(
          decoration: BoxDecoration(
              color: (user.isActive ?? false)
                  ? primaryColor(context)
                  : theme(context).disabledColor,
              borderRadius: BorderRadius.circular(16)),
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Text(
            user.role ?? "--",
            style: textTheme(context)
                .labelMedium
                ?.copyWith(color: colorScheme(context).onPrimary),
          ),
        ),
      ),
    );
  }
}
