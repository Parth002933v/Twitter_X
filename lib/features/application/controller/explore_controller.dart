import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_x/APIs/api.dart';
import 'package:twitter_x/model/model.dart';

final searchUserProvider =
    FutureProvider.family.autoDispose((ref, String name) async {
  final authController = ref.watch(exploreControllerProvider.notifier);

  return authController._searchUser(name: name);
});

final exploreControllerProvider =
    StateNotifierProvider<_ExploreControllerNotifier, bool>((ref) {
  final userAPI = ref.read(UserAPIProvider);

  return _ExploreControllerNotifier(userAPI: userAPI);
});

class _ExploreControllerNotifier extends StateNotifier<bool> {
  final UserAPI _userAPI;

  _ExploreControllerNotifier({
    required UserAPI userAPI,
  })  : _userAPI = userAPI,
        super(false);

  Future<List<UserModel>> _searchUser({required String name}) async {
    final res = await _userAPI.serachUser(name: name);

    return res.map((e) => UserModel.fromMap(e.data)).toList();
  }
}
