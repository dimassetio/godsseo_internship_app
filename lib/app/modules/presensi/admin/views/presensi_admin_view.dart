import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/presensi_admin_controller.dart';

class PresensiAdminView extends GetView<PresensiAdminController> {
  const PresensiAdminView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PresensiAdminView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'PresensiAdminView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
