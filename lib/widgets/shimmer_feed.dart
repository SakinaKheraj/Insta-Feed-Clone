import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerFeed extends StatelessWidget {
  const ShimmerFeed({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[900]!,
      highlightColor: Colors.grey[800]!,
      child: Column(
        children: [
          // Shimmer for Story Tray
          Container(
            height: 110,
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.white24, width: 0.5)),
            ),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 6,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 72,
                        height: 72,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Container(
                        width: 60,
                        height: 10,
                        color: Colors.white,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          
          // Shimmer for Posts
          Expanded(
            child: ListView.builder(
              itemCount: 2, 
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return const ShimmerPostCard();
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ShimmerPostCard extends StatelessWidget {
  const ShimmerPostCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.white),
              ),
              const SizedBox(width: 10),
              Container(width: 120, height: 14, color: Colors.white),
              const Spacer(),
              Container(width: 24, height: 24, color: Colors.white),
            ],
          ),
        ),
        
        // Image
        Container(
          height: 400,
          width: double.infinity,
          color: Colors.white,
        ),
        
        // Actions
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: Row(
            children: [
              Container(width: 28, height: 28, decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.white)),
              const SizedBox(width: 16),
              Container(width: 28, height: 28, decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.white)),
              const SizedBox(width: 16),
              Container(width: 28, height: 28, decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.white)),
              const Spacer(),
              Container(width: 28, height: 28, color: Colors.white), // Save icon
            ],
          ),
        ),
        
        // Texts
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(width: 80, height: 14, color: Colors.white),
              const SizedBox(height: 8),
              Container(width: double.infinity, height: 14, color: Colors.white),
              const SizedBox(height: 4),
              Container(width: 200, height: 14, color: Colors.white),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ],
    );
  }
}
