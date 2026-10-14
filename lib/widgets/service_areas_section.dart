import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class ServiceAreasSection extends StatefulWidget {
  const ServiceAreasSection({super.key});

  static const Color primary = Color(0xFF087EA4);
  static const Color darkText = Color(0xFF102A43);
  static const Color bodyText = Color(0xFF52667A);
  static const Color lightBg = Color(0xFFF6FBFD);

  @override
  State<ServiceAreasSection> createState() => _ServiceAreasSectionState();
}

class _ServiceAreasSectionState extends State<ServiceAreasSection>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  late final Animation<double> _headingFade;
  late final Animation<Offset> _headingSlide;

  late final Animation<double> _mapFade;
  late final Animation<Offset> _mapSlide;

  late final Animation<double> _infoFade;
  late final Animation<Offset> _infoSlide;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _headingFade = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.25, curve: Curves.easeOut),
    );

    _headingSlide =
        Tween<Offset>(begin: const Offset(0, 0.12), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.0, 0.30, curve: Curves.easeOutCubic),
          ),
        );

    _mapFade = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.18, 0.62, curve: Curves.easeOut),
    );

    _mapSlide = Tween<Offset>(begin: const Offset(-0.06, 0), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.18, 0.68, curve: Curves.easeOutCubic),
          ),
        );

    _infoFade = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.28, 0.72, curve: Curves.easeOut),
    );

    _infoSlide = Tween<Offset>(begin: const Offset(0.06, 0), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.28, 0.78, curve: Curves.easeOutCubic),
          ),
        );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    final isMobile = width < 800;
    final isTablet = width >= 800 && width < 1200;

    return Container(
      width: double.infinity,
      color: ServiceAreasSection.lightBg,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile
            ? 20
            : isTablet
            ? 40
            : 70,
        vertical: isMobile
            ? 70
            : isTablet
            ? 85
            : 105,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FadeTransition(
            opacity: _headingFade,
            child: SlideTransition(
              position: _headingSlide,
              child: _Heading(isMobile: isMobile),
            ),
          ),

          const SizedBox(height: 55),

          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1180),
            child: isMobile
                ? Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      FadeTransition(
                        opacity: _mapFade,
                        child: SlideTransition(
                          position: _mapSlide,
                          child: const _RealServiceMap(),
                        ),
                      ),

                      const SizedBox(height: 42),

                      FadeTransition(
                        opacity: _infoFade,
                        child: SlideTransition(
                          position: _infoSlide,
                          child: const _CoverageInfo(),
                        ),
                      ),
                    ],
                  )
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 6,
                        child: FadeTransition(
                          opacity: _mapFade,
                          child: SlideTransition(
                            position: _mapSlide,
                            child: const _RealServiceMap(),
                          ),
                        ),
                      ),

                      SizedBox(width: isTablet ? 40 : 65),

                      Expanded(
                        flex: 4,
                        child: FadeTransition(
                          opacity: _infoFade,
                          child: SlideTransition(
                            position: _infoSlide,
                            child: const _CoverageInfo(),
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// HEADING
// ============================================================

class _Heading extends StatelessWidget {
  final bool isMobile;

  const _Heading({required this.isMobile});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: const Color(0xFFB9E8F1)),
            boxShadow: [
              BoxShadow(
                color: ServiceAreasSection.primary.withValues(alpha: 0.06),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: const Text(
            'SERVICE AREAS',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.8,
              color: ServiceAreasSection.primary,
            ),
          ),
        ),

        const SizedBox(height: 18),

        Text(
          'Water Delivery Across UAE',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: isMobile ? 31 : 44,
            height: 1.15,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.8,
            color: ServiceAreasSection.darkText,
          ),
        ),

        const SizedBox(height: 15),

        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720),
          child: const Text(
            'Reliable water tanker delivery across Dubai, Sharjah '
            'and Ajman for homes, businesses and construction sites.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              height: 1.7,
              color: ServiceAreasSection.bodyText,
            ),
          ),
        ),
      ],
    );
  }
}

// ============================================================
// REAL MAP
// ============================================================

class _RealServiceMap extends StatefulWidget {
  const _RealServiceMap();

  @override
  State<_RealServiceMap> createState() => _RealServiceMapState();
}

class _RealServiceMapState extends State<_RealServiceMap>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  late final Animation<double> _fade;

  final MapController _mapController = MapController();

  static const LatLng _mapCenter = LatLng(25.315, 55.405);

  static const LatLng _dubai = LatLng(25.2048, 55.2708);

  static const LatLng _sharjah = LatLng(25.3463, 55.4209);

  static const LatLng _ajman = LatLng(25.4052, 55.5136);

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    );

    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeOut);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // ==========================================================
  // MAP CONTROLS
  // ==========================================================

  void _zoomIn() {
    final currentZoom = _mapController.camera.zoom;

    _mapController.move(_mapController.camera.center, currentZoom + 0.7);
  }

  void _zoomOut() {
    final currentZoom = _mapController.camera.zoom;

    _mapController.move(_mapController.camera.center, currentZoom - 0.7);
  }

  void _resetMap() {
    _mapController.move(_mapCenter, 10.6);
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    final isTinyMobile = width <= 340;
    final isVerySmall = width <= 380;
    final isSmallMobile = width <= 500;

    final double mapHeight;

    if (isTinyMobile) {
      mapHeight = 410;
    } else if (isVerySmall) {
      mapHeight = 425;
    } else if (isSmallMobile) {
      mapHeight = 440;
    } else {
      mapHeight = 500;
    }

    return FadeTransition(
      opacity: _fade,
      child: Container(
        width: double.infinity,
        height: mapHeight,
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(isVerySmall ? 22 : 30),
          border: Border.all(color: const Color(0xFFDDEDF1)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.045),
              blurRadius: 28,
              offset: const Offset(0, 14),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(isVerySmall ? 22 : 30),
          child: Stack(
            clipBehavior: Clip.hardEdge,
            children: [
              // ==================================================
              // MAP
              // ==================================================

              FlutterMap(
                mapController: _mapController,

                options: MapOptions(
                  initialCenter: _mapCenter,
                  initialZoom: 10.6,
                  minZoom: 9.5,
                  maxZoom: 16.0,

                  // =================================================
                  // IMPORTANT SCROLL FIX
                  //
                  // We intentionally DO NOT enable:
                  // - mouse drag
                  // - scroll wheel zoom
                  // - fling animation
                  //
                  // This prevents the map from taking control of
                  // the webpage's scrolling.
                  //
                  // Zoom still works using:
                  // + / - buttons
                  // double click
                  // mobile pinch
                  // =================================================
                  interactionOptions: const InteractionOptions(
                    flags:
                        InteractiveFlag.doubleTapZoom |
                        InteractiveFlag.doubleTapDragZoom |
                        InteractiveFlag.pinchMove |
                        InteractiveFlag.pinchZoom,
                  ),
                ),

                children: [
                  // ==================================================
                  // OPENSTREETMAP
                  // ==================================================

                  TileLayer(
                    urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'sweet_water_tankers',
                    maxZoom: 19,
                  ),

                  // ==================================================
                  // COVERAGE CIRCLES
                  // ==================================================
                  CircleLayer(
                    circles: [
                      CircleMarker(
                        point: _dubai,
                        radius: 5000,
                        useRadiusInMeter: true,
                        color: ServiceAreasSection.primary.withValues(
                          alpha: 0.07,
                        ),
                        borderColor: ServiceAreasSection.primary.withValues(
                          alpha: 0.30,
                        ),
                        borderStrokeWidth: 2,
                      ),

                      CircleMarker(
                        point: _sharjah,
                        radius: 4000,
                        useRadiusInMeter: true,
                        color: ServiceAreasSection.primary.withValues(
                          alpha: 0.06,
                        ),
                        borderColor: ServiceAreasSection.primary.withValues(
                          alpha: 0.25,
                        ),
                        borderStrokeWidth: 2,
                      ),

                      CircleMarker(
                        point: _ajman,
                        radius: 3500,
                        useRadiusInMeter: true,
                        color: ServiceAreasSection.primary.withValues(
                          alpha: 0.06,
                        ),
                        borderColor: ServiceAreasSection.primary.withValues(
                          alpha: 0.25,
                        ),
                        borderStrokeWidth: 2,
                      ),
                    ],
                  ),

                  // ==================================================
                  // CONNECTION LINE
                  // ==================================================
                  PolylineLayer(
                    polylines: [
                      Polyline(
                        points: const [_dubai, _sharjah, _ajman],
                        strokeWidth: 3,
                        color: ServiceAreasSection.primary.withValues(
                          alpha: 0.65,
                        ),
                        pattern: const StrokePattern.dotted(spacingFactor: 1.5),
                      ),
                    ],
                  ),

                  // ==================================================
                  // MARKERS
                  // ==================================================
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: _dubai,
                        width: isVerySmall ? 124 : 155,
                        height: isVerySmall ? 120 : 125,
                        alignment: Alignment.topCenter,
                        child: _MapMarker(
                          name: 'Dubai',
                          subtitle: 'Main Service Area',
                          primary: true,
                          compact: isVerySmall,
                        ),
                      ),

                      Marker(
                        point: _sharjah,
                        width: isVerySmall ? 118 : 150,
                        height: isVerySmall ? 120 : 125,
                        alignment: Alignment.topCenter,
                        child: _MapMarker(
                          name: 'Sharjah',
                          subtitle: 'Service Area',
                          primary: false,
                          compact: isVerySmall,
                        ),
                      ),

                      Marker(
                        point: _ajman,
                        width: isVerySmall ? 114 : 145,
                        height: isVerySmall ? 120 : 125,
                        alignment: Alignment.topCenter,
                        child: _MapMarker(
                          name: 'Ajman',
                          subtitle: 'Service Area',
                          primary: false,
                          compact: isVerySmall,
                        ),
                      ),
                    ],
                  ),

                  // ==================================================
                  // ATTRIBUTION
                  // ==================================================
                  RichAttributionWidget(
                    attributions: [
                      TextSourceAttribution(
                        'OpenStreetMap contributors',
                        onTap: () {},
                      ),
                    ],
                  ),
                ],
              ),

              // ==================================================
              // TOP BADGES
              // ==================================================
              if (isVerySmall)
                Positioned(
                  top: 12,
                  left: 12,
                  right: 12,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Flexible(child: _MapTopBadge(compact: true)),

                      const SizedBox(width: 8),

                      Flexible(
                        child: Align(
                          alignment: Alignment.topRight,
                          child: _ServiceAreaBadge(compact: true),
                        ),
                      ),
                    ],
                  ),
                )
              else ...[
                Positioned(
                  top: 18,
                  left: 18,
                  child: _MapTopBadge(compact: false),
                ),

                Positioned(
                  top: 18,
                  right: 18,
                  child: _ServiceAreaBadge(compact: false),
                ),
              ],

              // ==================================================
              // MAP CONTROLS
              // ==================================================
              Positioned(
                right: isVerySmall ? 12 : 18,
                bottom: isVerySmall ? 70 : 48,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _MapControlButton(
                      compact: isVerySmall,
                      icon: Icons.add_rounded,
                      onTap: _zoomIn,
                    ),

                    SizedBox(height: isVerySmall ? 5 : 7),

                    _MapControlButton(
                      compact: isVerySmall,
                      icon: Icons.remove_rounded,
                      onTap: _zoomOut,
                    ),

                    SizedBox(height: isVerySmall ? 5 : 7),

                    _MapControlButton(
                      compact: isVerySmall,
                      icon: Icons.my_location_rounded,
                      onTap: _resetMap,
                    ),
                  ],
                ),
              ),

              // ==================================================
              // BOTTOM DELIVERY BADGE
              // ==================================================
              Positioned(
                left: isVerySmall ? 12 : 18,
                bottom: isVerySmall ? 14 : 18,
                right: isVerySmall ? 68 : null,
                child: _DeliveryBadge(compact: isVerySmall),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================
// SERVICE AREA BADGE
// ============================================================

class _ServiceAreaBadge extends StatelessWidget {
  final bool compact;

  const _ServiceAreaBadge({required this.compact});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 9 : 13,
        vertical: compact ? 8 : 10,
      ),
      decoration: BoxDecoration(
        color: ServiceAreasSection.darkText,
        borderRadius: BorderRadius.circular(compact ? 11 : 14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.14),
            blurRadius: 18,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.location_on_rounded,
            color: const Color(0xFF56D4ED),
            size: compact ? 15 : 17,
          ),

          SizedBox(width: compact ? 4 : 6),

          Text(
            '3 SERVICE AREAS',
            style: TextStyle(
              fontSize: compact ? 8 : 10,
              fontWeight: FontWeight.w800,
              letterSpacing: compact ? 0.3 : 0.5,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// MAP MARKER
// ============================================================

class _MapMarker extends StatefulWidget {
  final String name;
  final String subtitle;
  final bool primary;
  final bool compact;

  const _MapMarker({
    required this.name,
    required this.subtitle,
    required this.primary,
    this.compact = false,
  });

  @override
  State<_MapMarker> createState() => _MapMarkerState();
}

class _MapMarkerState extends State<_MapMarker>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  bool _hovering = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1700),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) {
          setState(() {
            _hovering = true;
          });
        },
        onExit: (_) {
          setState(() {
            _hovering = false;
          });
        },
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            final pulse = Curves.easeInOut.transform(_controller.value);

            final normalPrimarySize = widget.compact ? 40.0 : 48.0;

            final normalSecondarySize = widget.compact ? 35.0 : 42.0;

            final pinSize = widget.primary
                ? normalPrimarySize + (pulse * (widget.compact ? 3 : 4))
                : normalSecondarySize + (pulse * (widget.compact ? 2 : 3));

            final iconOuter = widget.primary
                ? widget.compact
                      ? 25.0
                      : 31.0
                : widget.compact
                ? 23.0
                : 27.0;

            return AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              transform: Matrix4.translationValues(0, _hovering ? -4 : 0, 0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: pinSize,
                    height: pinSize,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: ServiceAreasSection.primary.withValues(
                        alpha: widget.primary ? 0.13 : 0.10,
                      ),
                    ),
                    child: Center(
                      child: Container(
                        width: iconOuter,
                        height: iconOuter,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: ServiceAreasSection.primary,
                          boxShadow: [
                            BoxShadow(
                              color: ServiceAreasSection.primary.withValues(
                                alpha: 0.22 + (pulse * 0.10),
                              ),
                              blurRadius: widget.compact ? 12 : 16,
                              spreadRadius: widget.compact ? 1 : 2,
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.location_on_rounded,
                          size: widget.primary
                              ? widget.compact
                                    ? 15
                                    : 18
                              : widget.compact
                              ? 14
                              : 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: widget.compact ? 2 : 4),

                  AnimatedContainer(
                    duration: const Duration(milliseconds: 220),
                    padding: EdgeInsets.symmetric(
                      horizontal: widget.compact ? 7 : 10,
                      vertical: widget.compact ? 5 : 7,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(
                        widget.compact ? 8 : 11,
                      ),
                      border: Border.all(color: const Color(0xFFE0EFF3)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(
                            alpha: _hovering ? 0.13 : 0.08,
                          ),
                          blurRadius: _hovering ? 18 : 12,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          widget.name,
                          style: TextStyle(
                            fontSize: widget.primary
                                ? widget.compact
                                      ? 10
                                      : 12
                                : widget.compact
                                ? 9
                                : 11,
                            fontWeight: FontWeight.w800,
                            color: ServiceAreasSection.darkText,
                          ),
                        ),

                        SizedBox(height: widget.compact ? 1 : 2),

                        Text(
                          widget.subtitle,
                          style: TextStyle(
                            fontSize: widget.compact ? 7 : 8,
                            fontWeight: FontWeight.w600,
                            color: ServiceAreasSection.bodyText,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

// ============================================================
// MAP TOP BADGE
// ============================================================

class _MapTopBadge extends StatelessWidget {
  final bool compact;

  const _MapTopBadge({required this.compact});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 9 : 12,
        vertical: compact ? 7 : 9,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.96),
        borderRadius: BorderRadius.circular(compact ? 10 : 13),
        border: Border.all(color: const Color(0xFFE0EFF3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.public_rounded,
            size: compact ? 15 : 17,
            color: ServiceAreasSection.primary,
          ),

          SizedBox(width: compact ? 5 : 7),

          Text(
            'UAE COVERAGE',
            style: TextStyle(
              fontSize: compact ? 8 : 10,
              fontWeight: FontWeight.w800,
              letterSpacing: compact ? 0.4 : 0.7,
              color: ServiceAreasSection.darkText,
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// DELIVERY BADGE
// ============================================================

class _DeliveryBadge extends StatelessWidget {
  final bool compact;

  const _DeliveryBadge({required this.compact});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 9 : 13,
        vertical: compact ? 7 : 9,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.96),
        borderRadius: BorderRadius.circular(compact ? 10 : 13),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.local_shipping_rounded,
            size: compact ? 15 : 17,
            color: ServiceAreasSection.primary,
          ),

          SizedBox(width: compact ? 5 : 7),

          Flexible(
            child: Text(
              'Water Tanker Delivery',
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: TextStyle(
                fontSize: compact ? 9 : 11,
                fontWeight: FontWeight.w800,
                color: ServiceAreasSection.darkText,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// MAP CONTROL
// ============================================================

class _MapControlButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool compact;

  const _MapControlButton({
    required this.icon,
    required this.onTap,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final size = compact ? 36.0 : 42.0;

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(compact ? 10 : 12),
      elevation: 3,
      shadowColor: Colors.black.withValues(alpha: 0.12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(compact ? 10 : 12),
        child: SizedBox(
          width: size,
          height: size,
          child: Icon(
            icon,
            color: ServiceAreasSection.darkText,
            size: compact ? 18 : 20,
          ),
        ),
      ),
    );
  }
}

// ============================================================
// COVERAGE INFO
// ============================================================

class _CoverageInfo extends StatelessWidget {
  const _CoverageInfo();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    final isSmall = width < 500;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Serving Dubai, Sharjah & Ajman',
          style: TextStyle(
            fontSize: isSmall ? 27 : 30,
            height: 1.2,
            fontWeight: FontWeight.w800,
            color: ServiceAreasSection.darkText,
          ),
        ),

        const SizedBox(height: 15),

        const Text(
          'Our tanker delivery service covers three key areas '
          'across the UAE, providing dependable water supply '
          'for residential, commercial and construction needs.',
          style: TextStyle(
            fontSize: 15,
            height: 1.7,
            color: ServiceAreasSection.bodyText,
          ),
        ),

        const SizedBox(height: 28),

        const _AreaItem(
          icon: Icons.location_city_rounded,
          title: 'Dubai',
          description:
              'Water tanker delivery for homes, businesses and projects.',
        ),

        const SizedBox(height: 16),

        const _AreaItem(
          icon: Icons.location_on_rounded,
          title: 'Sharjah',
          description:
              'Reliable water supply for residential and commercial areas.',
        ),

        const SizedBox(height: 16),

        const _AreaItem(
          icon: Icons.water_drop_rounded,
          title: 'Ajman',
          description:
              'Flexible tanker delivery for properties and construction sites.',
        ),

        const SizedBox(height: 27),

        const _CoverageCallout(),
      ],
    );
  }
}

// ============================================================
// AREA ITEM
// ============================================================

class _AreaItem extends StatefulWidget {
  final IconData icon;
  final String title;
  final String description;

  const _AreaItem({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  State<_AreaItem> createState() => _AreaItemState();
}

class _AreaItemState extends State<_AreaItem> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.basic,
      onEnter: (_) {
        setState(() {
          _hovering = true;
        });
      },
      onExit: (_) {
        setState(() {
          _hovering = false;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 280),
        transform: Matrix4.translationValues(_hovering ? 5 : 0, 0, 0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: _hovering
                    ? const Color(0xFFDDF5F9)
                    : const Color(0xFFEAF8FB),
                borderRadius: BorderRadius.circular(13),
                boxShadow: [
                  BoxShadow(
                    color: ServiceAreasSection.primary.withValues(
                      alpha: _hovering ? 0.12 : 0,
                    ),
                    blurRadius: 15,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: AnimatedScale(
                scale: _hovering ? 1.10 : 1,
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeOutBack,
                child: Icon(
                  widget.icon,
                  color: ServiceAreasSection.primary,
                  size: 21,
                ),
              ),
            ),

            const SizedBox(width: 13),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    widget.title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: ServiceAreasSection.darkText,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    widget.description,
                    style: const TextStyle(
                      fontSize: 13,
                      height: 1.5,
                      color: ServiceAreasSection.bodyText,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// CALLOUT
// ============================================================

class _CoverageCallout extends StatefulWidget {
  const _CoverageCallout();

  @override
  State<_CoverageCallout> createState() => _CoverageCalloutState();
}

class _CoverageCalloutState extends State<_CoverageCallout>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  bool _hovering = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.basic,
      onEnter: (_) {
        setState(() {
          _hovering = true;
        });
      },
      onExit: (_) {
        setState(() {
          _hovering = false;
        });
      },
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final pulse = Curves.easeInOut.transform(_controller.value);

          return AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            transform: Matrix4.translationValues(0, _hovering ? -4 : 0, 0),
            width: double.infinity,
            padding: const EdgeInsets.all(19),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF087EA4), Color(0xFF075E7A)],
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: ServiceAreasSection.primary.withValues(
                    alpha: _hovering ? 0.20 : 0.08 + (pulse * 0.05),
                  ),
                  blurRadius: _hovering ? 25 : 18 + (pulse * 5),
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.local_shipping_rounded,
                    color: Colors.white,
                    size: 22,
                  ),
                ),

                const SizedBox(width: 12),

                const Expanded(
                  child: Text(
                    'Need water delivery in Dubai, Sharjah or Ajman? '
                    'Contact our team for availability.',
                    style: TextStyle(
                      fontSize: 13,
                      height: 1.5,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
