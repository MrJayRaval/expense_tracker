import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CachedSvgIcon extends StatefulWidget {
  final String iconPath;
  final double height;
  final Color? color;

  const CachedSvgIcon({
    super.key,
    required this.iconPath,
    required this.height,
    this.color,
  });

  @override
  State<CachedSvgIcon> createState() => _CachedSvgIconState();
}

class _CachedSvgIconState extends State<CachedSvgIcon> {
  static final Map<String, Widget> _cache = {};

  @override
  Widget build(BuildContext context) {
    final key =
        '${widget.iconPath}-${widget.height}-${widget.color?.value ?? 'original'}';

    // Simple caching mechanism
    _cache.putIfAbsent(
      key,
      () => SvgPicture.asset(
        widget.iconPath,
        height: widget.height,
        colorFilter: widget.color != null
            ? ColorFilter.mode(widget.color!, BlendMode.srcIn)
            : null,
      ),
    );

    return _cache[key]!;
  }
}
