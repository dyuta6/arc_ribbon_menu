// ignore_for_file: deprecated_member_use

import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'arc_sector_clipper.dart';

class ArcRibbonMenu<T> extends StatefulWidget {
  final List<T> items;
  final int initialIndex;
  final Widget Function(BuildContext context, T item, int index)? imageBuilder;
  final Widget Function(BuildContext context, T item, int index)?
      detailsBuilder;
  final void Function(T item, int index)? onItemTap;
  final void Function(T item, int index)? onSelectionChanged;

  /// Base height of individual ribbon item sector.
  final double? baseHeight;

  /// Width of the ribbon.
  final double? nominalWidth;

  /// X coordinate of the circle center relative to the widget layout.
  final double? cx;

  /// Y coordinate of the circle center relative to the widget layout.
  final double? cy;

  /// Radius of the circle.
  final double? R;

  /// Theme color used for action button and details separator.
  final Color themeColor;

  const ArcRibbonMenu({
    super.key,
    required this.items,
    this.initialIndex = 0,
    this.imageBuilder,
    this.detailsBuilder,
    this.onItemTap,
    this.onSelectionChanged,
    this.baseHeight,
    this.nominalWidth,
    this.cx,
    this.cy,
    this.R,
    this.themeColor = const Color(0xFF2A001A),
  });

  @override
  State<ArcRibbonMenu<T>> createState() => _ArcRibbonMenuState<T>();
}

class _ArcRibbonMenuState<T> extends State<ArcRibbonMenu<T>> {
  ScrollController? _scroll;
  int? _lastSelectedIndex;

  static const List<Color> _defaultColors = [
    Color(0xFFF44336), // Red
    Color(0xFFE91E63), // Pink
    Color(0xFF9C27B0), // Purple
    Color(0xFF673AB7), // Deep Purple
    Color(0xFF3F51B5), // Indigo
    Color(0xFF2196F3), // Blue
    Color(0xFF03A9F4), // Light Blue
    Color(0xFF00BCD4), // Cyan
    Color(0xFF009688), // Teal
    Color(0xFF4CAF50), // Green
    Color(0xFF8BC34A), // Light Green
    Color(0xFFCDDC39), // Lime
    Color(0xFFFFEB3B), // Yellow
    Color(0xFFFFC107), // Amber
    Color(0xFFFF9800), // Orange
    Color(0xFFFF5722), // Deep Orange
  ];

  @override
  void initState() {
    super.initState();
    _lastSelectedIndex = widget.initialIndex;
  }

  @override
  void dispose() {
    _scroll?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.items.isEmpty) {
      return const SizedBox.shrink();
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;
        final h = constraints.maxHeight;

        final baseHeight = widget.baseHeight ?? math.min(h * 0.25, 120.0);
        final nominalWidth = widget.nominalWidth ?? (baseHeight * 1.15);

        if (_scroll == null) {
          final initialOffset = widget.initialIndex * baseHeight;
          _scroll = ScrollController(initialScrollOffset: initialOffset)
            ..addListener(_onScrollUpdate);
        }

        final cx = widget.cx ?? (-w * 0.90);
        final cy = widget.cy ?? (h * 0.50);
        final R = widget.R ?? (w * 1.20);

        final dTheta = baseHeight / R;
        final scroll = _scroll!.hasClients
            ? _scroll!.offset
            : (widget.initialIndex * baseHeight);
        final thetaScroll = -scroll / R;

        const thetaStart = 0.0;
        final scrollPixels =
            math.max(0.0, (widget.items.length - 1) * baseHeight) + h;

        final rawIndex = (-thetaStart - thetaScroll) / dTheta;
        final centerIndex = rawIndex.round().clamp(0, widget.items.length - 1);
        final selectedTheta = thetaStart + centerIndex * dTheta + thetaScroll;
        final selectedY = cy + R * math.sin(selectedTheta);

        final rIn = R - nominalWidth / 2;
        final rOut = R + nominalWidth / 2;

        final leftBulge = rIn * (1 - math.cos(dTheta / 2));
        final boxWidth = nominalWidth + leftBulge;
        final boxHeight = 2 * rOut * math.sin(dTheta / 2);

        final logicalCenterX = leftBulge + nominalWidth / 2;
        final logicalCenterY = boxHeight / 2;

        return Stack(
          clipBehavior: Clip.none,
          children: [
            // Rotated items List
            ...List.generate(widget.items.length, (i) {
              final theta = thetaStart + i * dTheta + thetaScroll;
              final x = cx + R * math.cos(theta);
              final y = cy + R * math.sin(theta);

              final opacity = (1.0 - theta.abs() * 1.5).clamp(0.3, 1.0);

              final clipper = ArcSectorClipper(
                rIn: rIn,
                rOut: rOut,
                dTheta: dTheta,
                cxLocal: logicalCenterX - R,
                cyLocal: logicalCenterY,
              );

              return Positioned(
                left: x - logicalCenterX,
                top: y - logicalCenterY,
                child: IgnorePointer(
                  child: Opacity(
                    opacity: opacity,
                    child: Transform.rotate(
                      origin: Offset(leftBulge / 2, 0),
                      angle: theta,
                      child: SizedBox(
                        width: boxWidth,
                        height: boxHeight,
                        child: ClipPath(
                          clipper: clipper,
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              widget.imageBuilder != null
                                  ? widget.imageBuilder!(
                                      context, widget.items[i], i)
                                  : Container(
                                      color: _defaultColors[
                                          i % _defaultColors.length],
                                      child: Center(
                                        child: Text(
                                          '${i + 1}',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                    ),
                              DecoratedBox(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.black.withOpacity(0.7),
                                      Colors.transparent,
                                      Colors.transparent,
                                      Colors.black.withOpacity(0.7),
                                    ],
                                    stops: const [0.0, 0.25, 0.75, 1.0],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }),

            // Selected item details card on the right
            Positioned(
              left: w * 0.50,
              top: selectedY - 50.0, // Fixed safe height offset helper
              right: 8.0,
              child: SizedBox(
                height: 100.0,
                child: Row(
                  children: [
                    Container(
                      width: 3,
                      height: 55.0,
                      color: widget.themeColor.withOpacity(0.95),
                    ),
                    const SizedBox(width: 10.0),
                    Expanded(
                      child: widget.detailsBuilder != null
                          ? widget.detailsBuilder!(
                              context, widget.items[centerIndex], centerIndex)
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  widget.items[centerIndex].toString(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 12.0),
                      child: GestureDetector(
                        onTap: () {
                          if (widget.onItemTap != null) {
                            widget.onItemTap!(
                                widget.items[centerIndex], centerIndex);
                          }
                        },
                        child: Container(
                          width: 40.0,
                          height: 40.0,
                          decoration: BoxDecoration(
                            color: widget.themeColor.withOpacity(0.95),
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: widget.themeColor.withOpacity(0.95),
                                blurRadius: 8,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.arrow_forward_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Scroll Overlay mapping drag gestures
            Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              width: w * 0.50,
              child: ListView.builder(
                controller: _scroll!,
                physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics(),
                ),
                padding: EdgeInsets.zero,
                itemExtent: 3,
                itemCount: math.max(1, (scrollPixels / 3).ceil()),
                itemBuilder: (_, __) => const SizedBox(height: 3),
              ),
            ),
          ],
        );
      },
    );
  }

  void _onScrollUpdate() {
    setState(() {});
    if (widget.onSelectionChanged != null) {
      final baseHeight = widget.baseHeight ??
          math.min(MediaQuery.of(context).size.height * 0.25, 120.0);
      final R = widget.R ?? (MediaQuery.of(context).size.width * 1.20);
      final dTheta = baseHeight / R;
      final scroll = _scroll!.offset;
      final thetaScroll = -scroll / R;
      const thetaStart = 0.0;
      final rawIndex = (-thetaStart - thetaScroll) / dTheta;
      final centerIndex = rawIndex.round().clamp(0, widget.items.length - 1);

      if (_lastSelectedIndex != centerIndex) {
        _lastSelectedIndex = centerIndex;
        widget.onSelectionChanged!(widget.items[centerIndex], centerIndex);
      }
    }
  }
}
