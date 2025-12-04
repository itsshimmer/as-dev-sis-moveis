import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/country_model.dart';

class ApiService {
  // URL filtrada para trazer apenas o necessário (requisito da API, ela suporta até 10 fields.)
  final String apiUrl = "https://restcountries.com/v3.1/all?fields=name,flags,capital,population";

  Future<List<Country>> fetchCountries() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        // Decodifica o JSON
        List<dynamic> body = json.decode(response.body);

        // Converte a lista de JSONs em lista de objetos Country
        List<Country> countries = body.map((dynamic item) => Country.fromJson(item)).toList();

        return countries;
      } else {
        throw Exception('Falha ao carregar países');
      }
    } catch (e) {
      throw Exception('Erro de conexão: $e');
    }
  }
}