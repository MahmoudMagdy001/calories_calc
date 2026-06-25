import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

const _defaultTapDelay = Duration(milliseconds: 150);
const _defaultDuration = Duration(milliseconds: 400);
const _defaultLongPressDuration = Duration(milliseconds: 700);

class Bounce extends StatefulWidget {
  final void Function()? onTap;
  final void Function(TapUpDetails)? onTapUp;
  final void Function(TapUpDetails)? onSecondaryTapUp;
  final void Function(TapDownDetails)? onLongPress;
  final Duration duration;
  final Duration tapDelay;
  final Duration longPressDuration;
  final HitTestBehavior behavior;
  final Widget child;
  final bool scale;
  final double scaleFactor;
  final bool tilt;
  final double tiltAngle;
  final FilterQuality? filterQuality;
  final MouseCursor? cursor;

  const Bounce({
    required this.child,
    super.key,
    this.onTap,
    this.onTapUp,
    this.onSecondaryTapUp,
    this.onLongPress,
    this.behavior = HitTestBehavior.deferToChild,
    this.duration = _defaultDuration,
    this.tapDelay = _defaultTapDelay,
    this.longPressDuration = _defaultLongPressDuration,
    this.scale = true,
    this.scaleFactor = 0.95,
    this.tilt = true,
    this.tiltAngle = pi / 10,
    this.filterQuality = FilterQuality.high,
    this.cursor,
  });

  @override
  BounceState createState() => BounceState();
}

class BounceState extends State<Bounce> with SingleTickerProviderStateMixin {
  void Function()? get onTap => widget.onTap;
  void Function(TapUpDetails)? get onTapUp => widget.onTapUp;
  void Function(TapDownDetails)? get onLongPress => widget.onLongPress;
  late AnimationController _controller;
  DateTime? _lastTapDownTime;
  DateTime? _lastTapTime;
  Offset? _lastTapLocation;
  Size? lastSize;
  bool isLongPressing = false, isCancelled = false;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
      value: 0,
    );
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => GestureDetector(
    behavior: HitTestBehavior.deferToChild,
    onTapDown: _onTapDown,
    onPanUpdate: _onPointerMove,
    onTapCancel: _onTapCancel,
    onTapUp: _onPointerUp,
    onSecondaryTapUp: (details) => widget.onSecondaryTapUp?.call(details),
    dragStartBehavior: DragStartBehavior.down,
    child: AnimatedBuilder(
      animation: _controller,
      builder: (ctx, child) {
        final transform = Matrix4.identity()..setEntry(3, 2, 0.002);
        if (widget.scale) {
          final scaleVal =
              lerpDouble(1, widget.scaleFactor, _controller.value) ?? 1.0;
          transform.scaleByDouble(scaleVal, scaleVal, 1.0, 1.0);
        }
        if (widget.tilt && _lastTapLocation != null && lastSize != null) {
          double x, y, xAngle, yAngle;
          x = _lastTapLocation!.dx / lastSize!.width;
          y = _lastTapLocation!.dy / lastSize!.height;
          xAngle = (x - 0.5) * (-widget.tiltAngle) * _controller.value;
          yAngle = (y - 0.5) * (widget.tiltAngle) * _controller.value;
          transform
            ..rotateX(yAngle)
            ..rotateY(xAngle);
        }

        return Transform(
          transform: transform,
          origin: Offset(
            (lastSize?.width ?? 0) / 2,
            (lastSize?.height ?? 0) / 2,
          ),
          filterQuality: widget.filterQuality,
          child: child,
        );
      },
      child: WidgetSizeWrapper(
        onSizeChange: (newSize) {
          lastSize = newSize;
        },
        child: MouseRegion(
          cursor: widget.cursor ?? MouseCursor.defer,
          child: widget.child,
        ),
      ),
    ),
  );

  void _onTapDown(TapDownDetails details) {
    isCancelled = false;
    isLongPressing = true;
    _lastTapDownTime = DateTime.now();

    _lastTapLocation = details.localPosition;
    unawaited(_controller.animateTo(1, curve: Curves.easeOutCubic));

    Future.delayed(widget.longPressDuration, () {
      if (mounted && isLongPressing) {
        _onLongPress(details);
      }
    });
  }

  void _onTapCancel() {
    isCancelled = true;
    isLongPressing = false;
    _animateBack();
  }

  void _onPointerMove(DragUpdateDetails details) {
    isLongPressing = false;
    if (isCancelled) return;
    if (details.delta.dx.abs() > 1 || details.delta.dy.abs() > 1) {
      _onTapCancel();
    }
  }

  void _onPointerUp(TapUpDetails details) {
    _animateBack();
    isLongPressing = false;

    if (isCancelled) {
      isCancelled = false;
      return;
    }

    if (_lastTapTime != null) {
      final msSinceLastTap = DateTime.now()
          .difference(_lastTapTime!)
          .inMilliseconds;
      if (msSinceLastTap < widget.tapDelay.inMilliseconds * 2) return;
    }

    _lastTapTime = DateTime.now();

    if (_lastTapTime != null) {
      final msSinceTapDown = DateTime.now()
          .difference(_lastTapDownTime ?? DateTime.now())
          .inMilliseconds;

      if (msSinceTapDown > widget.tapDelay.inMilliseconds) {
        onTap?.call();
        onTapUp?.call(details);
      } else {
        Future.delayed(
          widget.tapDelay - _lastTapTime!.difference(DateTime.now()),
          () {
            onTap?.call();
            onTapUp?.call(details);
          },
        );
      }
    }
  }

  void _onLongPress(TapDownDetails details) {
    if (isCancelled) {
      isCancelled = false;
      return;
    }

    onLongPress?.call(details);
  }

  void _animateBack() {
    unawaited(
      Future<void>.delayed(widget.tapDelay).then((_) {
        if (mounted) {
          unawaited(_controller.animateTo(0, curve: Curves.easeOutCubic));
        }
      }),
    );
  }
}

typedef OnWidgetSizeChange = void Function(Size newSize);

class WidgetSizeRenderObject extends RenderProxyBox {
  final OnWidgetSizeChange onSizeChange;
  Size? currentSize;

  WidgetSizeRenderObject(this.onSizeChange);

  @override
  void performLayout() {
    super.performLayout();

    try {
      final newSize = child?.size;

      if (currentSize != newSize) {
        currentSize = newSize;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          onSizeChange(newSize!);
        });
      }
    } on Object catch (e) {
      if (kDebugMode) {
        debugPrint(e.toString());
      }
    }
  }
}

class WidgetSizeWrapper extends SingleChildRenderObjectWidget {
  final OnWidgetSizeChange onSizeChange;

  const WidgetSizeWrapper({
    required this.onSizeChange,
    required Widget super.child,
    super.key,
  });

  @override
  RenderObject createRenderObject(BuildContext context) =>
      WidgetSizeRenderObject(onSizeChange);
}
