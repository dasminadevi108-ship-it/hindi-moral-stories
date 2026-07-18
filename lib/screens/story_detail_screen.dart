import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import '../models/story_model.dart';
import '../providers/story_provider.dart';

class StoryDetailScreen extends StatefulWidget {
  final Story story;

  const StoryDetailScreen({Key? key, required this.story}) : super(key: key);

  @override
  State<StoryDetailScreen> createState() => _StoryDetailScreenState();
}

class _StoryDetailScreenState extends State<StoryDetailScreen> {
  late VideoPlayerController _videoController;
  bool _isVideoInitialized = false;
  double _userRating = 0;

  @override
  void initState() {
    super.initState();
    _userRating = widget.story.userRating;
    _initializeVideo();
  }

  void _initializeVideo() {
    _videoController = VideoPlayerController.network(widget.story.videoUrl)
      ..initialize().then((_) {
        setState(() {
          _isVideoInitialized = true;
        });
      });
  }

  @override
  void dispose() {
    _videoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final storyProvider = Provider.of<StoryProvider>(context);
    final isBookmarked = widget.story.isBookmarked;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Story'),
        actions: [
          IconButton(
            icon: Icon(
              isBookmarked ? Icons.bookmark : Icons.bookmark_border,
              color: isBookmarked ? Colors.red : null,
            ),
            onPressed: () {
              storyProvider.toggleBookmark(widget.story);
              setState(() {});
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_isVideoInitialized)
              AspectRatio(
                aspectRatio: _videoController.value.aspectRatio,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    VideoPlayer(_videoController),
                    FloatingActionButton(
                      onPressed: () {
                        setState(() {
                          _videoController.value.isPlaying
                              ? _videoController.pause()
                              : _videoController.play();
                        });
                      },
                      child: Icon(
                        _videoController.value.isPlaying
                            ? Icons.pause
                            : Icons.play_arrow,
                      ),
                    ),
                  ],
                ),
              )
            else
              Container(
                height: 200,
                color: Colors.grey[300],
                child: const Center(child: CircularProgressIndicator()),
              ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.story.titleHindi, style: Theme.of(context).textTheme.headlineSmall),
                  const SizedBox(height: 8),
                  Text(widget.story.titleEnglish, style: Theme.of(context).textTheme.bodyMedium),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Icon(Icons.category),
                      const SizedBox(width: 8),
                      Text(widget.story.category),
                      const SizedBox(width: 24),
                      const Icon(Icons.access_time),
                      const SizedBox(width: 8),
                      Text('${widget.story.duration ~/ 60} min'),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber),
                      const SizedBox(width: 8),
                      Text('${widget.story.rating.toStringAsFixed(1)} (${widget.story.reviews} reviews)'),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text('Description', style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 8),
                  Text(widget.story.descriptionHindi, style: Theme.of(context).textTheme.bodyLarge),
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.blue.withOpacity(0.3)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Moral', style: Theme.of(context).textTheme.titleMedium),
                        const SizedBox(height: 8),
                        Text(widget.story.moralHindi, style: Theme.of(context).textTheme.bodyMedium),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text('Rate this story', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 12),
                  Row(
                    children: List.generate(
                      5,
                      (index) => IconButton(
                        icon: Icon(
                          index < _userRating ? Icons.star : Icons.star_border,
                          color: Colors.amber,
                        ),
                        onPressed: () {
                          setState(() {
                            _userRating = (index + 1).toDouble();
                          });
                          storyProvider.rateStory(widget.story, _userRating);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Rating saved!'), duration: Duration(seconds: 1)),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
