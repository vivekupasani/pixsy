import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:pixsy/features/profile/domain/profile_user.dart';
import 'package:pixsy/features/search/domain/search_repo.dart';

part 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  final SearchRepo searchRepo;
  SearchCubit(this.searchRepo) : super(SearchInitial());

  Future<void> searchUser(String query) async {
    try {
      if (query.isEmpty) {
        emit(SearchInitial());
      }
      
      emit(SearchLoading());

      final users = await searchRepo.searchUser(query);
      emit(SearchLoaded(user: users));
    } catch (e) {
      emit(SearchError(message: e.toString()));
    }
  }
}
