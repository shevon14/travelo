import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';



class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  final _userCollectionReference = Firestore.instance;


  Stream<String> get onAuthStateChanged => _firebaseAuth.onAuthStateChanged.map(
    (FirebaseUser user )=> user?.uid,
  );
  
  //Email & Password Sign Up
  Future <String> createUserWithEmailAndPassword(String email, String password, 
  String firstname, String lastname, String gender, String contact, String profileimg) async {

      final currentUser = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password,);


      await _userCollectionReference
          .collection('Users')
          .document(currentUser.uid)
          .setData({
        'firstname': '$firstname',
        'lastname': '$lastname',
        'email': '$email',
        'contact': '$contact',
        'gender': '$gender',
        'profileimg': '$profileimg'
      });



        //update the username
        var userUpdateInfo = UserUpdateInfo();
        userUpdateInfo.displayName = firstname + " " + lastname;
        await currentUser.updateProfile(userUpdateInfo);
        await currentUser.reload();
        return currentUser.uid;
  }

  //Email & Password Sign In
  Future <String> signinWithEmailAndPassword(String email, String password) async{
    return (await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password)).uid;
  }

  //Sign Out
  signOut(){
    return _firebaseAuth.signOut();
  }

  //reset password
  Future sendPasswordResetEmail(String email) async {
    return _firebaseAuth.sendPasswordResetEmail(email: email);
  }

}

class EmailValidator{
  static String validate(String value){
    if(value.isEmpty){
      return "Email can't be empty";
    }
    return null;
  }
}

class PasswordValidator{
  static String validate(String value){
    if(value.isEmpty){
      return "Password can't be empty";
    }
    return null;
  }
}

class RepeatPasswordValidator{
  static String validate(String value){
    if(value.isEmpty){
      return "Password can't be empty";
    }
    return null;
  }
}

class NameValidator{
  static String validate(String value){
    if(value.isEmpty){
      return "Name can't be empty";
    }
    if (value.length < 2) {
      return "Name must be at least 2 characters long";
    }
    if (value.length > 15) {
      return "Name must be less than 15 characters long";
    }
    return null;
  }
}


class ContactValidator{
  static String validate(String value){
    if(value.isEmpty){
      return "Contact number can't be empty";
    }
    if (value.length != 10) {
      return "Mobile number is not valid";
    }
    return null;
  }
}

class genderValidator{
  static String validate(String value){
    if(value.isEmpty){
      return "Select a gender";
    }
    return null;
  }
}

class HashTagsValidator{
  static String validate(String value){
    if(value.isEmpty){
      return "Add at least one hash tag";
    }
    return null;
  }
}





