import '../database/base.dart';
import '../models/utilizador.dart';

class AuthService {
  static Utilizador? utilizadorAtual;

  // ✅ VALIDAÇÃO DE EMAIL
  static bool _isValidEmail(String email) {
    return email.contains('@') && email.contains('.') && email.length > 5;
  }

  // ✅ VALIDAÇÃO DE SENHA
  static bool _isValidPassword(String senha) {
    return senha.length >= 4; // Mínimo 4 caracteres
  }

  static bool login(String email, String senha) {
    // 🔴 VALIDAÇÃO
    if (email.isEmpty || senha.isEmpty) {
      return false;
    }

    final user = _findByEmail(email);

    if (user == null) return false;
    if (user.senha != senha) return false;

    utilizadorAtual = user;
    return true;
  }

  static bool register(String nome, String email, String senha) {
    // 🔴 VALIDAÇÃO
    if (nome.isEmpty || email.isEmpty || senha.isEmpty) {
      return false;
    }

    if (!_isValidEmail(email)) {
      return false; // Email inválido
    }

    if (!_isValidPassword(senha)) {
      return false; // Senha muito fraca
    }

    final exists = FakeDatabase.utilizadores.any(
      (u) => u.email == email,
    );

    if (exists) return false;

    final novo = Utilizador(
      id: FakeDatabase.utilizadores.length + 1,
      nome: nome,
      email: email,
      senha: senha,
    );

    FakeDatabase.utilizadores.add(novo);
    utilizadorAtual = novo;

    return true;
  }

  static void logout() {
    utilizadorAtual = null;
  }

  static bool isLogged() => utilizadorAtual != null;

  static Utilizador? _findByEmail(String email) {
    try {
      return FakeDatabase.utilizadores.firstWhere(
        (u) => u.email == email,
      );
    } catch (_) {
      return null;
    }
  }
}