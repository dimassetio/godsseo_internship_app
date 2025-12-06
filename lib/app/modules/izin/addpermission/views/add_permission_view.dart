import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:godsseo/app/modules/izin/addpermission/controllers/add_permission_controller.dart';
import 'package:intl/intl.dart';

class AddPermissionView extends GetView<AddPermissionController> {
  const AddPermissionView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Form Pengajuan Izin', style: TextStyle(color: Colors.black)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      backgroundColor: const Color(0xFFF5F7FA),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // --- 1. AREA HEADER DINAMIS (TEMPAT FOTO) ---
            Obx(() {
              bool hasImage = controller.imagePath.value.isNotEmpty;
              
              return Container(
                width: double.infinity,
                height: 250, // Tinggi area foto
                color: Colors.white,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // BACKGROUND / GAMBAR UTAMA
                    Container(
                      width: double.infinity,
                      height: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        image: hasImage
                            ? DecorationImage(
                                image: FileImage(File(controller.imagePath.value)),
                                fit: BoxFit.contain, // Biar foto full terlihat
                              )
                            : null,
                      ),
                      // Kalau belum ada foto, munculin Ilustrasi atau Ikon Placeholder
                      child: !hasImage
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/images/permission_illustration.png', // Ganti sesuai aset lu
                                  height: 150,
                                  errorBuilder: (context, error, stackTrace) {
                                    // Kalau aset gambar gak ketemu, munculin ikon ini biar gak error
                                    return Icon(Icons.add_a_photo_outlined, size: 80, color: Colors.grey[300]);
                                  },
                                ),
                                const SizedBox(height: 10),
                                Text("Belum ada foto bukti", style: TextStyle(color: Colors.grey[400])),
                              ],
                            )
                          : null,
                    ),

                    // TOMBOL HAPUS FOTO (Muncul cuma kalau ada foto)
                    if (hasImage)
                      Positioned(
                        top: 10,
                        right: 10,
                        child: CircleAvatar(
                          backgroundColor: Colors.black54,
                          child: IconButton(
                            icon: const Icon(Icons.close, color: Colors.white),
                            onPressed: () => controller.imagePath.value = "",
                          ),
                        ),
                      ),
                  ],
                ),
              );
            }),

            const SizedBox(height: 20),

            // --- 2. TOMBOL UPLOAD ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ElevatedButton.icon(
                onPressed: () => _showImagePickerOption(context),
                icon: const Icon(Icons.camera_alt, color: Colors.white),
                label: const Text("Ambil / Upload Foto", style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF408BF9),
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // --- 3. FORM INPUT ---
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildFormRow(
                    label: "Jenis Izin",
                    icon: Icons.assignment_ind,
                    child: Obx(() => DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: controller.selectedType.value,
                            isExpanded: true,
                            items: ["Sakit", "Izin", "Cuti"].map((String value) {
                              return DropdownMenuItem<String>(value: value, child: Text(value));
                            }).toList(),
                            onChanged: (val) => controller.selectedType.value = val!,
                          ),
                        )),
                  ),
                  _buildDivider(),
                  
                  _buildFormRow(
                    label: "Deskripsi Izin",
                    icon: Icons.description,
                    child: TextField(
                      controller: controller.reasonC,
                      decoration: const InputDecoration(
                        hintText: "Contoh: Sakit demam",
                        border: InputBorder.none, isDense: true, contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ),
                  _buildDivider(),

                  _buildFormRow(
                    label: "Tanggal Mulai",
                    icon: Icons.calendar_today,
                    child: _datePickerField(context, dateObs: controller.startDate),
                  ),
                  _buildDivider(),

                  Obx(() => CheckboxListTile(
                    title: const Text("Izin lebih sehari", style: TextStyle(fontSize: 14)),
                    value: controller.startDate.value.day != controller.endDate.value.day,
                    onChanged: (val) {
                      if (val == true) {
                        if (controller.startDate.value.day == controller.endDate.value.day) {
                          controller.endDate.value = controller.startDate.value.add(const Duration(days: 1));
                        }
                      } else {
                        controller.endDate.value = controller.startDate.value;
                      }
                    },
                    controlAffinity: ListTileControlAffinity.leading,
                    contentPadding: EdgeInsets.zero, dense: true,
                  )),
                  _buildDivider(),

                  Obx(() {
                    if (controller.startDate.value.day != controller.endDate.value.day) {
                      return _buildFormRow(
                        label: "Tanggal Selesai",
                        icon: Icons.event_available,
                        child: _datePickerField(context, dateObs: controller.endDate),
                      );
                    }
                    return const SizedBox.shrink();
                  }),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // --- 4. TOMBOL SIMPAN ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: Obx(() => ElevatedButton(
                  onPressed: controller.isLoading.value ? null : () => controller.submitPermission(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF408BF9),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: controller.isLoading.value
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("Simpan", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                )),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // --- WIDGET HELPERS ---

  Widget _buildFormRow({required String label, required IconData icon, required Widget child}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          const SizedBox(height: 4),
          Row(children: [Icon(icon, color: Colors.grey[700], size: 20), const SizedBox(width: 10), Expanded(child: child)]),
        ],
      ),
    );
  }

  Widget _buildDivider() => Container(margin: const EdgeInsets.symmetric(vertical: 8), height: 1, color: Colors.grey[200]);

  Widget _datePickerField(BuildContext context, {required Rx<DateTime> dateObs}) {
    return InkWell(
      onTap: () async {
        DateTime? picked = await showDatePicker(
          context: context, initialDate: dateObs.value, firstDate: DateTime(2020), lastDate: DateTime(2030),
        );
        if (picked != null) dateObs.value = picked;
      },
      child: Obx(() => Text(DateFormat('dd MMMM yyyy').format(dateObs.value), style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14))),
    );
  }

  void _showImagePickerOption(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => Wrap(
        children: [
          ListTile(leading: const Icon(Icons.camera), title: const Text("Kamera"), onTap: () { Navigator.pop(ctx); controller.pickImage(true); }),
          ListTile(leading: const Icon(Icons.image), title: const Text("Galeri"), onTap: () { Navigator.pop(ctx); controller.pickImage(false); }),
        ],
      ),
    );
  }
}