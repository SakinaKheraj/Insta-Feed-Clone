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

class _PinchZoomOverlayState extends State<PinchZoomOverlay>
    with SingleTickerProviderStateMixin {
  int _pointerCount = 0;
  bool _zoomActive = false;

  Matrix4 _transform = Matrix4.identity();
  Rect _childRect = Rect.zero;

  late AnimationController _animController;
  Animation<Matrix4>? _resetAnim;

  OverlayEntry? _overlay;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 280),
    )..addListener(_onAnimTick);
  }

  @override
  void dispose() {
    _animController.dispose();
    _removeOverlay();
    super.dispose();
  }

  void _onAnimTick() {
    if (_resetAnim == null) return;
    _transform = _resetAnim!.value;
    _overlay?.markNeedsBuild();
  }

  void _captureChildRect(BuildContext context) {
    final box = context.findRenderObject() as RenderBox?;
    if (box == null) return;
    final offset = box.localToGlobal(Offset.zero);
    _childRect = offset & box.size;
  }

  void _showOverlay(BuildContext context) {
    if (_overlay != null) return;
    _captureChildRect(context);
    _overlay = OverlayEntry(builder: _buildOverlay);
    Overlay.of(context).insert(_overlay!);
  }

  Widget _buildOverlay(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: IgnorePointer(
            child: Builder(builder: (_) {
              final scale = _transform.getMaxScaleOnAxis();
              final opacity = ((scale - 1.0) / 2.5).clamp(0.0, 0.65);
              return ColoredBox(color: Colors.black.withOpacity(opacity));
            }),
          ),
        ),

        Positioned(
          left: _childRect.left,
          top: _childRect.top,
          width: _childRect.width,
          height: _childRect.height,
          child: IgnorePointer(
            child: Transform(
              transform: _transform,
              child: CachedNetworkImage(
                imageUrl: widget.imageUrl,
                fit: BoxFit.cover,
                width: _childRect.width,
                height: _childRect.height,
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _removeOverlay() {
    _overlay?.remove();
    _overlay = null;
  }

  void _animateReset() {
    _resetAnim = Matrix4Tween(
      begin: _transform,
      end: Matrix4.identity(),
    ).animate(CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOutCubic,
    ));

    _animController.forward(from: 0).whenComplete(() {
      _removeOverlay();
      _transform = Matrix4.identity();
      _zoomActive = false;
    });
  }


  void _onScaleStart(ScaleStartDetails details, BuildContext ctx) {
    if (_pointerCount < 2) return; 
    _animController.stop();
    _resetAnim = null;
    _transform = Matrix4.identity();
    _zoomActive = true;
    _showOverlay(ctx);
  }

  void _onScaleUpdate(ScaleUpdateDetails details) {
    if (!_zoomActive) return;
    if (details.scale == 1.0 && _pointerCount < 2) return;

    final focalX = details.focalPoint.dx - _childRect.left;
    final focalY = details.focalPoint.dy - _childRect.top;

    _transform = Matrix4.identity()
      ..translate(focalX, focalY)
      ..scale(details.scale.clamp(1.0, 5.0))
      ..translate(-focalX, -focalY);

    _overlay?.markNeedsBuild();
  }

  void _onScaleEnd(ScaleEndDetails details) {
    if (!_zoomActive) return;
    _animateReset();
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (_) => _pointerCount++,
      onPointerUp: (_) {
        _pointerCount = (_pointerCount - 1).clamp(0, 10);
      },
      onPointerCancel: (_) {
        _pointerCount = (_pointerCount - 1).clamp(0, 10);
      },
      child: Builder(
        builder: (ctx) => GestureDetector(
          onScaleStart: (d) => _onScaleStart(d, ctx),
          onScaleUpdate: _onScaleUpdate,
          onScaleEnd: _onScaleEnd,
          child: widget.child,
        ),
      ),
    );
  }
}
