// CLASSE DE APOIO AS OPERAÇÕES DO JWT ///

import 'package:dotenv/dotenv.dart';
import 'package:jaguar_jwt/jaguar_jwt.dart';

class JwtHelper {
  static final String _jwtSecret = env['JWT_SECRET'] ?? env['jwtSecret']!;

  JwtHelper._();

  // Valida o token JWT
  static JwtClaim getClaimns(String token) {
    return verifyJwtHS256Signature(token, _jwtSecret);
  }
}
