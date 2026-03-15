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
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            '$action is not available in this demo.',
            style: const TextStyle(color: Colors.white),
          ),
          duration: const Duration(seconds: 3),
          behavior: SnackBarBehavior.floating,
          backgroundColor: const Color(0xFF262626),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          action: SnackBarAction(
            label: 'OK',
            textColor: Colors.white70,
            onPressed: () {},
          ),
        ),
      );
  }

  static const List<Map<String, String>> mockLikers = [
    {'name': 'aliya__5900', 'avatar': 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?auto=format&fit=crop&w=150&q=80'},
    {'name': 'david_c', 'avatar': 'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?auto=format&fit=crop&w=150&q=80'},
    {'name': 'sarah.smiles', 'avatar': 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=150&q=80'},
    {'name': 'mike_jones', 'avatar': 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&w=150&q=80'},
  ];

  String _formatNumber(int number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M'.replaceAll('.0M', 'M');
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K'.replaceAll('.0K', 'K');
    }
    return number.toString();
  }

  String _timeAgo(DateTime timestamp) {
    final now = DateTime.now();
    final diff = now.difference(timestamp);
    if (diff.inSeconds < 60) return 'just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays == 1) return 'Yesterday';
    if (diff.inDays < 7) return '${diff.inDays} days ago';
    if (diff.inDays < 30) return '${(diff.inDays / 7).floor()}w ago';
    if (diff.inDays < 365) return '${(diff.inDays / 30).floor()}mo ago';
    return '${(diff.inDays / 365).floor()}y ago';
  }

  @override
  Widget build(BuildContext context) {
    final hasStory = ['2', '3', '4', '6'].contains(post.id);
    
    final showFollowBtn = !['natgeo', 'tech_reviews'].contains(post.username);

    final mockLiker = mockLikers[post.id.hashCode.abs() % mockLikers.length];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: hasStory
                      ? const LinearGradient(
                          colors: [
                            Color.fromARGB(255, 221, 106, 13),
                            Color.fromARGB(255, 233, 201, 44),
                            Color.fromARGB(255, 245, 61, 144),
                            Color.fromARGB(255, 244, 37, 220),
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
                      color: Colors.black, 
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: CircleAvatar(
                        radius: 17,
                        backgroundImage: CachedNetworkImageProvider(post.userAvatar),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
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
                      ],
                    ),
                    if (showFollowBtn) 
                      const Text(
                        "Suggested for you",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                  ],
                ),
              ),
              
              if (showFollowBtn) ...[
                GestureDetector(
                  onTap: () => _showUnimplementedSnackbar(context, 'Follow'),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 56, 56, 56), // Dark gray pills
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text(
                      'Follow',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
              ],
              
              // Options Icon
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: const Icon(Icons.more_vert, color: Colors.white, size: 20),
                onPressed: () => _showUnimplementedSnackbar(context, 'Options'),
              )
            ],
          ),
        ),

        PostCarousel(imageUrls: post.imageUrls),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: Row(
            children: [
              // Like
              GestureDetector(
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
                    const SizedBox(width: 4),
                    Text(
                      _formatNumber(post.likes),
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              
              // Comment
              GestureDetector(
                onTap: () => _showUnimplementedSnackbar(context, 'Comment'),
                child: Row(
                  children: [
                    const FaIcon(FontAwesomeIcons.comment, color: Colors.white, size: 24),
                    const SizedBox(width: 4),
                    Text(
                      _formatNumber(post.comments),
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              
              // Reshare
              GestureDetector(
                onTap: () => _showUnimplementedSnackbar(context, 'Reshare'),
                child: Row(
                  children: [
                    const FaIcon(FontAwesomeIcons.arrowsSpin, color: Colors.white, size: 24),
                    const SizedBox(width: 4),
                    Text(
                      _formatNumber(post.reshares),
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              
              // Share
              GestureDetector(
                onTap: () => _showUnimplementedSnackbar(context, 'Share'),
                child: Row(
                  children: [
                    const FaIcon(FontAwesomeIcons.paperPlane, color: Colors.white, size: 24),
                    const SizedBox(width: 4),
                    Text(
                      _formatNumber(post.shares),
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                  ],
                ),
              ),
              
              const Spacer(),
              
              // Save / Bookmark
              GestureDetector(
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

        // "Liked by" section
        if (post.likes > 0)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: CachedNetworkImageProvider(mockLiker['avatar']!),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                RichText(
                  text: TextSpan(
                    style: const TextStyle(color: Colors.white, fontSize: 13),
                    children: [
                      const TextSpan(text: 'Liked by '),
                      TextSpan(text: mockLiker['name']!, style: const TextStyle(fontWeight: FontWeight.bold)),
                      if (post.likes > 1) ...[
                        const TextSpan(text: ' and '),
                        const TextSpan(text: 'others', style: TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        const SizedBox(height: 8),

        // Caption
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (post.caption.isNotEmpty) ...[
                RichText(
                  text: TextSpan(
                    style: const TextStyle(color: Colors.white, fontSize: 13),
                    children: [
                      TextSpan(
                        text: '${post.username} ',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(text: post.caption),
                      const TextSpan(
                        text: '... more',
                        style: TextStyle(color: Colors.grey),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 6),
              ],
              
              Text(
                _timeAgo(post.timestamp),
                style: const TextStyle(color: Colors.grey, fontSize: 11),
              ),
              
              const SizedBox(height: 16),
            ],
          ),
        ),
      ],
    );
  }
}
