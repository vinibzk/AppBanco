import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:app_banco/services/auth_service.dart';
import 'package:app_banco/database/base.dart';

import 'package:app_banco/models/utilizador.dart';
import 'package:app_banco/models/conta.dart';

class WalletPage extends StatelessWidget {
  const WalletPage({super.key});

  // 🔴 OBTER DADOS DO UTILIZADOR LOGADO
  Utilizador get user => AuthService.utilizadorAtual!;

  // 🔴 OBTER CONTAS DO UTILIZADOR
  List<Conta> get minhasContas =>
      FakeDatabase.contas.where((c) => c.id_utilizador == user.id).toList();

  @override
  Widget build(BuildContext context) {
    final NumberFormat euroFormat = NumberFormat.currency(
      locale: 'pt_PT',
      symbol: '€',
    );

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionLabel('Os meus cartões'),
          const SizedBox(height: 10),
          _cartoesList(),
          const SizedBox(height: 24),
          _sectionLabel('Saldo por conta'),
          const SizedBox(height: 10),
          _saldoPorConta(euroFormat),
          const SizedBox(height: 24),
          _sectionLabel('Investimentos & Poupanças'),
          const SizedBox(height: 10),
          _investimentos(context),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _sectionLabel(String text) {
    return Text(
      text.toUpperCase(),
      style: const TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        color: Colors.grey,
        letterSpacing: 1.0,
      ),
    );
  }

  // ── CARTÕES ──────────────────────────────────────────────────────────────

  Widget _cartoesList() {
    return SizedBox(
      height: 140,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _cartaoItem(
            tipo: 'Débito',
            numero: '•••• •••• •••• 4821',
            titular: user.nome,
            validade: '05/28',
            cor: const Color(0xFF6C3FC5),
          ),
          const SizedBox(width: 12),
          _cartaoItem(
            tipo: 'Crédito',
            numero: '•••• •••• •••• 7340',
            titular: user.nome,
            validade: '11/27',
            cor: const Color(0xFF3C2D8C),
          ),
          const SizedBox(width: 12),
          _adicionarCartaoButton(),
        ],
      ),
    );
  }

  Widget _cartaoItem({
    required String tipo,
    required String numero,
    required String titular,
    required String validade,
    required Color cor,
  }) {
    return Container(
      width: 210,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(tipo,
                  style: const TextStyle(
                      color: Colors.white70, fontSize: 13)),
              const Icon(Icons.credit_card,
                  color: Colors.white54, size: 20),
            ],
          ),
          Text(numero,
              style: const TextStyle(
                  color: Colors.white70, fontSize: 13)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('TITULAR',
                      style: TextStyle(
                          color: Colors.white54,
                          fontSize: 9,
                          letterSpacing: 0.8)),
                  Text(titular,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w500)),
                ],
              ),
              Text(validade,
                  style: const TextStyle(
                      color: Colors.white54, fontSize: 11)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _adicionarCartaoButton() {
    return Container(
      width: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
            color: const Color(0xFFC4B5FD), width: 1.5, style: BorderStyle.solid),
      ),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.add, color: Color(0xFF7C3AED), size: 24),
          SizedBox(height: 6),
          Text(
            'Adicionar\ncartão',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 12,
                color: Color(0xFF7C3AED),
                height: 1.3),
          ),
        ],
      ),
    );
  }

  // ── SALDO POR CONTA (DADOS REAIS) ───────────────────────────────────────

  Widget _saldoPorConta(NumberFormat euroFormat) {
    // 🔴 MOSTRAR CONTAS REAIS DO UTILIZADOR
    if (minhasContas.isEmpty) {
      return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        padding: const EdgeInsets.all(16),
        child: const Text(
          "Nenhuma conta criada",
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          // 🔴 LISTAR CONTAS REAIS
          ...minhasContas.asMap().entries.map((entry) {
            int index = entry.key;
            Conta conta = entry.value;
            bool showDivider = index < minhasContas.length - 1;

            return Column(
              children: [
                _contaItem(
                  icone: Icons.wallet_outlined,
                  titulo: conta.nome,
                  subtitulo: conta.tipo,
                  valor: euroFormat.format(conta.saldo),
                  detalhe: 'disponível',
                  valorCor: Colors.black87,
                  showDivider: showDivider,
                ),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _contaItem({
    required IconData icone,
    required String titulo,
    required String subtitulo,
    required String valor,
    required String detalhe,
    required Color valorCor,
    required bool showDivider,
  }) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: const Color(0xFFEDE9FE),
                  shape: BoxShape.circle,
                ),
                child: Icon(icone,
                    size: 18, color: const Color(0xFF6C3FC5)),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(titulo,
                        style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500)),
                    Text(subtitulo,
                        style: const TextStyle(
                            fontSize: 12, color: Colors.grey)),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(valor,
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: valorCor)),
                  Text(detalhe,
                      style: const TextStyle(
                          fontSize: 11, color: Colors.grey)),
                ],
              ),
            ],
          ),
        ),
        if (showDivider)
          Divider(height: 1, thickness: 0.5, color: Colors.grey.shade200),
      ],
    );
  }

  // ── INVESTIMENTOS ─────────────────────────────────────────────────────────

  Widget _investimentos(BuildContext context) {
    return Column(
      children: [
        _investimentoItem(
          icone: Icons.trending_up,
          iconeBg: const Color(0xFFD1FAE5),
          iconeColor: const Color(0xFF0F6E56),
          titulo: 'Cofre Automático',
          subtitulo: 'Rendimento 3,2% a.a.',
          valor: '€ 520,00',
          detalhe: '+ € 4,12 este mês',
          detalheColor: const Color(0xFF1D9E75),
          valorColor: const Color(0xFF0F6E56),
        ),
        const SizedBox(height: 10),
        _investimentoItem(
          icone: Icons.bar_chart,
          iconeBg: const Color(0xFFFEF3C7),
          iconeColor: const Color(0xFF854F0B),
          titulo: 'Fundos de Investimento',
          subtitulo: '3 fundos ativos',
          valor: '€ 1.870,00',
          detalhe: '+ 2,4%',
          detalheColor: const Color(0xFF0F6E56),
          valorColor: Colors.black87,
        ),
        const SizedBox(height: 10),
        OutlinedButton.icon(
          onPressed: null,
          icon: const Icon(Icons.add, size: 16),
          label: const Text('Novo cofre ou investimento'),
          style: OutlinedButton.styleFrom(
            minimumSize: const Size(double.infinity, 44),
            foregroundColor: const Color(0xFF6C3FC5),
            side: const BorderSide(
                color: Color(0xFFC4B5FD), style: BorderStyle.solid),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8)),
          ),
        ),
      ],
    );
  }

  Widget _investimentoItem({
    required IconData icone,
    required Color iconeBg,
    required Color iconeColor,
    required String titulo,
    required String subtitulo,
    required String valor,
    required String detalhe,
    required Color detalheColor,
    required Color valorColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(color: iconeBg, shape: BoxShape.circle),
            child: Icon(icone, size: 18, color: iconeColor),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(titulo,
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w500)),
                Text(subtitulo,
                    style: const TextStyle(
                        fontSize: 12, color: Colors.grey)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(valor,
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: valorColor)),
              Text(detalhe,
                  style: TextStyle(fontSize: 11, color: detalheColor)),
            ],
          ),
        ],
      ),
    );
  }
}

// 🔴 IMPORTAR TIPOS
