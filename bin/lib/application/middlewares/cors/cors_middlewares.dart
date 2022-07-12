/// CLASSE DE CONTROLE INICIAL DAS REQUISIÇÕES RECEBIDAS PELO APP ///

import 'dart:io';

import 'package:shelf/src/response.dart';

import 'package:shelf/src/request.dart';

import '../middlewares.dart';

class CorsMiddlewares extends Middlewares {
  final Map<String, String> headers = {
    'Access-Control-Allow-Origin': '*',
    'Access-Control-Allow-Methos': 'GET, POST, PATCH, PUT, DELETE, OPTIONS',
    'Access-Control-Allow-Header':
        '${HttpHeaders.contentTypeHeader}, ${HttpHeaders.authorizationHeader}'
  };

  @override
  Future<Response> execute(Request request) async {
    // A requisição inicial é sempre a de OPTIONS para verificar as options de acesso permitidas ao app
    if (request.method == 'OPTIONS') {
      return Response(HttpStatus.ok, headers: headers);
    }

    // Executa a requisição em si
    final response = await innerHandler(request);

    // Adiciona os headers de segura no headers da requisição
    return response.change(headers: headers);
  }
}
