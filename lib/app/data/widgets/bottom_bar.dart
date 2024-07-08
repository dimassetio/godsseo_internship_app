import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:godsseo/app/data/helpers/themes.dart';
import 'package:godsseo/app/routes/app_pages.dart';

class GSBottomNavBar extends StatelessWidget {
  GSBottomNavBar({required this.currentIndex});
  final int currentIndex;
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
        onTap: (index) {
          switch (index) {
            case 0:
              Get.toNamed(Routes.HOME_ADMIN);
              break;
            case 1:
              Get.toNamed(Routes.PRESENSI_ADMIN);
              break;
            case 2:
              Get.toNamed(Routes.USERS);
              break;
            case 3:
              Get.toNamed(Routes.PROFILE);
              break;
            default:
              Get.snackbar("Error", "Unknown index");
          }
        },
        currentIndex: currentIndex,
        showUnselectedLabels: false,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.dashboard), label: "Dashboard"),
          BottomNavigationBarItem(
              icon: Icon(Icons.fingerprint), label: "Presence"),
          BottomNavigationBarItem(icon: Icon(Icons.group), label: "Users"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ]);
  }
}

class GSBottomBar extends StatelessWidget {
  const GSBottomBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      height: 60,
      color: primaryColor(context),
      notchMargin: 6,
      shape: CircularNotchedRectangle(),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          IconButton(
            icon: Icon(
              Icons.dashboard_rounded,
            ),
            color: theme(context).scaffoldBackgroundColor,
            onPressed: () {
              Get.offNamed(Routes.HOME);
            },
          ),
          SizedBox(),
          IconButton(
            color: theme(context).scaffoldBackgroundColor,
            icon: Icon(
              Icons.person_rounded,
            ),
            onPressed: () {
              Get.toNamed(
                Routes.PROFILE,
              );
            },
          ),
        ],
      ),
    );
  }
}
