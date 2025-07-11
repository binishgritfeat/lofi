import '../models/track.dart';

class DeezerApiService {
  static Future<List<Track>> fetchLofiTracks() async {
    // Mock data for development
    await Future.delayed(const Duration(seconds: 1));
    return [
      Track(
        id: 1,
        title: 'Lofi Chill',
        artist: 'DJ Relax',
        album: 'Lofi Nights',
        cover: 'https://placekitten.com/200/200',
        preview:
            'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3',
        duration: 180,
      ),
      Track(
        id: 2,
        title: 'Rainy Mood',
        artist: 'Calm Collective',
        album: 'Rainy Days',
        cover: 'https://placekitten.com/201/201',
        preview:
            'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3',
        duration: 200,
      ),
      Track(
        id: 3,
        title: 'Night Drive',
        artist: 'Synthwave',
        album: 'Midnight Roads',
        cover: 'https://placekitten.com/202/202',
        preview:
            'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-3.mp3',
        duration: 210,
      ),
    ];
  }
}
