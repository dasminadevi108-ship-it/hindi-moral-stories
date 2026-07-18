import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/story_provider.dart';
import '../widgets/story_card.dart';
import '../widgets/category_chip.dart';
import 'story_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  late List<dynamic> _filteredStories;

  @override
  void initState() {
    super.initState();
    _filteredStories = [];
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final storyProvider = Provider.of<StoryProvider>(context, listen: false);
    _filteredStories = storyProvider.getFilteredStories();
  }

  void _performSearch(String query, BuildContext context) {
    final storyProvider = Provider.of<StoryProvider>(context, listen: false);
    setState(() {
      _filteredStories = query.isEmpty
          ? storyProvider.getFilteredStories()
          : storyProvider.searchStories(query);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hindi Moral Stories'),
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmark),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const BookmarksScreen()),
            ),
          ),
        ],
      ),
      body: Consumer<StoryProvider>(
        builder: (context, storyProvider, _) {
          if (storyProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (storyProvider.error.isNotEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(storyProvider.error),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => storyProvider.loadStories(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search stories...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {});
                      _performSearch(value, context);
                    },
                  ),
                  const SizedBox(height: 24),
                  Text('Categories', style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 12),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: storyProvider.categories
                          .map(
                            (category) => Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: CategoryChip(
                                label: category,
                                isSelected: storyProvider.selectedCategory == category,
                                onTap: () {
                                  storyProvider.setSelectedCategory(category);
                                  setState(() {
                                    _filteredStories = storyProvider.getFilteredStories();
                                  });
                                },
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text('Stories', style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 12),
                  _filteredStories.isEmpty
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.all(32.0),
                            child: Column(
                              children: [
                                const Icon(Icons.no_meetings, size: 64),
                                const SizedBox(height: 16),
                                Text('No stories found',
                                    style: Theme.of(context).textTheme.bodyLarge),
                              ],
                            ),
                          ),
                        )
                      : GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.75,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                          ),
                          itemCount: _filteredStories.length,
                          itemBuilder: (context, index) {
                            final story = _filteredStories[index];
                            return GestureDetector(
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => StoryDetailScreen(story: story),
                                ),
                              ),
                              child: StoryCard(story: story),
                            );
                          },
                        ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}

class BookmarksScreen extends StatelessWidget {
  const BookmarksScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bookmarks')),
      body: Consumer<StoryProvider>(
        builder: (context, storyProvider, _) {
          if (storyProvider.bookmarkedStories.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.bookmark_border, size: 64),
                  const SizedBox(height: 16),
                  Text('No bookmarks yet', style: Theme.of(context).textTheme.bodyLarge),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: storyProvider.bookmarkedStories.length,
            itemBuilder: (context, index) {
              final story = storyProvider.bookmarkedStories[index];
              return Card(
                margin: const EdgeInsets.all(8),
                child: ListTile(
                  leading: Image.network(
                    story.thumbnailUrl,
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                  ),
                  title: Text(story.titleHindi),
                  subtitle: Text(story.category),
                  trailing: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => storyProvider.toggleBookmark(story),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
