import 'package:firebase_auth/firebase_auth.dart';

class AdminService {
  final String adminUid = 'Gi6o410p37X62iVoZ1mzJ8Bsx9m2'; // Admin kullanıcının ID'si

  Future<bool> isAdmin() async {
    try {
      String? currentUid = FirebaseAuth.instance.currentUser?.uid;
      return currentUid == adminUid;
    } catch (e) {
      return false;
    }
  }
}

