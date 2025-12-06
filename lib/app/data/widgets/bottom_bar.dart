import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:godsseo/app/data/helpers/themes.dart';
import 'package:godsseo/app/routes/app_pages.dart';
class GSBottomBar extends StatelessWidget {
  const GSBottomBar({
    super.key,
    this.currentIndex = 0, 
  });

  final int currentIndex;

  @override
  Widget build(BuildContext context) {
 
    final Color mainBlue = Color(0xFF0052CC); 

    return Container(

      decoration: BoxDecoration(
        color: Colors.transparent,
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: Offset(0, -5))
        ],
      ),

      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        child: BottomAppBar(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          height: 65, 
          color: mainBlue, 
          notchMargin: 8, 
          shape: const CircularNotchedRectangle(), 
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
        
              _buildNavItem(0, Icons.grid_view_rounded, "Dashboard", () => Get.offAllNamed(Routes.HOME)),
              _buildNavItem(1, Icons.description_outlined, "Izin", () => Get.toNamed(Routes.PERMISSION)),
              
              const SizedBox(width: 48), 
              
      
              _buildNavItem(2, Icons.calendar_month_outlined, "Piket", () => Get.toNamed(Routes.PIKET)),
              _buildNavItem(3, Icons.person_outline_rounded, "Profile", () => Get.toNamed(Routes.PROFILE)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label, VoidCallback onTap) {
    // Logic Warna: Putih terang kalau aktif, Putih pudar kalau enggak
    bool isActive = currentIndex == index;
    Color itemColor = isActive ? Colors.white : Colors.white.withOpacity(0.6);

    return InkWell(
      onTap: isActive ? null : onTap,
      customBorder: const CircleBorder(),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: itemColor, size: 28),
            const SizedBox(height: 4),
            Text(
              label, 
              style: TextStyle(
                color: itemColor, 
                fontSize: 11, 
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal
              )
            ),
          ],
        ),
      ),
    );
  }
}


class GSBottomNavBar extends StatelessWidget {
  const GSBottomNavBar({Key? key, required this.currentIndex}) : super(key: key);
  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      onTap: (index) {
        if (index == currentIndex) return;
        switch (index) {
          case 0: Get.toNamed(Routes.HOME_ADMIN); break;
          case 1: Get.toNamed(Routes.PRESENSI_ADMIN); break;
          case 2: Get.toNamed(Routes.USERS); break;
          case 3: Get.toNamed(Routes.PROFILE); break;
        }
      },
      currentIndex: currentIndex,
      showUnselectedLabels: false,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: primaryColor(context),
      unselectedItemColor: Colors.grey,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: "Dashboard"),
        BottomNavigationBarItem(icon: Icon(Icons.fingerprint), label: "Presence"),
        BottomNavigationBarItem(icon: Icon(Icons.group), label: "Users"),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
      ],
    );
  }
}