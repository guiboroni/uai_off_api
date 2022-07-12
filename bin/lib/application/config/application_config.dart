/// CLASSE QUE CARREGA TODAS AS CONFIGURAÇÕES INICIAIS DO APP ///

import 'package:dotenv/dotenv.dart' show env, load;
import 'package:get_it/get_it.dart';
import 'package:shelf_router/shelf_router.dart';

import '../logger/i_logger.dart';
import '../logger/logger.dart';
import '../routers/router_configure.dart';
import 'database_connection_configuration.dart';
import 'service_locator_config.dart';

class ApplicationConfig {
  Future<void> loadConfigApplication(Router router) async {
    await _loadEnv();
    _loadDatabaseConfig();
    _configLogger();
    _loadDependencies();
    _loadRoutersConfig(router);
  }

  // Carrega as informações do arquivo .env
  Future<void> _loadEnv() async => load();

  // Carrega as configurações do banco de dados
  void _loadDatabaseConfig() {
    // ignore: unnecessary_new
    final databaseConfig = new DatabaseConnectionConfiguration(
      host: env['DATABASE_HOST'] ?? env['databaseHost']!,
      user: env['DATABASE_USER'] ?? env['databaseUser']!,
      password: env['DATABASE_PASSWORD'] ?? env['databasePassword']!,
      databaseName: env['DATABASE_NAME'] ?? env['databaseName']!,
      port: int.tryParse(env['DATABASE_PORT'] ?? env['databasePort']!) ?? 0,
    );

    // Registra a configuração na memória, 1 instancia apenas
    GetIt.I.registerSingleton(databaseConfig);
  }

  // Registra a configuração dos logs na memória, 1 instancia apenas quando ela for chamada (lazy)
  void _configLogger() =>
      GetIt.I.registerLazySingleton<ILogger>(() => Logger());

  // Carrega as configurações de dependencia do GetIt
  void _loadDependencies() => configureDependencies();

  // Carrega as configurações de rotas do shelf
  void _loadRoutersConfig(Router router) => RouterConfigure(router).configure();
}
