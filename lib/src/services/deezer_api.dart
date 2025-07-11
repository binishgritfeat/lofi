import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/track.dart';

class DeezerApiService {
  static Future<List<Track>> fetchLofiTracks() async {
    // Deezer API via CORS proxy (as described in LOFI.md)
    const url = 'https://corsproxy.io/?https://api.deezer.com/search?q=lofi';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List tracksJson = data['data'] ?? [];
      return tracksJson
          .map(
            (json) => Track(
              id: json['id'],
              title: json['title'],
              artist: json['artist']['name'],
              album: json['album']['title'],
              cover: json['album']['cover_big'],
              preview: json['preview'],
              duration: json['duration'],
            ),
          )
          .toList();
    } else {
      throw Exception('Failed to load tracks from Deezer API');
    }
  }
}
