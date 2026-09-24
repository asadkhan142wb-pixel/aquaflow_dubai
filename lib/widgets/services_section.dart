import 'package:flutter/material.dart';

import '../screens/services_page.dart';

class ServicesSection extends StatefulWidget {
  const ServicesSection({super.key});

  static const Color primary = Color(0xFF087EA4);
  static const Color darkText = Color(0xFF102A43);
  static const Color bodyText = Color(0xFF52667A);
  static const Color lightBg = Color(0xFFF6FBFD);

  @override
  State<ServicesSection> createState() => _ServicesSectionState();
}

class _ServicesSectionState extends State<ServicesSection>
    with TickerProviderStateMixin {
  late final AnimationController _controller;
  late final AnimationController _backgroundController;

  late final Animation<double> _headerFade;
  late final Animation<Offset> _headerSlide;

  late final Animation<double> _gridFade;
  late final Animation<Offset> _gridSlide;

  late final Animation<double> _buttonFade;
  late final Animation<Offset> _buttonSlide;

  late final Animation<double> _backgroundPulse;

  @override
  void initState() {
    super.initState();

    // ==========================================================
    // MAIN SECTION ANIMATION
    // ==========================================================

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _headerFade = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.30, curve: Curves.easeOutCubic),
    );

    _headerSlide = Tween<Offset>(begin: const Offset(0, 0.18), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.0, 0.30, curve: Curves.easeOutCubic),
          ),
        );

    _gridFade = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.18, 0.75, curve: Curves.easeOutCubic),
    );

    _gridSlide = Tween<Offset>(begin: const Offset(0, 0.10), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.18, 0.75, curve: Curves.easeOutCubic),
          ),
        );

    _buttonFade = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.65, 1.0, curve: Curves.easeOutCubic),
    );

    _buttonSlide = Tween<Offset>(begin: const Offset(0, 0.12), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.65, 1.0, curve: Curves.easeOutCubic),
          ),
        );

    // ==========================================================
    // BACKGROUND ANIMATION
    // ==========================================================

    _backgroundController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 5000),
    )..repeat(reverse: true);

    _backgroundPulse = Tween<double>(begin: 0.85, end: 1.15).animate(
      CurvedAnimation(parent: _backgroundController, curve: Curves.easeInOut),
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
    _backgroundController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double width = constraints.maxWidth;

        final bool isMobile = width < 768;
        final bool isTablet = width >= 768 && width < 1200;
        final bool isDesktop = width >= 1200;

        final double horizontalPadding = isMobile
            ? 20
            : isTablet
            ? 30
            : 50;

        final double verticalPadding = isMobile ? 65 : 95;

        const services = [
          _ServiceData(
            title: 'Sweet Water Supply',
            description: 'Fresh and clean sweet water delivered to homes, villas and properties across Dubai.',
            icon: Icons.water_drop_rounded,
            image: 'assets/images/services/sweet-water.jpg',
          ),
          _ServiceData(
            title: 'Swimming Pool Water',
            description: 'Reliable water delivery for swimming pools, villas, hotels and recreational facilities.',
            icon: Icons.pool_rounded,
            image: 'assets/images/services/pool-water.jpg',
          ),
          _ServiceData(
            title: 'Residential Supply',
            description: 'Convenient water tanker delivery for homes, villas and residential communities.',
            icon: Icons.home_rounded,
            image: 'assets/images/services/residential.jpg',
          ),
          _ServiceData(
            title: 'Commercial Supply',
            description: 'Professional water supply solutions for offices, businesses, hotels and commercial properties.',
            icon: Icons.business_rounded,
            image: 'assets/images/services/commercial.jpg',
          ),
          _ServiceData(
            title: 'Construction Water',
            description: 'Dependable water supply for construction sites, projects and building operations.',
            icon: Icons.construction_rounded,
            image: 'assets/images/services/construction.jpg',
          ),
          _ServiceData(
            title: 'Garden & Nursery',
            description: 'Fresh water delivery for gardens, nurseries, landscaping projects and green spaces.',
            icon: Icons.local_florist_rounded,
            image: 'assets/images/services/garden.jpg',
          ),
        ];

        return Container(
          width: double.infinity,
          color: ServicesSection.lightBg,
          child: Stack(
            children: [
              // ==================================================
              // DECORATIVE BACKGROUND CIRCLE
              // ==================================================

              AnimatedBuilder(
                animation: _backgroundPulse,
                builder: (context, child) {
                  return Positioned(
                    right: -150,
                    top: -170,
                    child: Transform.scale(
                      scale: _backgroundPulse.value,
                      child: Container(
                        width: 420,
                        height: 420,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: ServicesSection.primary.withValues(
                            alpha: 0.035,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),

              // ==================================================
              // SECOND BACKGROUND CIRCLE
              // ==================================================
              AnimatedBuilder(
                animation: _backgroundPulse,
                builder: (context, child) {
                  final double scale =
                      1.08 - ((_backgroundPulse.value - 0.85) * 0.35);

                  return Positioned(
                    left: -190,
                    bottom: -190,
                    child: Transform.scale(
                      scale: scale,
                      child: Container(
                        width: 450,
                        height: 450,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFF18A6C8)
                              .withValues(alpha: 0.025),
                        ),
                      ),
                    ),
                  );
                },
              ),

              // ==================================================
              // MAIN CONTENT
              // ==================================================
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: horizontalPadding,
                  vertical: verticalPadding,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // ==================================================
                    // HEADER
                    // ==================================================

                    FadeTransition(
                      opacity: _headerFade,
                      child: SlideTransition(
                        position: _headerSlide,
                        child: _SectionHeader(isMobile: isMobile),
                      ),
                    ),

                    SizedBox(
                      height: isMobile
                          ? 38
                          : isTablet
                          ? 45
                          : 55,
                    ),

                    // ==================================================
                    // SERVICES GRID
                    // ==================================================
                    FadeTransition(
                      opacity: _gridFade,
                      child: SlideTransition(
                        position: _gridSlide,
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 1180),
                          child: _ServicesGrid(
                            services: services,
                            isMobile: isMobile,
                            isTablet: isTablet,
                            isDesktop: isDesktop,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: isMobile ? 32 : 45),

                    // ==================================================
                    // VIEW ALL BUTTON
                    // ==================================================
                    FadeTransition(
                      opacity: _buttonFade,
                      child: SlideTransition(
                        position: _buttonSlide,
                        child: _AnimatedServicesButton(isMobile: isMobile),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ================================================================
// VIEW ALL SERVICES BUTTON
// ================================================================

class _AnimatedServicesButton extends StatefulWidget {
  final bool isMobile;

  const _AnimatedServicesButton({required this.isMobile});

  @override
  State<_AnimatedServicesButton> createState() =>
      _AnimatedServicesButtonState();
}

class _AnimatedServicesButtonState extends State<_AnimatedServicesButton> {
  bool _hovered = false;

  void _openServicesPage() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => const ServicesPage()));
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) {
        setState(() {
          _hovered = true;
        });
      },
      onExit: (_) {
        setState(() {
          _hovered = false;
        });
      },
      child: AnimatedScale(
        scale: _hovered ? 1.04 : 1.0,
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOutCubic,
          transform: Matrix4.translationValues(0, _hovered ? -3 : 0, 0),
          child: OutlinedButton.icon(
            onPressed: _openServicesPage,
            icon: AnimatedSlide(
              offset: _hovered ? const Offset(0.12, 0) : Offset.zero,
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeOut,
              child: const Icon(Icons.arrow_forward_rounded, size: 19),
            ),
            label: const Text('View All Services'),
            style: OutlinedButton.styleFrom(
              foregroundColor: ServicesSection.primary,
              backgroundColor: _hovered
                  ? ServicesSection.primary.withValues(alpha: 0.05)
                  : Colors.transparent,
              side: BorderSide(
                color: ServicesSection.primary,
                width: _hovered ? 2 : 1.5,
              ),
              padding: EdgeInsets.symmetric(
                horizontal: widget.isMobile ? 20 : 24,
                vertical: 15,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ================================================================
// SERVICES GRID
// ================================================================

class _ServicesGrid extends StatelessWidget {
  final List<_ServiceData> services;
  final bool isMobile;
  final bool isTablet;
  final bool isDesktop;

  const _ServicesGrid({
    required this.services,
    required this.isMobile,
    required this.isTablet,
    required this.isDesktop,
  });

  @override
  Widget build(BuildContext context) {
    // ==========================================================
    // MOBILE
    // ==========================================================

    if (isMobile) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (int index = 0; index < services.length; index++)
            Padding(
              padding: EdgeInsets.only(
                bottom: index == services.length - 1 ? 0 : 18,
              ),
              child: _AnimatedServiceCard(
                data: services[index],
                isMobile: true,
                index: index,
              ),
            ),
        ],
      );
    }

    // ==========================================================
    // TABLET
    // ==========================================================

    if (isTablet) {
      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: services.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
          mainAxisExtent: 370,
        ),
        itemBuilder: (context, index) {
          return _AnimatedServiceCard(
            data: services[index],
            isMobile: false,
            index: index,
          );
        },
      );
    }

    // ==========================================================
    // DESKTOP
    // ==========================================================

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: services.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
        mainAxisExtent: 360,
      ),
      itemBuilder: (context, index) {
        return _AnimatedServiceCard(
          data: services[index],
          isMobile: false,
          index: index,
        );
      },
    );
  }
}

// ================================================================
// ANIMATED SERVICE CARD
// ================================================================

class _AnimatedServiceCard extends StatefulWidget {
  final _ServiceData data;
  final bool isMobile;
  final int index;

  const _AnimatedServiceCard({
    required this.data,
    required this.isMobile,
    required this.index,
  });

  @override
  State<_AnimatedServiceCard> createState() => _AnimatedServiceCardState();
}

class _AnimatedServiceCardState extends State<_AnimatedServiceCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;

  bool _hovered = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 550 + (widget.index * 90)),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.12),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    Future.delayed(Duration(milliseconds: 180 + (widget.index * 100)), () {
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

  void _openServicesPage(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => const ServicesPage()));
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          onEnter: (_) {
            if (!widget.isMobile) {
              setState(() {
                _hovered = true;
              });
            }
          },
          onExit: (_) {
            if (!widget.isMobile) {
              setState(() {
                _hovered = false;
              });
            }
          },
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => _openServicesPage(context),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 280),
              curve: Curves.easeOutCubic,
              transform: Matrix4.translationValues(0, _hovered ? -8 : 0, 0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(
                      alpha: _hovered ? 0.10 : 0.045,
                    ),
                    blurRadius: _hovered ? 28 : 18,
                    offset: Offset(0, _hovered ? 14 : 8),
                  ),
                ],
              ),
              child: _ServiceCard(
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

// ================================================================
// SECTION HEADER
// ================================================================

class _SectionHeader extends StatelessWidget {
  final bool isMobile;

  const _SectionHeader({required this.isMobile});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // ========================================================
        // BADGE
        // ========================================================

        TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: 1.0),
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeOutBack,
          builder: (context, value, child) {
            return Transform.scale(
              scale: 0.90 + (value * 0.10),
              child: Opacity(opacity: value.clamp(0.0, 1.0), child: child),
            );
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
            decoration: BoxDecoration(
              color: ServicesSection.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: ServicesSection.primary.withValues(alpha: 0.15),
              ),
            ),
            child: const Text(
              'OUR SERVICES',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.4,
                color: ServicesSection.primary,
              ),
            ),
          ),
        ),

        const SizedBox(height: 16),

        // ========================================================
        // TITLE
        // ========================================================
        Padding(
          padding: EdgeInsets.symmetric(horizontal: isMobile ? 5 : 20),
          child: Text(
            'Water Delivery Solutions',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: isMobile ? 32 : 44,
              height: 1.1,
              fontWeight: FontWeight.w800,
              letterSpacing: -1,
              color: ServicesSection.darkText,
            ),
          ),
        ),

        const SizedBox(height: 12),

        // ========================================================
        // DESCRIPTION
        // ========================================================
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 680),
          child: Text(
            'Reliable water supply for homes, businesses, pools and '
            'construction sites across Dubai.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: isMobile ? 14 : 16,
              height: 1.6,
              color: ServicesSection.bodyText,
            ),
          ),
        ),
      ],
    );
  }
}

// ================================================================
// SERVICE DATA
// ================================================================

class _ServiceData {
  final String title;
  final String description;
  final IconData icon;
  final String image;

  const _ServiceData({
    required this.title,
    required this.description,
    required this.icon,
    required this.image,
  });
}

// ================================================================
// SERVICE CARD
// ================================================================

class _ServiceCard extends StatelessWidget {
  final _ServiceData data;
  final bool isMobile;
  final bool hovered;

  const _ServiceCard({
    required this.data,
    required this.isMobile,
    required this.hovered,
  });

  @override
  Widget build(BuildContext context) {
    final double imageHeight = isMobile ? 195 : 185;
    final double cardHeight = isMobile ? 370 : 360;

    return Container(
      height: cardHeight,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: hovered
              ? ServicesSection.primary.withValues(alpha: 0.22)
              : const Color(0xFFE2EDF1),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ==================================================
            // IMAGE
            // ==================================================

            SizedBox(
              height: imageHeight,
              width: double.infinity,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // ==================================================
                  // IMAGE
                  // ==================================================

                  AnimatedScale(
                    scale: hovered ? 1.055 : 1.0,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeOutCubic,
                    child: Image.asset(
                      data.image,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: const Color(0xFFEAF7FA),
                          alignment: Alignment.center,
                          child: Icon(
                            data.icon,
                            size: 65,
                            color: ServicesSection.primary,
                          ),
                        );
                      },
                    ),
                  ),

                  // ==================================================
                  // IMAGE GRADIENT
                  // ==================================================
                  Positioned.fill(
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withValues(
                              alpha: hovered ? 0.50 : 0.42,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // ==================================================
                  // ICON
                  // ==================================================
                  Positioned(
                    left: 16,
                    top: 16,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 220),
                      width: 44,
                      height: 44,
                      transform: Matrix4.translationValues(
                        0,
                        hovered ? -3 : 0,
                        0,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(
                          alpha: hovered ? 1.0 : 0.94,
                        ),
                        borderRadius: BorderRadius.circular(13),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(
                              alpha: hovered ? 0.17 : 0.12,
                            ),
                            blurRadius: hovered ? 16 : 12,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: AnimatedScale(
                        scale: hovered ? 1.10 : 1.0,
                        duration: const Duration(milliseconds: 220),
                        child: Icon(
                          data.icon,
                          color: ServicesSection.primary,
                          size: 22,
                        ),
                      ),
                    ),
                  ),

                  // ==================================================
                  // TITLE
                  // ==================================================
                  Positioned(
                    left: 18,
                    right: 18,
                    bottom: 16,
                    child: AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 220),
                      curve: Curves.easeOut,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: hovered ? 20.5 : 20,
                        height: 1.2,
                        fontWeight: FontWeight.w800,
                        shadows: const [
                          Shadow(
                            blurRadius: 0,
                            offset: Offset(0, 2),
                            color: Colors.black45,
                          ),
                        ],
                      ),
                      child: Text(
                        data.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ==================================================
            // CONTENT
            // ==================================================
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(18, 17, 18, 18),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ==================================================
                    // DESCRIPTION
                    // ==================================================

                    Text(
                      data.description,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        height: 1.55,
                        color: ServicesSection.bodyText,
                      ),
                    ),

                    const Spacer(),

                    // ==================================================
                    // LEARN MORE
                    // ==================================================
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 220),
                      transform: Matrix4.translationValues(
                        hovered ? 4 : 0,
                        0,
                        0,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          AnimatedDefaultTextStyle(
                            duration: const Duration(milliseconds: 220),
                            style: TextStyle(
                              fontSize: hovered ? 13.5 : 13,
                              fontWeight: FontWeight.w800,
                              color: ServicesSection.primary,
                            ),
                            child: const Text('Learn More'),
                          ),
                          const SizedBox(width: 6),
                          AnimatedSlide(
                            offset: hovered
                                ? const Offset(0.20, 0)
                                : Offset.zero,
                            duration: const Duration(milliseconds: 220),
                            curve: Curves.easeOut,
                            child: const Icon(
                              Icons.arrow_forward_rounded,
                              size: 17,
                              color: ServicesSection.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
