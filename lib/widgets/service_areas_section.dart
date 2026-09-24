import 'package:flutter/material.dart';

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

  late final Animation<double> _visualFade;
  late final Animation<Offset> _visualSlide;

  late final Animation<double> _infoFade;
  late final Animation<Offset> _infoSlide;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
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

    _visualFade = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.20, 0.65, curve: Curves.easeOut),
    );

    _visualSlide =
        Tween<Offset>(begin: const Offset(-0.08, 0), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.20, 0.70, curve: Curves.easeOutCubic),
          ),
        );

    _infoFade = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.30, 0.75, curve: Curves.easeOut),
    );

    _infoSlide = Tween<Offset>(begin: const Offset(0.08, 0), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.30, 0.78, curve: Curves.easeOutCubic),
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

    return Container(
      width: double.infinity,
      color: ServiceAreasSection.lightBg,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 24 : 70,
        vertical: isMobile ? 70 : 105,
      ),
      child: Column(
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
                    children: [
                      FadeTransition(
                        opacity: _visualFade,
                        child: SlideTransition(
                          position: _visualSlide,
                          child: const _DubaiCoverageVisual(),
                        ),
                      ),
                      const SizedBox(height: 40),
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
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 6,
                        child: FadeTransition(
                          opacity: _visualFade,
                          child: SlideTransition(
                            position: _visualSlide,
                            child: const _DubaiCoverageVisual(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 70),
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
      children: [
        TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.85, end: 1.0),
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeOutBack,
          builder: (context, scale, child) {
            return Transform.scale(scale: scale, child: child);
          },
          child: Container(
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
        ),

        const SizedBox(height: 18),

        Text(
          'Water Delivery Across Dubai',
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
          constraints: const BoxConstraints(maxWidth: 690),
          child: const Text(
            'From residential communities to commercial areas and '
            'construction sites, our delivery service covers locations '
            'across Dubai.',
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
// DUBAI COVERAGE VISUAL
// ============================================================

class _DubaiCoverageVisual extends StatefulWidget {
  const _DubaiCoverageVisual();

  @override
  State<_DubaiCoverageVisual> createState() => _DubaiCoverageVisualState();
}

class _DubaiCoverageVisualState extends State<_DubaiCoverageVisual>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  late final Animation<double> _mapLineAnimation;
  late final Animation<double> _centerScale;
  late final Animation<double> _badgeFade;
  late final Animation<Offset> _badgeSlide;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );

    _mapLineAnimation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.05, 0.55, curve: Curves.easeOutCubic),
    );

    _centerScale = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.35, 0.75, curve: Curves.easeOutBack),
    );

    _badgeFade = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.55, 0.85, curve: Curves.easeOut),
    );

    _badgeSlide = Tween<Offset>(begin: const Offset(0, 0.12), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.55, 0.90, curve: Curves.easeOutCubic),
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
    final isSmall = width < 500;

    return Container(
      width: double.infinity,
      height: isSmall ? 390 : 480,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: const Color(0xFFDDEDF1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.035),
            blurRadius: 25,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: Stack(
          children: [
            Positioned(
              top: 80,
              left: 0,
              right: 0,
              child: _AnimatedMapLine(
                rotation: -0.10,
                animation: _mapLineAnimation,
              ),
            ),

            Positioned(
              top: 175,
              left: -20,
              right: -20,
              child: _AnimatedMapLine(
                rotation: 0.08,
                animation: _mapLineAnimation,
              ),
            ),

            Positioned(
              top: 275,
              left: 0,
              right: 0,
              child: _AnimatedMapLine(
                rotation: -0.06,
                animation: _mapLineAnimation,
              ),
            ),

            Positioned(
              top: 365,
              left: -20,
              right: -20,
              child: _AnimatedMapLine(
                rotation: 0.10,
                animation: _mapLineAnimation,
              ),
            ),

            Positioned(
              left: 65,
              top: 70,
              child: const _AnimatedRoadDot(label: 'Jumeirah', delay: 0.35),
            ),

            Positioned(
              right: 70,
              top: 120,
              child: const _AnimatedRoadDot(label: 'Business Bay', delay: 0.45),
            ),

            Positioned(
              left: 95,
              top: 225,
              child: const _AnimatedRoadDot(label: 'Al Barsha', delay: 0.55),
            ),

            Positioned(
              right: 80,
              top: 285,
              child: const _AnimatedRoadDot(label: 'Deira', delay: 0.65),
            ),

            Positioned(
              left: 70,
              bottom: 65,
              child: const _AnimatedRoadDot(label: 'Dubai Marina', delay: 0.75),
            ),

            Center(
              child: AnimatedBuilder(
                animation: _centerScale,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _centerScale.value,
                    child: child,
                  );
                },
                child: _PulsingCoverageMarker(isSmall: isSmall),
              ),
            ),

            Positioned(
              top: 22,
              left: 22,
              child: FadeTransition(
                opacity: _badgeFade,
                child: SlideTransition(
                  position: _badgeSlide,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 13,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.06),
                          blurRadius: 18,
                          offset: const Offset(0, 7),
                        ),
                      ],
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.public_rounded,
                          size: 18,
                          color: ServiceAreasSection.primary,
                        ),
                        SizedBox(width: 7),
                        Text(
                          'Dubai Wide Coverage',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            color: ServiceAreasSection.darkText,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            Positioned(
              bottom: 22,
              right: 22,
              child: FadeTransition(
                opacity: _badgeFade,
                child: SlideTransition(
                  position: _badgeSlide,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 13,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: ServiceAreasSection.darkText,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.10),
                          blurRadius: 18,
                          offset: const Offset(0, 7),
                        ),
                      ],
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.local_shipping_rounded,
                          size: 17,
                          color: Color(0xFF56D4ED),
                        ),
                        SizedBox(width: 7),
                        Text(
                          'Fast Local Dispatch',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// ANIMATED MAP LINE
// ============================================================

class _AnimatedMapLine extends StatelessWidget {
  final double rotation;
  final Animation<double> animation;

  const _AnimatedMapLine({required this.rotation, required this.animation});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Align(
          alignment: Alignment.centerLeft,
          child: FractionallySizedBox(
            widthFactor: animation.value,
            child: Transform.rotate(
              angle: rotation,
              child: Container(
                height: 1,
                decoration: BoxDecoration(
                  color: const Color(0xFFD8EDF2),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF087EA4).withValues(alpha: 0.04),
                      blurRadius: 8,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

// ============================================================
// ANIMATED ROAD DOT
// ============================================================

class _AnimatedRoadDot extends StatefulWidget {
  final String label;
  final double delay;

  const _AnimatedRoadDot({required this.label, required this.delay});

  @override
  State<_AnimatedRoadDot> createState() => _AnimatedRoadDotState();
}

class _AnimatedRoadDotState extends State<_AnimatedRoadDot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  bool _hovering = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 550),
    );

    Future.delayed(Duration(milliseconds: (widget.delay * 1000).round()), () {
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
    return MouseRegion(
      cursor: SystemMouseCursors.basic,
      onEnter: (_) {
        setState(() => _hovering = true);
      },
      onExit: (_) {
        setState(() => _hovering = false);
      },
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final value = Curves.easeOutBack.transform(_controller.value);

          return Opacity(
            opacity: _controller.value,
            child: Transform.translate(
              offset: Offset(0, 12 * (1 - value)),
              child: child,
            ),
          );
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOutCubic,
          transform: Matrix4.translationValues(
            _hovering ? 3 : 0,
            _hovering ? -2 : 0,
            0,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                width: _hovering ? 10 : 8,
                height: _hovering ? 10 : 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF56C7DC),
                  boxShadow: [
                    BoxShadow(
                      color: ServiceAreasSection.primary.withValues(
                        alpha: _hovering ? 0.35 : 0.0,
                      ),
                      blurRadius: 8,
                      spreadRadius: 2,
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 6),

              Text(
                widget.label,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: _hovering ? FontWeight.w800 : FontWeight.w600,
                  color: ServiceAreasSection.bodyText,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================
// PULSING COVERAGE MARKER
// ============================================================

class _PulsingCoverageMarker extends StatefulWidget {
  final bool isSmall;

  const _PulsingCoverageMarker({required this.isSmall});

  @override
  State<_PulsingCoverageMarker> createState() => _PulsingCoverageMarkerState();
}

class _PulsingCoverageMarkerState extends State<_PulsingCoverageMarker>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final outerSize = widget.isSmall ? 105.0 : 125.0;
    final innerSize = widget.isSmall ? 68.0 : 78.0;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final pulse = Curves.easeInOut.transform(_controller.value);

        return Container(
          width: outerSize + (pulse * 10),
          height: outerSize + (pulse * 10),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: ServiceAreasSection.primary.withValues(
              alpha: 0.08 + (pulse * 0.05),
            ),
          ),
          child: Center(
            child: Container(
              width: innerSize,
              height: innerSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: ServiceAreasSection.primary,
                boxShadow: [
                  BoxShadow(
                    color: ServiceAreasSection.primary.withValues(
                      alpha: 0.20 + (pulse * 0.15),
                    ),
                    blurRadius: 20 + (pulse * 10),
                    spreadRadius: 3 + (pulse * 3),
                  ),
                ],
              ),
              child: const Icon(
                Icons.location_on_rounded,
                color: Colors.white,
                size: 36,
              ),
            ),
          ),
        );
      },
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Serving Homes, Businesses & Projects',
          style: TextStyle(
            fontSize: 30,
            height: 1.2,
            fontWeight: FontWeight.w800,
            color: ServiceAreasSection.darkText,
          ),
        ),

        const SizedBox(height: 15),

        const Text(
          'Our delivery network is designed to reach customers '
          'throughout Dubai with dependable tanker service and '
          'flexible delivery options.',
          style: TextStyle(
            fontSize: 15,
            height: 1.7,
            color: ServiceAreasSection.bodyText,
          ),
        ),

        const SizedBox(height: 30),

        const _AnimatedAreaItem(
          icon: Icons.home_rounded,
          title: 'Residential Areas',
          description: 'Homes, villas and private properties.',
          delay: 0,
        ),

        const SizedBox(height: 18),

        const _AnimatedAreaItem(
          icon: Icons.business_rounded,
          title: 'Commercial Areas',
          description: 'Offices, businesses, facilities and properties.',
          delay: 150,
        ),

        const SizedBox(height: 18),

        const _AnimatedAreaItem(
          icon: Icons.construction_rounded,
          title: 'Construction Sites',
          description: 'Reliable supply for ongoing projects and sites.',
          delay: 300,
        ),

        const SizedBox(height: 28),

        const _CoverageCallout(),
      ],
    );
  }
}

// ============================================================
// ANIMATED AREA ITEM
// ============================================================

class _AnimatedAreaItem extends StatefulWidget {
  final IconData icon;
  final String title;
  final String description;
  final int delay;

  const _AnimatedAreaItem({
    required this.icon,
    required this.title,
    required this.description,
    required this.delay,
  });

  @override
  State<_AnimatedAreaItem> createState() => _AnimatedAreaItemState();
}

class _AnimatedAreaItemState extends State<_AnimatedAreaItem>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  bool _hovering = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 550),
    );

    Future.delayed(Duration(milliseconds: widget.delay), () {
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
    return MouseRegion(
      cursor: SystemMouseCursors.basic,
      onEnter: (_) {
        setState(() => _hovering = true);
      },
      onExit: (_) {
        setState(() => _hovering = false);
      },
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final value = Curves.easeOutCubic.transform(_controller.value);

          return Opacity(
            opacity: value,
            child: Transform.translate(
              offset: Offset(25 * (1 - value), 0),
              child: child,
            ),
          );
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
          transform: Matrix4.translationValues(_hovering ? 6 : 0, 0, 0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 280),
                curve: Curves.easeOutBack,
                transform: Matrix4.identity(),
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
                        alpha: _hovering ? 0.12 : 0.0,
                      ),
                      blurRadius: 15,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: AnimatedScale(
                  scale: _hovering ? 1.10 : 1.0,
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
                  children: [
                    Text(
                      widget.title,
                      style: TextStyle(
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
      ),
    );
  }
}

// ============================================================
// COVERAGE CALLOUT
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
        setState(() => _hovering = true);
      },
      onExit: (_) {
        setState(() => _hovering = false);
      },
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final pulse = Curves.easeInOut.transform(_controller.value);

          return AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutCubic,
            transform: Matrix4.translationValues(0, _hovering ? -4 : 0, 0),
            width: double.infinity,
            padding: const EdgeInsets.all(20),
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
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  width: 42,
                  height: 42,
                  transform: Matrix4.identity()
                    ..scaleByDouble(
                      _hovering ? 1.08 : 1.0,
                      _hovering ? 1.08 : 1.0,
                      _hovering ? 1.08 : 1.0,
                      1.0,
                    ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.location_on_rounded,
                    color: Colors.white,
                    size: 24,
                  ),
                ),

                const SizedBox(width: 12),

                const Expanded(
                  child: Text(
                    'Not sure if we deliver to your location? '
                    'Contact our team and we will help.',
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
