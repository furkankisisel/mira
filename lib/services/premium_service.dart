import 'package:firebase_auth/firebase_auth.dart';

class PremiumService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Firebase Custom Claims'ten premium bilgisini okur
  Future<bool> checkIsPremium({bool forceRefresh = false}) async {
    final user = _auth.currentUser;
    if (user == null) return false;

    final tokenResult = await user.getIdTokenResult(forceRefresh);
    final claims = tokenResult.claims;

    return claims?['premium'] == true;
  }
}
