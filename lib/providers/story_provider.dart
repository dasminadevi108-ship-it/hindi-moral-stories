import 'package:flutter/material.dart';
import '../models/story_model.dart';
import '../services/story_service.dart';

class StoryProvider extends ChangeNotifier {
  final StoryService _storyService = StoryService();

  List<Story> _stories = [];
  List<Story> _bookmarkedStories = [];
  bool _isLoading = false;
  String _error = '';
  String _selectedCategory = 'All';

  List<Story> get stories => _stories;
  List<Story> get bookmarkedStories => _bookmarkedStories;
  bool get isLoading => _isLoading;
  String get error => _error;
  String get selectedCategory => _selectedCategory;
  List<String> get categories => ['All', 'Kindness', 'Courage', 'Wisdom', 'Honesty'];

  StoryProvider() {
    loadStories();
  }

  Future<void> loadStories() async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      _stories = await _storyService.fetchStories();
      _bookmarkedStories = await _storyService.fetchBookmarkedStories();
    } catch (e) {
      _error = 'Failed to load stories: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> toggleBookmark(Story story) async {
    story.isBookmarked = !story.isBookmarked;
    
    if (story.isBookmarked) {
      _bookmarkedStories.add(story);
      await _storyService.addBookmark(story);
    } else {
      _bookmarkedStories.removeWhere((s) => s.id == story.id);
      await _storyService.removeBookmark(story.id);
    }
    notifyListeners();
  }

  Future<void> rateStory(Story story, double rating) async {
    story.userRating = rating;
    await _storyService.rateStory(story.id, rating);
    notifyListeners();
  }

  void setSelectedCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  List<Story> getFilteredStories() {
    if (_selectedCategory == 'All') return _stories;
    return _stories.where((story) => story.category == _selectedCategory).toList();
  }

  List<Story> searchStories(String query) {
    if (query.isEmpty) return _stories;
    return _stories
        .where((story) =>
            story.titleHindi.toLowerCase().contains(query.toLowerCase()) ||
            story.titleEnglish.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }
}
