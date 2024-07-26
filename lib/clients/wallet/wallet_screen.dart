// import 'package:flutter/material.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:pragyan_cdc/api/auth_api.dart';
// import 'package:pragyan_cdc/constants/appbar.dart';
// import 'package:pragyan_cdc/constants/styles/styles.dart';
//
// import '../../model/user_details_model.dart';
// import '../../shared/loading.dart';
//
// class WalletScreen extends StatefulWidget {
//   const WalletScreen({super.key});
//
//   @override
//   State<WalletScreen> createState() => _WalletScreenState();
// }
//
// class _WalletScreenState extends State<WalletScreen> {
//
//   Future<UserProfile?> fetchUserProfile() async {
//     // Use FlutterSecureStorage to get userId and token
//     final userId = await const FlutterSecureStorage().read(key: 'userId');
//     final token = await const FlutterSecureStorage().read(key: 'authToken');
//     debugPrint('got userId and token');
//     debugPrint(userId);
//     debugPrint(token);
//
//     if (userId != null && token != null) {
//       // Use UserApi to fetch the user profile
//       return ApiServices().fetchUserProfile(userId, token);
//     } else {
//       return null;
//     }
//   }
//   @override
//   Widget build(BuildContext context) {
//
//     return FutureBuilder<UserProfile?>(future: fetchUserProfile(), builder: (context, snapshot) {
//       if (snapshot.connectionState == ConnectionState.waiting) {
//         return Center(child: Loading());
//       } else if (snapshot.hasError) {
//         return const Center(child: Text('Error fetching user profile'));
//       } else if (!snapshot.hasData || snapshot.data == null) {
//         return const Center(child: Text('User profile not found'));
//       } else {
//         final userProfile = snapshot.data!;
//         return Scaffold(
//           appBar: customAppBar(title: 'Wallet',showLeading: false),
//           body: Padding(
//             padding: const EdgeInsets.all(8),
//             child: Column(
//               children: [
//                 Stack(
//                   children: [
//                     Image.asset(
//                         'assets/images/woman-doing-speech-therapy-with-little-boy-her-clinic (1) 1.png'),
//                     const Positioned(
//                       bottom: 20,
//                       right: 20,
//                       child: SizedBox(
//                         width: 250,
//                         child: Text(
//                           'Children learn more from what you are  than what you teach',
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontSize: 14,
//                             fontWeight: FontWeight.bold,
//                           ),
//                           textAlign: TextAlign.center,
//                           maxLines: 2,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 kheight60,
//                 kheight30,
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Image.asset('assets/images/wallet_855279 1.png'),
//                     const SizedBox(
//                       width: 7,
//                     ),
//                     const Text(
//                       'Wallet',
//                       style: kTextStyle1,
//                     ),
//                   ],
//                 ),
//                 kheight10,
//                  Text('Your Wallet Balance : ${userProfile.parentWallet.toString()}')
//               ],
//             ),
//           ),
//         );
//       }});
//   }
// }
//
//
//
