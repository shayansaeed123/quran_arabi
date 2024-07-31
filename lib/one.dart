// import 'package:flutter/material.dart';
// // import 'package:google_sign_in/google_sign_in.dart';
// import 'package:google_sign_in_android/google_sign_in_android.dart';
// import 'package:qurani_arabi_flutter/view/register/class.dart';

// class SignInScreen extends StatelessWidget {
//   final GoogleSignInManager googleSignInManager;

//   SignInScreen({required this.googleSignInManager});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Sign In')),
//       body: Center(
//         child: ElevatedButton(
//           onPressed: () async {
//             final account = await googleSignInManager.signInWithGoogle();
//             if (account != null) {
//               Navigator.pushReplacement(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => SignedInScreen(
//                     googleSignInManager: googleSignInManager,
//                     signedInAccount: account,
//                   ),
//                 ),
//               );
//             }
//           },
//           child: Text('Sign In with Google'),
//         ),
//       ),
//     );
//   }
// }

// class SignedInScreen extends StatelessWidget {
//   final GoogleSignInManager googleSignInManager;
//   final GoogleSignInAccount signedInAccount;

//   SignedInScreen({
//     required this.googleSignInManager,
//     required this.signedInAccount,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Signed In')),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text('Signed in as ${signedInAccount.displayName}'),
//             ElevatedButton(
//               onPressed: () async {
//                 await googleSignInManager.signOut();
//                 Navigator.pushReplacement(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => SignInScreen(
//                       googleSignInManager: googleSignInManager,
//                     ),
//                   ),
//                 );
//               },
//               child: Text('Sign Out'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }