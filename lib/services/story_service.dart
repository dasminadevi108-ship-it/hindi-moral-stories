import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/story_model.dart';

class StoryService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<List<Story>> fetchStories() async {
    try {
      final QuerySnapshot snapshot = await _firestore
          .collection('stories')
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => Story.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error fetching stories: $e');
      rethrow;
    }
  }

  Future<List<Story>> fetchBookmarkedStories() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final bookmarkedIds = prefs.getStringList('bookmarkedStories') ?? [];

      if (bookmarkedIds.isEmpty) return [];

      final stories = <Story>[];
      for (String id in bookmarkedIds) {
        final doc = await _firestore.collection('stories').doc(id).get();
        if (doc.exists) {
          stories.add(Story.fromJson(doc.data() as Map<String, dynamic>));
        }
      }
      return stories;
    } catch (e) {
      print('Error fetching bookmarked stories: $e');
      rethrow;
    }
  }

  Future<void> addBookmark(Story story) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final bookmarkedIds = prefs.getStringList('bookmarkedStories') ?? [];
      
      if (!bookmarkedIds.contains(story.id)) {
        bookmarkedIds.add(story.id);
        await prefs.setStringList('bookmarkedStories', bookmarkedIds);
      }
    } catch (e) {
      print('Error adding bookmark: $e');
      rethrow;
    }
  }

  Future<void> removeBookmark(String storyId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final bookmarkedIds = prefs.getStringList('bookmarkedStories') ?? [];
      bookmarkedIds.remove(storyId);
      await prefs.setStringList('bookmarkedStories', bookmarkedIds);
    } catch (e) {
      print('Error removing bookmark: $e');
      rethrow;
    }
  }

  Future<void> rateStory(String storyId, double rating) async {
    try {
      final user = _auth.currentUser;
      if (user == null) return;

      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('ratings')
          .doc(storyId)
          .set({
        'storyId': storyId,
        'rating': rating,
        'ratedAt': DateTime.now(),
      });
    } catch (e) {
      print('Error rating story: $e');
    }
  }
}
