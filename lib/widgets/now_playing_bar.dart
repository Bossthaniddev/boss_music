import 'package:flutter/material.dart';

class NowPlayingBar extends StatelessWidget {
  final String title;
  final String artist;
  final String imageUrl;
  final bool isPlaying;
  final VoidCallback onToggle;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  const NowPlayingBar({
    super.key,
    required this.title,
    required this.artist,
    required this.imageUrl,
    required this.isPlaying,
    required this.onToggle,
    required this.onPrevious,
    required this.onNext,

  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black87,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          Image.network(imageUrl, width: 40, height: 40, fit: BoxFit.cover),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  artist,
                  style: const TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.skip_previous, color: Colors.white),
            onPressed: onPrevious,
          ),
          IconButton(
            icon: Icon(
              isPlaying ? Icons.pause : Icons.play_arrow,
              color: Colors.white,
            ),
            onPressed: onToggle, 
          ),
          IconButton(
            icon: const Icon(Icons.skip_next, color: Colors.white),
            onPressed: onNext,
          ),
        ],
      ),
    );
  }
}