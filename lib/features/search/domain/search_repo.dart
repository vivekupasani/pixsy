import 'package:pixsy/features/profile/domain/profile_user.dart';

abstract class SearchRepo {
  Future<List<ProfileUser?>> searchUser(String query);
}
