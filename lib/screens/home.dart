import 'package:flutter/material.dart';
import '../models/country_model.dart';
import '../services/api_service.dart';
import '../services/auth_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Country>> futureCountries;
  final ApiService apiService = ApiService();

  @override
  void initState() {
    super.initState();
    futureCountries = apiService.fetchCountries();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Estende o corpo atrás da AppBar para o gradiente ser contínuo
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          'Tela principal com API',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.deepPurple),
        ),
        centerTitle: true,
        backgroundColor: Colors.white.withOpacity(0.8),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.deepPurple),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app_rounded),
            tooltip: 'Sair',
            onPressed: () async {
              // 1. Mostrar Feedback (SnackBar)
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Row(
                    children: [
                      Icon(Icons.waving_hand_rounded, color: Colors.white, size: 20),
                      SizedBox(width: 10),
                      Text('Você saiu. Até logo!'),
                    ],
                  ),
                  backgroundColor: Colors.deepPurple.shade400,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  margin: const EdgeInsets.all(10),
                  duration: const Duration(seconds: 2),
                ),
              );

              // 2. Realizar Logout no Firebase
              await AuthService().signOut();
            },
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFEDE7F6),
              Color(0xFFD1C4E9),
            ],
          ),
        ),
        child: FutureBuilder<List<Country>>(
          future: futureCountries,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(color: Colors.deepPurple),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, size: 60, color: Colors.deepPurple.shade300),
                    const SizedBox(height: 10),
                    Text(
                      'Ocorreu um erro.',
                      style: TextStyle(color: Colors.deepPurple.shade700, fontSize: 16),
                    ),
                    const SizedBox(height: 5),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        '${snapshot.error}',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.deepPurple.shade400, fontSize: 12),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
                          futureCountries = apiService.fetchCountries();
                        });
                      },
                      icon: const Icon(Icons.refresh),
                      label: const Text("Tentar Novamente"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        foregroundColor: Colors.white,
                      ),
                    )
                  ],
                ),
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(
                child: Text(
                  'Nenhum dado encontrado',
                  style: TextStyle(color: Colors.deepPurple.shade700),
                ),
              );
            }

            return ListView.builder(
              // Adiciona padding no topo para a lista não começar escondida atrás da AppBar
              padding: const EdgeInsets.fromLTRB(20, 100, 20, 20),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                Country country = snapshot.data![index];
                return CountryCard(country: country);
              },
            );
          },
        ),
      ),
    );
  }
}

class CountryCard extends StatelessWidget {
  final Country country;

  const CountryCard({super.key, required this.country});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9), // Fundo branco transparente
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.deepPurple.withOpacity(0.15),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            // TO-DO: Navegar para detalhes do país
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Bandeira com estilo arredondado e sombra
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      country.flagUrl,
                      width: 70,
                      height: 50,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        width: 70,
                        height: 50,
                        color: Colors.grey.shade200,
                        child: Icon(Icons.flag, color: Colors.deepPurple.shade200),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 20),

                // Informações de texto
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        country.commonName,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple.shade800,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(Icons.location_city, size: 14, color: Colors.deepPurple.shade300),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              country.capital,
                              style: TextStyle(
                                color: Colors.deepPurple.shade500,
                                fontSize: 14,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.groups, size: 14, color: Colors.deepPurple.shade300),
                          const SizedBox(width: 4),
                          Text(
                            'Pop: ${country.population}',
                            style: TextStyle(
                              color: Colors.deepPurple.shade400,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Colors.deepPurple.shade200),
              ],
            ),
          ),
        ),
      ),
    );
  }
}