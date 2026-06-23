import 'package:flutter/material.dart';
class Transaction {
    String nome;
    double valor;
    String data;
    IconData icone;

Transaction({
    required this.nome,
    required this.valor,
    required this.data,
    required this.icone
});
}
