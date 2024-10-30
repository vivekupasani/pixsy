import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pixsy/features/profile/domain/profile_user.dart';
import 'package:pixsy/features/search/domain/search_repo.dart';

class SearchFirebaseRepo implements SearchRepo {
  final userCollection = FirebaseFirestore.instance.collection("users");

  @override
  Future<List<ProfileUser?>> searchUser(String query) async {
    try {
      final result = await userCollection
          .where('name', isGreaterThanOrEqualTo: query)
          .where('name', isLessThanOrEqualTo: '$query\uf8ff')
          .get();

      final users = result.docs
          .map(
            (user) => ProfileUser.fromJson(user.data()),
          )
          .toList();

      return users;
    } catch (e) {
      throw Exception(e);
    }
  }
}
