import '../models/conta.dart';
import '../models/utilizador.dart';

class FakeDatabase {
  static List<Conta> contas = [
    Conta(
      id: 1,
      nome: "Conta Principal",
      saldo: 1500.50,
      tipo: "Corrente",
      id_utilizador: 1,
    ),
    Conta(
      id: 2,
      nome: "Poupança",
      saldo: 3200.00,
      tipo: "Poupança",
      id_utilizador: 2,
    ),
    Conta(
      id: 3,
      nome: "Conta Jovem",
      saldo: 250.75,
      tipo: "Corrente",
      id_utilizador: 1,
    ),
    Conta(
      id: 4,
      nome: "Investimentos",
      saldo: 10000.00,
      tipo: "Investimento",
      id_utilizador: 2,
    ),
    Conta(
      id: 5,
      nome: "Conta Secundária",
      saldo: 800.00,
      tipo: "Corrente",
      id_utilizador: 1,
    ),
  ];

  static List<Utilizador> utilizadores = [];
}