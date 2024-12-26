import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart'; 
//import 'package:serenadepalace/admin/admin_service.dart';


class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<User?> signIn(String email, String password) async {
    try {
      var user = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return user.user;
    } catch (e) {
      print("Error: $e");

      if (e is FirebaseAuthException && e.code == 'wrong-password') {
        return null;
      }

      return null;
    }
  }

  signOut() async {
    return await _auth.signOut();
  }

 Future<User?> createPerson(
  String name,
  String email,
  String password,
 ) async {
  try {
    var userCredential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    DateTime initialLoginDate = DateTime.now();

    await _firestore.collection("Person").doc(userCredential.user!.uid).set({
      'userName': name, // Kullanıcı adı
      'email': email, // Kullanıcı e-posta
      'lastResetDate': DateFormat('yyyy-MM-dd').format(initialLoginDate), // Son şifre sıfırlama tarihi
      'roomNumber': null, // Varsayılan oda numarası
      'startDate': null, // Varsayılan giriş tarihi
      'endDate': null, // Varsayılan çıkış tarihi
      'cost': 0.0, // Varsayılan ücret
      'confirmed': false, // Rezervasyon onay durumu
      'isCheckedOut': false, // Check-out yapılıp yapılmadığını kontrol için
      'createdAt': FieldValue.serverTimestamp(), // Hesap oluşturma tarihi
      'updatedAt': FieldValue.serverTimestamp(), // Hesap güncelleme tarihi
    });

    await sendEmailVerification();

    return userCredential.user;
  } catch (e) {
    print("Error: $e");

    if (e is FirebaseAuthException) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('This email already exists.');
      } else {
        print('An error occurred while creating the user.');
      }
    }

    return null;
  }
 }



  Future<String?> getUserName() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot<Map<String, dynamic>> snapshot =
          await FirebaseFirestore.instance.collection('Person').doc(user.uid).get();
      return snapshot.data()?['userName'];
    }
    return null;
  } 



  Future<void> sendEmailVerification() async {
    try {
      User? user = _auth.currentUser;
      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
        print('Email sended');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

 Future<void> resetPassword(String email) async {
  try {
    await _auth.sendPasswordResetEmail(email: email);
    print('Email sent.');
  } catch (e) {
    print('Error: $e');
    throw e; 
  }
 }

 Future<String?> getUserId() async {
  try {
    User? user = _auth.currentUser;
    if (user != null) {
      return user.uid;
    }
  } catch (e) {
    print('error: $e');
  }
  return null;
 }


 Future<User?> createStaff(
  String name,
  String email,
  String password,
  String selectedJob,
 ) async {
  try {

    var staffCredential = await _auth.createUserWithEmailAndPassword(
      email: email, 
      password: password,
    );

    DateTime initialLoginDate = DateTime.now();

    await _firestore.collection("Staff").doc(staffCredential.user!.uid).set({
      'userName': name,
      'email': email,
      'type': selectedJob,
      'DateOfStart': DateFormat('yyyy-MM-dd').format(initialLoginDate),

    });

    await sendEmailVerification();

    return staffCredential.user;
  } catch (e) {
    print("Error: $e");

    if (e is FirebaseAuthException) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('This email already exists.');
      } else {
        print('An error occurred while creating the user.');
      }
    }

    return null;
  }
 }


  Future<String?> getLastResetDate() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        DocumentSnapshot<Map<String, dynamic>> snapshot =
            await _firestore.collection('Person').doc(user.uid).get();
        if (snapshot.exists) {
          return snapshot.data()?['lastResetDate'];
        }
      }
    } catch (e) {
      print('error: $e');
    }
    return null;
  }

  

  Future<void> updateLastResetDate(DateTime date) async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        await _firestore.collection('Person').doc(user.uid).update({'lastResetDate': DateFormat('yyyy-MM-dd').format(date)});
      }
    } catch (e) {
      print('error: $e');
    }
  }  







}
