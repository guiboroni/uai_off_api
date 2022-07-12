/// CLASSE DE MAPEAMENTO DE TODAS AS ROTAS DO APP //

import 'package:shelf_router/shelf_router.dart';

import '../../modules/user/user_router.dart';
import 'i_router.dart';

class RouterConfigure {
  final Router _router;
  final List<IRouter> _routers = [
    UserRouter(),
  ];

  RouterConfigure(this._router);

  void configure() => _routers.forEach((router) => router.configure(_router));
}
