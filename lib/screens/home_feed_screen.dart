import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PostProvider>().fetchPosts();
    });

    // Setup infinite scroll listener
    _scrollController.addListener(() {
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
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.favorite_border, size: 27),
            tooltip: 'Notifications',
          ),
          Padding(
            padding: const EdgeInsets.only(right: 4),
            child: IconButton(
              onPressed: () {},
              icon: const FaIcon(FontAwesomeIcons.facebookMessenger, size: 24),
              tooltip: 'Messages',
            ),
          ),
        ],
        centerTitle: false,
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.black,
      ),
      body: Consumer<PostProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading && provider.posts.isEmpty) {
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
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.black,
          type: BottomNavigationBarType.fixed,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          elevation: 0,
          items: [
            const BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.house, color: Colors.white, size: 22),
              label: 'Home',
            ),
            const BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.circlePlay, color: Colors.white, size: 22),
              label: 'Reels',
            ),
            const BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.paperPlane, color: Colors.white, size: 22),
              label: 'Message',
            ),
            const BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.magnifyingGlass, color: Colors.white, size: 22),
              label: 'Search',
            ),
            BottomNavigationBarItem(
              icon: Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: CachedNetworkImageProvider(
                      'https://plus.unsplash.com/premium_photo-1701065893190-46f44657fbee?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NjV8fGluc3RhZ3JhbSUyMHByb2ZpbGV8ZW58MHx8MHx8fDA%3D',
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
