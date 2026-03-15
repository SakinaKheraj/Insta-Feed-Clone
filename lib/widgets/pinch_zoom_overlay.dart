import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class PinchZoomOverlay extends StatefulWidget {
  final Widget child;
  final String imageUrl;

  const PinchZoomOverlay({
    super.key,
    required this.child,
    required this.imageUrl,
  });

  @override
  State<PinchZoomOverlay> createState() => _PinchZoomOverlayState();
}

class _PinchZoomOverlayState extends State<PinchZoomOverlay> with SingleTickerProviderStateMixin {
  late TransformationController _transformationController;
  late AnimationController _animationController;
  Animation<Matrix4>? _animation;
  OverlayEntry? _overlayEntry;

  @override
  void initState() {
    super.initState();
    _transformationController = TransformationController();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    )..addListener(() {
        _transformationController.value = _animation!.value;
      });
  }

  @override
  void dispose() {
    _transformationController.dispose();
    _animationController.dispose();
    _removeOverlay();
    super.dispose();
  }

  void _showOverlay(BuildContext context) {
    if (_overlayEntry != null) return;

    final renderBox = context.findRenderObject() as RenderBox;
    final offset = renderBox.localToGlobal(Offset.zero);
    final size = renderBox.size;

    _overlayEntry = OverlayEntry(
      builder: (context) {
        return Positioned(
          left: offset.dx,
          top: offset.dy,
          width: size.width,
          height: size.height,
          child: IgnorePointer(
            child: Container(
              color: Colors.transparent,
              child: InteractiveViewer(
                transformationController: _transformationController,
                panEnabled: false,
                clipBehavior: Clip.none,
                minScale: 1.0,
                maxScale: 4.0,
                onInteractionEnd: (details) {
                  _resetAnimation();
                },
                child: CachedNetworkImage(
                  imageUrl: widget.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        );
      },
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _resetAnimation() {
    _animation = Matrix4Tween(
      begin: _transformationController.value,
      end: Matrix4.identity(),
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    _animationController.forward(from: 0).whenComplete(() {
      _removeOverlay();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        return GestureDetector(
          onScaleStart: (details) {
            _showOverlay(context);
            // Manually feed the initial scale gesture to the TransformationController
            _transformationController.value = Matrix4.identity()
              ..translate(details.focalPoint.dx, details.focalPoint.dy)
              ..scale(1.0)
              ..translate(-details.focalPoint.dx, -details.focalPoint.dy);
          },
          onScaleUpdate: (details) {
            if (_overlayEntry != null) {
              _transformationController.value = Matrix4.identity()
                ..translate(details.focalPoint.dx, details.focalPoint.dy)
                ..scale(details.scale)
                ..translate(-details.focalPoint.dx, -details.focalPoint.dy);
            }
          },
          onScaleEnd: (details) {
            _resetAnimation();
          },
          child: widget.child,
        );
      },
    );
  }
}
