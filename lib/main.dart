import 'package:flutter/material.dart';
import 'services/deezer_service.dart';
import 'widgets/track_list.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Deezer Playlist',
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFFB388EB),
          foregroundColor: Colors.white,
          elevation: 0,
          title: Row(
            children: [
              Image.asset(
                'assets/icon/logo-boss-thanid.png',
                height: 45,
              ),
              const SizedBox(width: 8),
              const Text('Boss Music Playlist'),
            ],
          ),
        ),
        body: const PlaylistScreen(),
      ),
    );
  }
}

class PlaylistScreen extends StatefulWidget {
  const PlaylistScreen({super.key});

  @override
  State<PlaylistScreen> createState() => _PlaylistScreenState();
}

class _PlaylistScreenState extends State<PlaylistScreen> {
  final DeezerService _deezerService = DeezerService();
  late Future<List<dynamic>> _tracksFuture;

  final Map<String, String> genrePlaylists = {
    'Funk': '5505174422',
    'Pop': '1362524475',
    'Rock': '945089123',
    'Blues': '1767932902',
    'Hip-Hop': '1111141961',
    'Reggaeton': '1273315391',
    'Electronic': '1315941615',
    'Sertanejo': '5207214368',
    'Indie': '11098926444',
  };

  String _selectedGenre = 'Funk';

  @override
  void initState() {
    super.initState();
    _tracksFuture = _deezerService.fetchTracks(genrePlaylists[_selectedGenre]!);
  }

  void _updatePlaylist(String genre) {
    setState(() {
      _selectedGenre = genre;
      _tracksFuture = _deezerService.fetchTracks(genrePlaylists[genre]!);
    });
  }

  Widget _buildGenreSlider() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: genrePlaylists.keys.map((genre) {
            final bool isSelected = genre == _selectedGenre;
            return GestureDetector(
              onTap: () => _updatePlaylist(genre),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 8.0),
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.deepPurpleAccent : Colors.grey[200],
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected ? Colors.deepPurple : Colors.grey,
                    width: 2,
                  ),
                  boxShadow: isSelected
                      ? [BoxShadow(color: Colors.deepPurple.withOpacity(0.3), blurRadius: 6, offset: Offset(0, 3))]
                      : [],
                ),
                child: Text(
                  genre,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.black87,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildGenreSlider(),

        // แสดงรายการเพลง
        Expanded(
          child: FutureBuilder<List<dynamic>>(
            future: _tracksFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else {
                return TrackList(tracks: snapshot.data!);
              }
            },
          ),
        ),
      ],
    );
  }
}