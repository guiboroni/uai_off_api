import 'package:injectable/injectable.dart';
import 'package:uai_off_api/entities/user.dart';
import 'package:uai_off_api/modules/user/data/i_user_repository.dart';
import 'package:uai_off_api/modules/user/view_models/user_save_input_model.dart';

import './i_user_service.dart';

@LazySingleton(as: IUserService)
class UserService implements IUserService {
  final IUserRepository userRepository;
  UserService({
    required this.userRepository,
  });

  @override
  Future<User> createUser(UserSaveInputModel user) {
    final userEntity = User(
      email: user.email,
      password: user.password,
      storeId: user.storeId,
    );

    return userRepository.createUser(userEntity);
  }
}
