import 'package:flutter/material.dart';
import '../models/transaction.dart';

final List<Transaction> transacoes =[
    Transaction(
        nome: "Centi",
        valor: 30,
        data : "23/06/2026",
        icone: Icons.movie,
    ),
    Transaction(nome:"Vini",
    valor:229.99, 
    data:"23/06/2026",
    icone:Icons.account_circle,
    ),
    Transaction(nome:"Leo",
    valor:219.99, 
    data:"23/06/2026",
    icone:Icons.account_circle,
    ),
    Transaction(nome:"Yuri",
    valor:2199.99, 
    data:"23/06/2026",
    icone:Icons.account_circle,
    )
];