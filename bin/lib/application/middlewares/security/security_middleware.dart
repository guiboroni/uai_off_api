import 'dart:convert';

import 'package:jaguar_jwt/jaguar_jwt.dart';
import 'package:shelf/src/response.dart';

import 'package:shelf/src/request.dart';

import '../../helpers/jwt_helper.dart';
import '../../logger/i_logger.dart';
import '../middlewares.dart';
import 'security_skip_url.dart';

class SecurityMiddleware extends Middlewares {
  final ILogger log;
  final skipUrl = <SecuritySkipUrl>[];

  SecurityMiddleware(this.log);

  @override
  Future<Response> execute(Request request) async {
    try {
      // Verifica se a url executada está na lista de urls permitidas sem a necessidade
      // de validação.
      if (skipUrl.contains(SecuritySkipUrl(
          url: '/${request.url.path}', method: request.method))) {
        return innerHandler(request);
      }

      // Pega o header de autorização (token)
      final authHeader = request.headers['Authorization'];

      // Se não veio o token de autorização, acesso negado
      if (authHeader == null || authHeader.isEmpty) {
        throw JwtException.invalidToken;
      }

      // Pega o conteúdo do token de autorização
      final authHeaderContent = authHeader.split(' ');

      // Se não veio no início do token a palavra Bearer, acesso negado
      if (authHeaderContent[0] != 'Bearer') {
        throw JwtException.invalidToken;
      }

      // Pega o token em si, descriptografa e traz as informações contidas nele
      final authorizationToken = authHeaderContent[1];
      final claims = JwtHelper.getClaimns(authorizationToken);

      // Valida apenas se não é um refresh do token
      if (request.url.path != 'auth/refresh') {
        claims.validate();
      }

      // Pega os dados e faz as validações dos usuários a logar, comum ou administrator
      final claimsMap = claims.toJson();
      final userId = claimsMap['sub'];
      final storeId = claimsMap['store'];

      if (userId == null) {
        throw JwtException.invalidToken;
      }

      // Se chegou aqui tudo está ok, então adiciona no header da requisição os headers de segurança
      final securityHeaders = {
        'user': userId,
        'access_token': authorizationToken,
        'store': storeId
      };
      return innerHandler(request.change(headers: securityHeaders));
    } on JwtException catch (e, s) {
      log.error('Erro ao validar token JWT', e, s);
      return Response.forbidden(jsonEncode({}));
    } catch (e, s) {
      log.error('Internal Server Error', e, s);
      return Response.forbidden(jsonEncode({}));
    }
  }
}
