class Country {
  final String commonName;
  final String officialName;
  final String flagUrl;
  final String capital;
  final int population;

  Country({
    required this.commonName,
    required this.officialName,
    required this.flagUrl,
    required this.capital,
    required this.population,
  });

  // Fábrica para criar um País a partir do JSON da API
  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
      // A API retorna o nome dentro de um objeto 'name' -> 'common'
      commonName: json['name']['common'] ?? 'Nome desconhecido',
      officialName: json['name']['official'] ?? '',
      // A bandeira vem dentro de 'flags' -> 'png'
      flagUrl: json['flags']['png'] ?? '',
      // A capital é uma lista, pegamos a primeira ou avisamos que não tem
      capital: (json['capital'] as List?)?.isNotEmpty == true
          ? json['capital'][0]
          : 'Sem capital',
      population: json['population'] ?? 0,
    );
  }
}