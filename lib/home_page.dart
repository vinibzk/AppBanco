import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ex012/pages/walletPage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PageController _pageController = PageController();

  int indexBottomNavigationBar = 0;

  double saldo = 1250.00;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Widget _paginaExemplo(BuildContext context) {
    final NumberFormat euroFormat = NumberFormat.currency(
      locale: 'pt_PT',
      symbol: '€',
    );

    return Column(
      children: [
        Container(
          height: 200,
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(color: Colors.purple),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Saldo Disponível",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                const SizedBox(height: 8),
                Text(
                  euroFormat.format(saldo),
                  style: const TextStyle(
                    fontSize: 40,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              onPressed: null,
              icon: Image.asset(
                'assets/icons/MBway.png',
                height: 40,
                width: 55,
              ),
            ),
            IconButton(onPressed: null, icon: const Icon(Icons.currency_exchange)),
            IconButton(onPressed: null, icon: const Icon(Icons.payments)),
            IconButton(onPressed: null, icon: const Icon(Icons.currency_bitcoin)),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.55,
        title: Text(
          'Nubank',
          style: GoogleFonts.rubikMonoOne(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.account_circle_outlined,
              size: 30,
              color: Colors.black,
            ),
            onPressed: null,
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
          _paginaExemplo(context),
          const WalletPage(),
          Container(color: const Color.fromARGB(255, 255, 0, 0)),
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
        backgroundColor: Colors.white,
        elevation: 0,
        height: 60,
        indicatorColor: Colors.transparent,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined, size: 30),
            selectedIcon: Icon(Icons.home),
            label: 'Início',
          ),
          NavigationDestination(
            icon: Icon(Icons.wallet_outlined, size: 30),
            selectedIcon: Icon(Icons.wallet),
            label: 'Carteira',
          ),
          NavigationDestination(
            icon: Icon(Icons.swap_horiz_outlined, size: 30),
            selectedIcon: Icon(Icons.swap_horiz),
            label: 'Transferências',
          ),
        ],
      ),
    );
  }
}