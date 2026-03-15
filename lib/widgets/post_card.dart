import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:insta_feed_clone/models/post_model.dart';
import 'package:insta_feed_clone/providers/post_provider.dart';
import 'package:insta_feed_clone/widgets/post_carousel.dart';

class PostCard extends StatelessWidget {
  final PostModel post;

  const PostCard({super.key, required this.post});

  void _showUnimplementedSnackbar(BuildContext context, String action) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$action is not implemented in this demo.'),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Determine if user has a "story" by checking if their ID is in a mock list
    // In a real app this would come from the post or user model
    final hasStory = ['2', '3', '4', '6'].contains(post.id);
    
    // Determine if we show a follow button (only for some users in feed usually)
    final showFollowBtn = !['natgeo', 'tech_reviews'].contains(post.username);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            children: [
              // Avatar with optional story ring
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: hasStory
                      ? const LinearGradient(
                          colors: [
                            Color(0xFFF58529),
                            Color(0xFFFEDA77),
                            Color(0xFFDD2A7B),
                            Color(0xFF8134AF),
                            Color(0xFF515BD4),
                          ],
                          begin: Alignment.bottomLeft,
                          end: Alignment.topRight,
                        )
                      : null,
                ),
                child: Padding(
                  padding: EdgeInsets.all(hasStory ? 2.5 : 0),
                  child: Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.black, // Dark theme background
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: CircleAvatar(
                        radius: 16,
                        backgroundImage: CachedNetworkImageProvider(post.userAvatar),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              
              // Username, Verified Badge, and Follow Button
              Expanded(
                child: Row(
                  children: [
                    Text(
                      post.username,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                    if (post.isVerified) ...[
                      const SizedBox(width: 4),
                      const Icon(Icons.verified, color: Colors.blue, size: 14),
                    ],
                    if (showFollowBtn) ...[
                      const SizedBox(width: 8),
                      // Divider bullet
                      const Text('•', style: TextStyle(color: Colors.grey, fontSize: 14)),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: () => _showUnimplementedSnackbar(context, 'Follow'),
                        child: const Text(
                          'Follow',
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              
              // Options Icon
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: const Icon(Icons.more_horiz, color: Colors.white), // iOS style uses horiz for posts often, or vert
                onPressed: () => _showUnimplementedSnackbar(context, 'Options'),
              )
            ],
          ),
        ),

        // Media Content (AspectRatio 3:4 -> width:height = 3:4 -> 0.75)
        // Note: 1080x1440 is 3:4 aspect ratio.
        AspectRatio(
          aspectRatio: 3 / 4,
          child: PostCarousel(imageUrls: post.imageUrls),
        ),

        // Action Bar - Updated to show stats next to icons
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: Row(
            children: [
              // Like
              InkWell(
                onTap: () {
                  context.read<PostProvider>().toggleLike(post.id);
                },
                child: Row(
                  children: [
                    Icon(
                      post.isLiked ? Icons.favorite : Icons.favorite_border,
                      color: post.isLiked ? Colors.red : Colors.white,
                      size: 26,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '${post.likes}',
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 18),
              
              // Comment
              InkWell(
                onTap: () => _showUnimplementedSnackbar(context, 'Comment'),
                child: Row(
                  children: [
                    const FaIcon(FontAwesomeIcons.comment, color: Colors.white, size: 24),
                    const SizedBox(width: 6),
                    Text(
                      '${post.comments}',
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 18),
              
              // Reshare (Assuming static count or logic for demo)
              InkWell(
                onTap: () => _showUnimplementedSnackbar(context, 'Reshare'),
                child: Row(
                  children: [
                    const FaIcon(FontAwesomeIcons.arrowsSpin, color: Colors.white, size: 24),
                    const SizedBox(width: 6),
                    const Text(
                      '12', // Mock reshare count for UI
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 18),
              
              // Share
              InkWell(
                onTap: () => _showUnimplementedSnackbar(context, 'Share'),
                child: const FaIcon(FontAwesomeIcons.paperPlane, color: Colors.white, size: 24),
              ),
              
              const Spacer(),
              
              // Save
              InkWell(
                onTap: () {
                  context.read<PostProvider>().toggleSave(post.id);
                },
                child: Icon(
                  post.isSaved ? Icons.bookmark : Icons.bookmark_border,
                  color: Colors.white,
                  size: 26,
                ),
              ),
            ],
          ),
        ),

        // Caption
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (post.caption.isNotEmpty) ...[
                RichText(
                  text: TextSpan(
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                    children: [
                      TextSpan(
                        text: '${post.username} ',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(text: post.caption),
                    ],
                  ),
                ),
                const SizedBox(height: 6),
              ],
              
              // Comments link (optional now that stats are inline, but still common in some views)
              if (post.comments > 0)
                GestureDetector(
                  onTap: () => _showUnimplementedSnackbar(context, 'View Comments'),
                  child: Text(
                    'View all ${post.comments} comments',
                    style: const TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                ),
              const SizedBox(height: 16), // Bottom spacing before next post
            ],
          ),
        ),
      ],
    );
  }
}
