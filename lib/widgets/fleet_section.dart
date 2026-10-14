import 'package:flutter/material.dart';

class FleetSection extends StatefulWidget {
  const FleetSection({super.key});

  static const Color primary = Color(0xFF087EA4);
  static const Color darkText = Color(0xFF102A43);
  static const Color bodyText = Color(0xFF52667A);
  static const Color lightBg = Color(0xFFF6FBFD);

  @override
  State<FleetSection> createState() => _FleetSectionState();
}

class _FleetSectionState extends State<FleetSection>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  late final Animation<double> _headingFade;
  late final Animation<Offset> _headingSlide;

  late final Animation<double> _showcaseFade;
  late final Animation<Offset> _showcaseSlide;

  late final Animation<double> _cardsFade;
  late final Animation<Offset> _cardsSlide;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1300),
    );

    _headingFade = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.25, curve: Curves.easeOutCubic),
    );

    _headingSlide =
        Tween<Offset>(begin: const Offset(0, 0.16), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.0, 0.25, curve: Curves.easeOutCubic),
          ),
        );

    _showcaseFade = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.16, 0.68, curve: Curves.easeOutCubic),
    );

    _showcaseSlide =
        Tween<Offset>(begin: const Offset(0, 0.10), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.16, 0.68, curve: Curves.easeOutCubic),
          ),
        );

    _cardsFade = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.55, 1.0, curve: Curves.easeOutCubic),
    );

    _cardsSlide = Tween<Offset>(begin: const Offset(0, 0.10), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.55, 1.0, curve: Curves.easeOutCubic),
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
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        final bool isMobile = width < 768;
        final bool isTablet = width >= 768 && width < 1200;
        final bool isDesktop = width >= 1200;

        final double horizontalPadding = isMobile
            ? 20
            : isTablet
            ? 35
            : 70;

        final double verticalPadding = isMobile ? 65 : 105;

        return Container(
          width: double.infinity,
          color: FleetSection.lightBg,
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: verticalPadding,
          ),
          child: Column(
            children: [
              FadeTransition(
                opacity: _headingFade,
                child: SlideTransition(
                  position: _headingSlide,
                  child: _SectionHeading(isMobile: isMobile),
                ),
              ),

              SizedBox(
                height: isMobile
                    ? 38
                    : isTablet
                    ? 45
                    : 60,
              ),

              FadeTransition(
                opacity: _showcaseFade,
                child: SlideTransition(
                  position: _showcaseSlide,
                  child: _FleetShowcase(
                    isMobile: isMobile,
                    isTablet: isTablet,
                    isDesktop: isDesktop,
                  ),
                ),
              ),

              SizedBox(
                height: isMobile
                    ? 30
                    : isTablet
                    ? 40
                    : 55,
              ),

              FadeTransition(
                opacity: _cardsFade,
                child: SlideTransition(
                  position: _cardsSlide,
                  child: _FleetCards(
                    isMobile: isMobile,
                    isTablet: isTablet,
                    isDesktop: isDesktop,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ============================================================
// SECTION HEADING
// ============================================================

class _SectionHeading extends StatelessWidget {
  final bool isMobile;

  const _SectionHeading({required this.isMobile});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0xFFEAF8FB),
            borderRadius: BorderRadius.circular(30),
          ),
          child: const Text(
            'OUR FLEET',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.8,
              color: FleetSection.primary,
            ),
          ),
        ),

        const SizedBox(height: 17),

        Padding(
          padding: EdgeInsets.symmetric(horizontal: isMobile ? 5 : 15),
          child: Text(
            'Ready to Deliver Across Dubai',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: isMobile ? 30 : 44,
              height: 1.15,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.8,
              color: FleetSection.darkText,
            ),
          ),
        ),

        const SizedBox(height: 14),

        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 680),
          child: Text(
            'Our modern tanker fleet is ready to deliver reliable '
            'water supplies for homes, businesses and construction '
            'projects across Dubai.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: isMobile ? 15 : 16,
              height: 1.7,
              color: FleetSection.bodyText,
            ),
          ),
        ),
      ],
    );
  }
}

// ============================================================
// MAIN FLEET SHOWCASE
// ============================================================

class _FleetShowcase extends StatelessWidget {
  final bool isMobile;
  final bool isTablet;
  final bool isDesktop;

  const _FleetShowcase({
    required this.isMobile,
    required this.isTablet,
    required this.isDesktop,
  });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 1180),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(isMobile ? 24 : 30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.055),
              blurRadius: 28,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(isMobile ? 24 : 30),
          child: _buildShowcase(),
        ),
      ),
    );
  }

  Widget _buildShowcase() {
    if (isMobile) {
      return const _MobileShowcase();
    }

    if (isTablet) {
      return const _TabletShowcase();
    }

    return const _DesktopShowcase();
  }
}

// ============================================================
// MOBILE SHOWCASE
// ============================================================

class _MobileShowcase extends StatelessWidget {
  const _MobileShowcase();

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _TankerVisual(mode: _TankerVisualMode.mobile),
        _FleetInformation(isMobile: true),
      ],
    );
  }
}

// ============================================================
// TABLET SHOWCASE
// ============================================================

class _TabletShowcase extends StatelessWidget {
  const _TabletShowcase();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 410,
      child: Row(
        children: [
          Expanded(
            flex: 55,
            child: _TankerVisual(mode: _TankerVisualMode.tablet),
          ),
          Expanded(flex: 45, child: _FleetInformation(isMobile: false)),
        ],
      ),
    );
  }
}

// ============================================================
// DESKTOP SHOWCASE
// ============================================================

class _DesktopShowcase extends StatelessWidget {
  const _DesktopShowcase();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 470,
      child: Row(
        children: [
          Expanded(
            flex: 6,
            child: _TankerVisual(mode: _TankerVisualMode.desktop),
          ),
          Expanded(flex: 4, child: _FleetInformation(isMobile: false)),
        ],
      ),
    );
  }
}

// ============================================================
// TANKER VISUAL MODE
// ============================================================

enum _TankerVisualMode { mobile, tablet, desktop }

// ============================================================
// TANKER VISUAL
// ============================================================

class _TankerVisual extends StatefulWidget {
  final _TankerVisualMode mode;

  const _TankerVisual({required this.mode});

  @override
  State<_TankerVisual> createState() => _TankerVisualState();
}

class _TankerVisualState extends State<_TankerVisual>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  late final Animation<double> _imageScale;
  late final Animation<double> _contentFade;
  late final Animation<Offset> _contentSlide;

  bool _hovered = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    );

    _imageScale = Tween<double>(
      begin: 1.08,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    _contentFade = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.35, 1.0, curve: Curves.easeOut),
    );

    _contentSlide =
        Tween<Offset>(begin: const Offset(0, 0.10), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.35, 1.0, curve: Curves.easeOutCubic),
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
    final bool isMobile = widget.mode == _TankerVisualMode.mobile;

    final bool isTablet = widget.mode == _TankerVisualMode.tablet;

    final double visualHeight = isMobile
        ? 285
        : isTablet
        ? 410
        : 470;

    return MouseRegion(
      cursor: SystemMouseCursors.basic,
      onEnter: (_) {
        if (!isMobile && mounted) {
          setState(() {
            _hovered = true;
          });
        }
      },
      onExit: (_) {
        if (!isMobile && mounted) {
          setState(() {
            _hovered = false;
          });
        }
      },
      child: SizedBox(
        width: double.infinity,
        height: visualHeight,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // ==================================================
            // MAIN TANKER IMAGE
            // ==================================================

            ClipRect(
              child: AnimatedScale(
                scale: _hovered ? 1.035 : 1.0,
                duration: const Duration(milliseconds: 700),
                curve: Curves.easeOutCubic,
                child: ScaleTransition(
                  scale: _imageScale,
                  child: Image.asset(
                    'assets/images/fleet/main_tanker.jpg',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: const Color(0xFFE9F9FC),
                        child: const Center(
                          child: Icon(
                            Icons.local_shipping_rounded,
                            size: 100,
                            color: FleetSection.primary,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),

            // ==================================================
            // IMAGE OVERLAY
            // ==================================================
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.02),
                    Colors.black.withValues(alpha: 0.52),
                  ],
                ),
              ),
            ),

            // ==================================================
            // TOP WATER DROP
            // ==================================================
            Positioned(
              top: isMobile ? 25 : 35,
              right: isMobile ? 25 : 40,
              child: TweenAnimationBuilder<double>(
                tween: Tween<double>(begin: 0.0, end: 1.0),
                duration: const Duration(milliseconds: 1000),
                curve: Curves.easeOutCubic,
                builder: (context, value, child) {
                  final double safeValue = value.clamp(0.0, 1.0);

                  return Transform.translate(
                    offset: Offset(0, (1 - safeValue) * -18),
                    child: Opacity(opacity: safeValue, child: child),
                  );
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  width: isMobile ? 38 : 46,
                  height: isMobile ? 38 : 46,
                  transform: Matrix4.identity(),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.90),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(
                          alpha: _hovered ? 0.14 : 0.08,
                        ),
                        blurRadius: _hovered ? 17 : 12,
                      ),
                    ],
                  ),
                  child: Transform.translate(
                    offset: Offset(0, _hovered ? -4 : 0),
                    child: Icon(
                      Icons.water_drop_rounded,
                      size: isMobile ? 20 : 24,
                      color: FleetSection.primary,
                    ),
                  ),
                ),
              ),
            ),

            // ==================================================
            // BOTTOM CONTENT
            // ==================================================
            Positioned(
              left: isMobile ? 20 : 35,
              right: isMobile ? 20 : 35,
              bottom: isMobile ? 20 : 30,
              child: FadeTransition(
                opacity: _contentFade,
                child: SlideTransition(
                  position: _contentSlide,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Sweet Water Tankers',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: isMobile ? 18 : 23,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              'Reliable Water Tanker Delivery',
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.90),
                                fontSize: isMobile ? 11 : 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(width: 12),

                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: isMobile ? 11 : 14,
                          vertical: isMobile ? 8 : 10,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.94),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.water_drop_rounded,
                              size: isMobile ? 14 : 16,
                              color: FleetSection.primary,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'AVAILABLE',
                              style: TextStyle(
                                fontSize: isMobile ? 9 : 10,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 1,
                                color: FleetSection.darkText,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
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
// FLEET INFORMATION
// ============================================================

class _FleetInformation extends StatefulWidget {
  final bool isMobile;

  const _FleetInformation({required this.isMobile});

  @override
  State<_FleetInformation> createState() => _FleetInformationState();
}

class _FleetInformationState extends State<_FleetInformation> {
  int _hoveredIndex = -1;

  @override
  Widget build(BuildContext context) {
    final double padding = widget.isMobile ? 25 : 38;

    final infoRows = [
      const _InfoRowData(
        icon: Icons.local_shipping_rounded,
        title: 'Modern Tankers',
        subtitle: 'Well-maintained delivery vehicles',
      ),
      const _InfoRowData(
        icon: Icons.speed_rounded,
        title: 'Fast Dispatch',
        subtitle: 'Quick response for urgent needs',
      ),
      const _InfoRowData(
        icon: Icons.location_on_rounded,
        title: 'Dubai Wide',
        subtitle: 'Serving residential and commercial areas',
      ),
    ];

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(padding),
      color: Colors.white,
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0.0, end: 1.0),
              duration: const Duration(milliseconds: 800),
              curve: Curves.easeOutCubic,
              builder: (context, value, child) {
                final double safeValue = value.clamp(0.0, 1.0);

                return Transform.scale(
                  scale: 0.90 + (safeValue * 0.10),
                  child: Opacity(opacity: safeValue, child: child),
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFEAF8FB),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const Text(
                  'RELIABLE FLEET',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.3,
                    color: FleetSection.primary,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 18),

            TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0.0, end: 1.0),
              duration: const Duration(milliseconds: 850),
              curve: Curves.easeOutCubic,
              builder: (context, value, child) {
                final double safeValue = value.clamp(0.0, 1.0);

                return Transform.translate(
                  offset: Offset(0, 14 * (1 - safeValue)),
                  child: Opacity(opacity: safeValue, child: child),
                );
              },
              child: Text(
                'Water Delivery You Can Count On',
                style: TextStyle(
                  fontSize: widget.isMobile ? 25 : 27,
                  height: 1.2,
                  fontWeight: FontWeight.w800,
                  color: FleetSection.darkText,
                ),
              ),
            ),

            const SizedBox(height: 12),

            Text(
              'Our tanker fleet is prepared for scheduled and '
              'on-demand water deliveries throughout Dubai.',
              style: TextStyle(
                fontSize: widget.isMobile ? 13.5 : 14,
                height: 1.65,
                color: FleetSection.bodyText,
              ),
            ),

            const SizedBox(height: 22),

            for (int index = 0; index < infoRows.length; index++) ...[
              MouseRegion(
                cursor: SystemMouseCursors.basic,
                onEnter: (_) {
                  if (mounted) {
                    setState(() {
                      _hoveredIndex = index;
                    });
                  }
                },
                onExit: (_) {
                  if (mounted) {
                    setState(() {
                      _hoveredIndex = -1;
                    });
                  }
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 220),
                  curve: Curves.easeOutCubic,
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: _hoveredIndex == index
                        ? const Color(0xFFF5FBFD)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Transform.translate(
                    offset: Offset(_hoveredIndex == index ? 4 : 0, 0),
                    child: _InfoRow(
                      data: infoRows[index],
                      hovered: _hoveredIndex == index,
                    ),
                  ),
                ),
              ),
              if (index != infoRows.length - 1) const SizedBox(height: 8),
            ],
          ],
        ),
      ),
    );
  }
}

// ============================================================
// INFO ROW DATA
// ============================================================

class _InfoRowData {
  final IconData icon;
  final String title;
  final String subtitle;

  const _InfoRowData({
    required this.icon,
    required this.title,
    required this.subtitle,
  });
}

// ============================================================
// INFO ROW
// ============================================================

class _InfoRow extends StatelessWidget {
  final _InfoRowData data;
  final bool hovered;

  const _InfoRow({required this.data, required this.hovered});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: hovered
                ? FleetSection.primary.withValues(alpha: 0.12)
                : const Color(0xFFEAF8FB),
            borderRadius: BorderRadius.circular(12),
          ),
          child: AnimatedScale(
            scale: hovered ? 1.08 : 1.0,
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOutBack,
            child: Icon(data.icon, size: 21, color: FleetSection.primary),
          ),
        ),

        const SizedBox(width: 13),

        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                data.title,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: FleetSection.darkText,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                data.subtitle,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 11,
                  height: 1.4,
                  color: FleetSection.bodyText,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ============================================================
// FLEET CARDS
// ============================================================

class _FleetCards extends StatelessWidget {
  final bool isMobile;
  final bool isTablet;
  final bool isDesktop;

  const _FleetCards({
    required this.isMobile,
    required this.isTablet,
    required this.isDesktop,
  });

  @override
  Widget build(BuildContext context) {
    final cards = [
      const _FleetCardData(
        image: 'assets/images/fleet/residential_tanker.jpg',
        icon: Icons.home_rounded,
        title: 'Residential Tankers',
        description: 'Reliable water delivery for villas, homes and residential properties.',
      ),
      const _FleetCardData(
        image: 'assets/images/fleet/commercial_tanker.jpg',
        icon: Icons.business_rounded,
        title: 'Commercial Tankers',
        description: 'Flexible water supply solutions for offices, businesses and facilities.',
      ),
      const _FleetCardData(
        image: 'assets/images/fleet/construction_tanker.jpg',
        icon: Icons.construction_rounded,
        title: 'Construction Supply',
        description: 'Dependable bulk water delivery for construction sites and projects.',
      ),
    ];

    // ==========================================================
    // MOBILE
    // ==========================================================

    if (isMobile) {
      return ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 620),
        child: Column(
          children: [
            for (int index = 0; index < cards.length; index++)
              Padding(
                padding: EdgeInsets.only(
                  bottom: index == cards.length - 1 ? 0 : 15,
                ),
                child: _AnimatedFleetCard(
                  data: cards[index],
                  isMobile: true,
                  index: index,
                ),
              ),
          ],
        ),
      );
    }

    // ==========================================================
    // TABLET
    // ==========================================================

    if (isTablet) {
      return ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 900),
        child: Wrap(
          spacing: 15,
          runSpacing: 15,
          children: [
            for (int index = 0; index < cards.length; index++)
              SizedBox(
                width: 430,
                child: _AnimatedFleetCard(
                  data: cards[index],
                  isMobile: false,
                  index: index,
                ),
              ),
          ],
        ),
      );
    }

    // ==========================================================
    // DESKTOP
    // ==========================================================

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 1180),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (int index = 0; index < cards.length; index++)
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                  left: index == 0 ? 0 : 7,
                  right: index == cards.length - 1 ? 0 : 7,
                ),
                child: _AnimatedFleetCard(
                  data: cards[index],
                  isMobile: false,
                  index: index,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ============================================================
// ANIMATED FLEET CARD
// ============================================================

class _AnimatedFleetCard extends StatefulWidget {
  final _FleetCardData data;
  final bool isMobile;
  final int index;

  const _AnimatedFleetCard({
    required this.data,
    required this.isMobile,
    required this.index,
  });

  @override
  State<_AnimatedFleetCard> createState() => _AnimatedFleetCardState();
}

class _AnimatedFleetCardState extends State<_AnimatedFleetCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  late final Animation<double> _fade;
  late final Animation<Offset> _slide;

  bool _hovered = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 550 + (widget.index * 100)),
    );

    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic);

    _slide = Tween<Offset>(
      begin: const Offset(0, 0.12),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    Future.delayed(Duration(milliseconds: 180 + (widget.index * 110)), () {
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
    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(
        position: _slide,
        child: MouseRegion(
          cursor: SystemMouseCursors.basic,
          onEnter: (_) {
            if (!widget.isMobile && mounted) {
              setState(() {
                _hovered = true;
              });
            }
          },
          onExit: (_) {
            if (!widget.isMobile && mounted) {
              setState(() {
                _hovered = false;
              });
            }
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 260),
            curve: Curves.easeOutCubic,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: _hovered
                    ? FleetSection.primary.withValues(alpha: 0.20)
                    : const Color(0xFFE5EEF2),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(
                    alpha: _hovered ? 0.09 : 0.035,
                  ),
                  blurRadius: _hovered ? 24 : 15,
                  offset: Offset(0, _hovered ? 13 : 7),
                ),
              ],
            ),
            child: Transform.translate(
              offset: Offset(0, _hovered ? -7 : 0),
              child: _FleetCard(
                data: widget.data,
                isMobile: widget.isMobile,
                hovered: _hovered,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ============================================================
// FLEET CARD
// ============================================================

class _FleetCard extends StatelessWidget {
  final _FleetCardData data;
  final bool isMobile;
  final bool hovered;

  const _FleetCard({
    required this.data,
    required this.isMobile,
    required this.hovered,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ==================================================
          // CARD IMAGE
          // ==================================================

          SizedBox(
            width: double.infinity,
            height: isMobile ? 175 : 155,
            child: Stack(
              fit: StackFit.expand,
              children: [
                AnimatedScale(
                  scale: hovered ? 1.06 : 1.0,
                  duration: const Duration(milliseconds: 550),
                  curve: Curves.easeOutCubic,
                  child: Image.asset(
                    data.image,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: const Color(0xFFEAF8FB),
                        child: Center(
                          child: Icon(
                            data.icon,
                            size: 55,
                            color: FleetSection.primary,
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // =================================================
                // IMAGE OVERLAY
                // =================================================
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.32),
                      ],
                    ),
                  ),
                ),

                // =================================================
                // ICON
                // =================================================
                Positioned(
                  left: 16,
                  bottom: 16,
                  child: Transform.translate(
                    offset: Offset(0, hovered ? -3 : 0),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 220),
                      width: 45,
                      height: 45,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.94),
                        borderRadius: BorderRadius.circular(13),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(
                              alpha: hovered ? 0.15 : 0.08,
                            ),
                            blurRadius: hovered ? 14 : 8,
                          ),
                        ],
                      ),
                      child: AnimatedScale(
                        scale: hovered ? 1.08 : 1.0,
                        duration: const Duration(milliseconds: 220),
                        child: Icon(
                          data.icon,
                          color: FleetSection.primary,
                          size: 22,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ==================================================
          // CARD CONTENT
          // ==================================================
          Padding(
            padding: EdgeInsets.all(isMobile ? 20 : 22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: FleetSection.darkText,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  data.description,
                  maxLines: isMobile ? 4 : 3,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 11.5,
                    height: 1.55,
                    color: FleetSection.bodyText,
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
// FLEET CARD DATA
// ============================================================

class _FleetCardData {
  final IconData icon;
  final String image;
  final String title;
  final String description;

  const _FleetCardData({
    required this.icon,
    required this.image,
    required this.title,
    required this.description,
  });
}
