import 'package:capstone/models/user_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';

class Services {
  static Future createAccount({required UserData user}) async {
    try {
      final userRef =
          FirebaseFirestore.instance.collection('users').doc(user.id);

      await userRef.set(user.toJson());

      return true;
    } on FirebaseException catch (_) {
      return false;
    }
  }

  static Future<UserData> getUser({required String id}) =>
      FirebaseFirestore.instance
          .collection('users')
          .doc(id)
          .get()
          .then((doc) => UserData.fromJson(doc.data()!, doc.id));

  static DatabaseReference getTags() => FirebaseDatabase.instance.ref("tags");
}
