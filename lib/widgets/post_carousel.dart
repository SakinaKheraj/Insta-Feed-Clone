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

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.imageUrls.isEmpty) return const SizedBox.shrink();

    // Single image vs Carousel
    if (widget.imageUrls.length == 1) {
      return PinchZoomOverlay(
        imageUrl: widget.imageUrls.first,
        child: SizedBox(
          height: 400,
          width: double.infinity,
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
        SizedBox(
          height: 400,
          width: double.infinity,
          child: PageView.builder(
            controller: _pageController,
            itemCount: widget.imageUrls.length,
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
        ),
        const SizedBox(height: 12),
        // Dots indicator positioned directly under the image (Instagram style)
        Center(
          child: SmoothPageIndicator(
            controller: _pageController,
            count: widget.imageUrls.length,
            effect: const ScrollingDotsEffect(
              activeDotColor: Colors.blue,
              dotColor: Colors.grey,
              dotHeight: 6,
              dotWidth: 6,
              spacing: 4,
            ),
          ),
        ),
        // Adjust the bottom spacing since the indicator takes some space
        const SizedBox(height: 4), 
      ],
    );
  }
}
