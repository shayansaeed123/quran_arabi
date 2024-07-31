// // import 'package:google_sign_in/google_sign_in.dart';

// class GoogleSignInManager {
//   final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);

//   Future<GoogleSignInAccount?> signInWithGoogle() async {
//     try {
//       final account = await _googleSignIn.signIn();
//       return account;
//     } catch (error) {
//       return null;
//     }
//   }

//   Future<void> signOut() async {
//     await _googleSignIn.signOut();
//   }
// }