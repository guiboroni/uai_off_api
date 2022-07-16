import 'package:injectable/injectable.dart';
import 'package:mysql1/mysql1.dart';
import 'package:uai_off_api/application/database/i_database_connection.dart';
import 'package:uai_off_api/application/exceptions/database_exception.dart';
import 'package:uai_off_api/application/exceptions/user_exists_exception.dart';
import 'package:uai_off_api/application/helpers/cripty_helper.dart';
import 'package:uai_off_api/application/logger/i_logger.dart';
import 'package:uai_off_api/entities/user.dart';

import './i_user_repository.dart';

@LazySingleton(as: IUserRepository)
class UserRepository implements IUserRepository {
  final IDatabaseConnection connection;
  final ILogger log;

  UserRepository({
    required this.connection,
    required this.log,
  });

  @override
  Future<User> createUser(User user) async {
    MySqlConnection? conn;

    try {
      conn = await connection.openConnection();
      final query =
          '''
          insert into usuarios(email, senha, img, loja_id, social_id)
          values(?,?,?,?,?)
        ''';

      final result = await conn.query(query, [
        user.email,
        CriptyHelper.generateSha256Hash(user.password ?? ''),
        user.img,
        user.storeId,
        user.socialKey,
      ]);

      final userId = result.insertId;

      // Retorna uma copia do usuário já com o id criado no banco e setando a senha para null
      return user.copyWith(id: userId, password: null);
    } on MySqlException catch (e, s) {
      if (e.message.contains('usuario.email_UNIQUE')) {
        log.error('Usuario ja cadastrado na base de dados', e, s);
        throw UserExistsException();
      }
      log.error('Erro ao criar usuario', e, s);
      throw DatabaseException(message: 'Erro ao criar usuario', exception: e);
    } finally {
      await conn?.close();
    }
  }
}
