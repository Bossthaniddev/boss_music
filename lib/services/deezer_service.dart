import 'dart:convert';
import 'package:http/http.dart' as http;

class DeezerService {
  final String baseUrl = 'https://api.deezer.com';

  Future<List<dynamic>> fetchTracks(String playlistId) async {
    final response = await http.get(Uri.parse('$baseUrl/playlist/$playlistId'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['tracks']['data'];
    } else {
      throw Exception('Failed to load playlist');
    }
  }
}