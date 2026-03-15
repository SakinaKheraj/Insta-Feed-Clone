import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:insta_feed_clone/widgets/story_tray.dart';
import 'package:insta_feed_clone/widgets/post_card.dart';
import 'package:insta_feed_clone/widgets/shimmer_feed.dart';
import 'package:insta_feed_clone/providers/post_provider.dart';

class HomeFeedScreen extends StatefulWidget {
  const HomeFeedScreen({super.key});

  @override
  State<HomeFeedScreen> createState() => _HomeFeedScreenState();
}

class _HomeFeedScreenState extends State<HomeFeedScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Fetch initial posts on load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PostProvider>().fetchPosts();
    });

    // Setup infinite scroll listener
    _scrollController.addListener(() {
      // Trigger when user is close to the bottom (e.g., 2 posts away approx 800px)
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 800) {
        final provider = context.read<PostProvider>();
        if (!provider.isFetchingMore && provider.hasMore) {
          provider.fetchMorePosts();
        }
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Instagram",
          style: GoogleFonts.grandHotel(
            fontSize: 34,
            fontWeight: FontWeight.w500,
          ),
        ),
        leading: IconButton(onPressed: () {}, icon: const Icon(Icons.add, size: 28)),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.favorite_border, size: 28),
          ),
        ],
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.black,
      ),
      body: Consumer<PostProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading && provider.posts.isEmpty) {
            // Highly preferred Shimmer effect for initial loading
            return const ShimmerFeed();
          }
          
          return ListView.builder(
            controller: _scrollController,
            itemCount: provider.posts.length + 2, 
            itemBuilder: (context, index) {
              if (index == 0) {
                return const StoryTray();
              }
              
              if (index == provider.posts.length + 1) {
                if (provider.isFetchingMore) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20.0),
                    child: Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    ),
                  );
                } else if (!provider.hasMore) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 30.0),
                    child: Center(
                      child: Text(
                        "You've caught up!",
                        style: TextStyle(color: Colors.grey[500]),
                      ),
                    ),
                  );
                }
                return const SizedBox.shrink();
              }

              final post = provider.posts[index - 1];
              return PostCard(post: post);
            },
          );
        },
      ),
    );
  }
}
