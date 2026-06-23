import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:app_banco/pages/walletPage.dart';
import 'package:app_banco/database/base.dart';
import 'package:app_banco/services/auth_service.dart';
import 'package:app_banco/pages/loginPage.dart';
import 'package:app_banco/models/utilizador.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PageController _pageController = PageController();

  int indexBottomNavigationBar = 0;
  bool saldoVisivel = true;

  // 🔐 UTILIZADOR LOGADO (SESSÃO)
  Utilizador get user => AuthService.utilizadorAtual!;

  // 💰 SALDO TOTAL DO UTILIZADOR
  double get saldo => FakeDatabase.contas
      .where((c) => c.id_utilizador == user.id)
      .fold(0.0, (sum, c) => sum + c.saldo);

  @override
  void initState() {
    super.initState();

    // 🔐 PROTEÇÃO DE ACESSO
    if (!AuthService.isLogged()) {
      Future.microtask(() {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const LoginPage()),
        );
      });
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  // 🔴 FUNÇÃO DE LOGOUT
  void _logout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Confirmar Logout"),
        content: const Text("Tem a certeza que deseja sair?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancelar"),
          ),
          TextButton(
            onPressed: () {
              AuthService.logout();
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const LoginPage()),
              );
            },
            child: const Text(
              "Sair",
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  // 🔴 PÁGINA INICIAL COM DADOS REAIS
  Widget _paginaInicio(BuildContext context) {
    final NumberFormat euroFormat = NumberFormat.currency(
      locale: 'pt_PT',
      symbol: '€',
    );

    return SingleChildScrollView(
      child: Column(
        children: [
          // CARD DO SALDO
          Container(
            height: 220,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF7C3AED), Color(0xFF6D28D9)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Olá ${user.nome}",
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    "Saldo disponível",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // 🔴 TOGGLER DE VISIBILIDADE DO SALDO
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        saldoVisivel ? euroFormat.format(saldo) : "••••••",
                        style: const TextStyle(
                          fontSize: 42,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 12),
                      IconButton(
                        icon: Icon(
                          saldoVisivel
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.white,
                          size: 24,
                        ),
                        onPressed: () {
                          setState(() {
                            saldoVisivel = !saldoVisivel;
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // AÇÕES RÁPIDAS
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Ações Rápidas",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _acaoRapida(Icons.currency_exchange, "Transferir"),
                    _acaoRapida(Icons.payments, "Pagamentos"),
                    _acaoRapida(Icons.currency_bitcoin, "Investir"),
                    _acaoRapida(Icons.add_circle_outline, "Pedir"),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // CONTAS DO UTILIZADOR
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Minhas Contas",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                // 🔴 LISTAR CONTAS REAIS DO UTILIZADOR
                ..._buildContasList(euroFormat),
              ],
            ),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // 🔴 CONSTRUIR LISTA DE CONTAS REAIS
  List<Widget> _buildContasList(NumberFormat euroFormat) {
    final minhasContas = FakeDatabase.contas
        .where((c) => c.id_utilizador == user.id)
        .toList();

    if (minhasContas.isEmpty) {
      return [
        const Card(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              "Nenhuma conta criada ainda",
              style: TextStyle(color: Colors.grey),
            ),
          ),
        ),
      ];
    }

    return minhasContas.map((conta) {
      return Card(
        margin: const EdgeInsets.only(bottom: 12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    conta.nome,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    conta.tipo,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              Text(
                euroFormat.format(conta.saldo),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
            ],
          ),
        ),
      );
    }).toList();
  }

  // WIDGET DE AÇÃO RÁPIDA
  Widget _acaoRapida(IconData icone, String label) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: Colors.deepPurple.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icone,
            color: Colors.deepPurple,
            size: 28,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(fontSize: 12),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
  backgroundColor: Colors.white,
  elevation: 0.5,
  title: Text(
    "Nubank",
    style: GoogleFonts.rubikMonoOne(
      fontSize: 20,
      color: Colors.black,
    ),
  ),
  actions: [
    PopupMenuButton<String>(
      icon: const Icon(Icons.account_circle_outlined),

      onSelected: (value) {
        switch (value) {
          case 'perfil':
            // TODO: navegar para perfil
            break;

          case 'definicoes':
            // TODO: navegar para definições
            break;

          case 'sair':
            _logout();
            break;
        }
      },

      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 'perfil',
          child: Text("Perfil"),
        ),
        const PopupMenuItem(
          value: 'definicoes',
          child: Text("Definições"),
        ),
        const PopupMenuDivider(),
        const PopupMenuItem(
          value: 'sair',
          child: Text(
            "Sair",
            style: TextStyle(color: Colors.red),
          ),
        ),
      ],
    ),
  ],
),

      body: PageView(
        controller: _pageController,
        onPageChanged: (page) {
          setState(() {
            indexBottomNavigationBar = page;
          });
        },
        children: [
          _paginaInicio(context),
          const WalletPage(),
          Container(
            color: Colors.red,
            child: const Center(
              child: Text("Página de Transferências em construção..."),
            ),
          ),
        ],
      ),

      bottomNavigationBar: NavigationBar(
        selectedIndex: indexBottomNavigationBar,
        onDestinationSelected: (int page) {
          setState(() {
            indexBottomNavigationBar = page;
          });

          _pageController.animateToPage(
            page,
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOut,
          );
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Início',
          ),
          NavigationDestination(
            icon: Icon(Icons.wallet_outlined),
            selectedIcon: Icon(Icons.wallet),
            label: 'Carteira',
          ),
          NavigationDestination(
            icon: Icon(Icons.swap_horiz_outlined),
            selectedIcon: Icon(Icons.swap_horiz),
            label: 'Transferências',
          ),
        ],
      ),
    );
  }
}