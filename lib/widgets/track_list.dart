import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'now_playing_bar.dart';

class TrackList extends StatefulWidget {
  final List<dynamic> tracks;

  const TrackList({super.key, required this.tracks});

  @override
  State<TrackList> createState() => _TrackListState();
}

class _TrackListState extends State<TrackList> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  String? _currentUrl;
  bool _isPlaying = false;
  Map<String, dynamic>? _nowPlayingTrack;
  int _currentIndex = -1; // ตำแหน่งเพลงที่กำลังเล่น

  void _togglePlay(String url, Map<String, dynamic> track, int index) async {
    if (_currentUrl == url && _isPlaying) {
      await _audioPlayer.pause();
      setState(() {
        _isPlaying = false;
      });
    } else {
      await _audioPlayer.stop();
      await _audioPlayer.play(UrlSource(url));
      setState(() {
        _currentUrl = url;
        _isPlaying = true;
        _nowPlayingTrack = track;
        _currentIndex = index;
      });
    }
  }

  void _playPreviousTrack() {
    if (_currentIndex > 0) {
      final previousTrack = widget.tracks[_currentIndex - 1];
      _togglePlay(previousTrack['preview'], previousTrack, _currentIndex - 1);
    }
  }

  void _playNextTrack() {
    if (_currentIndex < widget.tracks.length - 1) {
      final nextTrack = widget.tracks[_currentIndex + 1];
      _togglePlay(nextTrack['preview'], nextTrack, _currentIndex + 1);
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Builder(
            builder: (context) {
              final playableTracks = widget.tracks.where((track) {
                final previewUrl = track['preview'];
                return previewUrl != null && previewUrl.toString().trim().isNotEmpty;
              }).toList();

              return ListView.builder(
                itemCount: playableTracks.length,
                itemBuilder: (context, index) {
                  final track = playableTracks[index];
                  final title = track['title'];
                  final artist = track['artist']['name'];
                  final imageUrl = track['album']['cover_medium'];
                  final previewUrl = track['preview'];

                  final isThisTrackPlaying = _currentUrl == previewUrl && _isPlaying;

                  return ListTile(
                    leading: Image.network(imageUrl, width: 50, height: 50, fit: BoxFit.cover),
                    title: Text(title, style: const TextStyle(color: Colors.black)),
                    subtitle: Text(artist, style: const TextStyle(color: Colors.black54)),
                    trailing: IconButton(
                      icon: Icon(
                        isThisTrackPlaying ? Icons.pause : Icons.play_arrow,
                        color: Colors.black,
                      ),
                      onPressed: () => _togglePlay(previewUrl, track, index),
                    ),
                  );
                },
              );
            },
          ),
        ),
        if (_nowPlayingTrack != null)
          NowPlayingBar(
            title: _nowPlayingTrack!['title'],
            artist: _nowPlayingTrack!['artist']['name'],
            imageUrl: _nowPlayingTrack!['album']['cover_medium'],
            isPlaying: _isPlaying,
            onToggle: () => _togglePlay(
              _nowPlayingTrack!['preview'],
              _nowPlayingTrack!,
              _currentIndex,
            ),
            onPrevious: _playPreviousTrack,
            onNext: _playNextTrack,
          ),
      ],
    );
  }
}