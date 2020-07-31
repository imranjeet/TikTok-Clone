// import 'dart:convert';

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:http/http.dart' as http;

// class AuthProvider {
//   final FirebaseAuth _auth = FirebaseAuth.instance;

//   Future<bool> signInWithEmail(String email, String password) async {
//     try {
//       AuthResult result = await _auth.signInWithEmailAndPassword(
//           email: email, password: password);
//       FirebaseUser user = result.user;
//       if (user != null)
//         return true;
//       else
//         return false;
//     } catch (e) {
//       print(e.message);
//       return false;
//     }
//   }

//   Future<void> logOut() async {
//     try {
//       await _auth.signOut();
//     } catch (e) {
//       print("error logging out");
//     }
//   }

//   Future<bool> loginWithGoogle() async {
//     GoogleSignIn googleSignIn = GoogleSignIn();
//     GoogleSignInAccount account = await googleSignIn.signIn();
//     if (account == null) return false;
//     AuthResult res =
//         await _auth.signInWithCredential(GoogleAuthProvider.getCredential(
//       idToken: (await account.authentication).idToken,
//       accessToken: (await account.authentication).accessToken,
//     ));

//     try {
//       const url = 'http://agni-api.infous.xyz/api/store-user';

//       final response = await http.post(
//         url,
//         body: json.encode({
//           'uid': res.user.uid,
//           'name': res.user.displayName,
//           'email': res.user.email,
//           'profile_pic': res.user.photoUrl,
//         }),
//       );
//       print(json.decode(response.body));

//       if (res.user == null) {
//         return false;
//       }
//       return true;
//     } catch (e) {
//       print(e.message);
//       print("Error logging with google");
//       return false;
//     }
//   }
// }
