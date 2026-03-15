import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:insta_feed_clone/widgets/pinch_zoom_overlay.dart';

class PostCarousel extends StatefulWidget {
  final List<String> imageUrls;

  const PostCarousel({super.key, required this.imageUrls});

  @override
  State<PostCarousel> createState() => _PostCarouselState();
}

class _PostCarouselState extends State<PostCarousel> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.imageUrls.isEmpty) return const SizedBox.shrink();

    if (widget.imageUrls.length == 1) {
      return PinchZoomOverlay(
        imageUrl: widget.imageUrls.first,
        child: AspectRatio(
          aspectRatio: 3 / 4,
          child: CachedNetworkImage(
            imageUrl: widget.imageUrls.first,
            fit: BoxFit.cover,
            errorWidget: (context, url, error) => const Center(child: Icon(Icons.error)),
          ),
        ),
      );
    }

    return Column(
      children: [
        AspectRatio(
          aspectRatio: 3 / 4,
          child: Stack(
            children: [
              PageView.builder(
                controller: _pageController,
                itemCount: widget.imageUrls.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                itemBuilder: (context, index) {
                  return PinchZoomOverlay(
                    imageUrl: widget.imageUrls[index],
                    child: CachedNetworkImage(
                      imageUrl: widget.imageUrls[index],
                      fit: BoxFit.cover,
                      errorWidget: (context, url, error) => const Center(child: Icon(Icons.error)),
                    ),
                  );
                },
              ),
              Positioned(
                top: 15,
                right: 15,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Text(
                    '${_currentIndex + 1}/${widget.imageUrls.length}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Center(
          child: SmoothPageIndicator(
            controller: _pageController,
            count: widget.imageUrls.length,
            effect: const ScrollingDotsEffect(
              activeDotColor: Color(0xFF8134AF),
              dotColor: Colors.grey,
              dotHeight: 5,
              dotWidth: 5,
              spacing: 4,
            ),
          ),
        ),
        const SizedBox(height: 4), 
      ],
    );
  }
}

