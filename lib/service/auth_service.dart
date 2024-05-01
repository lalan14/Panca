import 'package:firebase_auth/firebase_auth.dart';
import 'package:panca/helper/helper_function.dart';
import 'package:panca/service/database_service.dart';

class AuthService {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  
  get logger => null;

  // login
  Future<bool> loginWithUserNameandPassword(String email, String password) async {
    try {
      await firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      return true;
    } on FirebaseAuthException catch (e) {
      logger.e("Error Logging in: ${e.message}");
      return false;
    }
  }

  // register
  Future<bool> registerUserWithEmailandPassword(
      String fullName, String email, String password) async {
    try {
      await firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      // call our database service to update the user data.
      await DatabaseService(uid: firebaseAuth.currentUser!.uid).savingUserData(fullName, email);
      return true;
    } on FirebaseAuthException catch (e) {
      logger.e("Error Registering user: ${e.message}");
      return false;
    }
  }

  // signout
  Future signOut() async {
    try {
      await HelperFunctions.saveUserLoggedInStatus(false);
      await HelperFunctions.saveUserEmailSF("");
      await HelperFunctions.saveUserNameSF("");
      await firebaseAuth.signOut();
    } catch (e) {
      logger.e("Error Signing out: $e");
      return null;
    }
  }
}
