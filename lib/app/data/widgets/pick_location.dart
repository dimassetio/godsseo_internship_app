// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:godsseo/app/data/widgets/button.dart';
// import 'package:nb_utils/nb_utils.dart';

// class PickLocationWidget extends StatelessWidget {
//   PickLocationWidget({
//     super.key,
//   });

//   final Rxn<Marker> _marker = Rxn();

//   void _onTap(LatLng value) {
//     _marker.value = Marker(
//       markerId: MarkerId('pickedLocation'),
//       position: value,
//       draggable: true,
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Dialog(
//       insetPadding: EdgeInsets.all(20),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//       child: Container(
//         padding: EdgeInsets.all(16),
//         child: Obx(
//           () => Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               SizedBox(
//                 height: Get.height / 2,
//                 child: GoogleMap(
//                   initialCameraPosition:
//                       CameraPosition(target: coordinatUM, zoom: 17),
//                   onTap: _onTap,
//                   markers: _marker.value == null ? {} : {_marker.value!},
//                 ),
//               ),
//               16.height,
//               Text(
//                 '${'pickedLocatioin'.tr}: ${_marker.value == null ? '' : ' ${_marker.value!.position.latitude}, ${_marker.value!.position.longitude}'}',
//               ),
//               GSButton(
//                   title: _marker.value == null ? 'cancel'.tr : 'set'.tr,
//                   onPressed: () {
//                     Get.back(result: _marker.value?.position);
//                   })
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
