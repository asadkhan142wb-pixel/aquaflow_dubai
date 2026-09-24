import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../pages/service_detail_page.dart';

class ServicesPage extends StatefulWidget {
  const ServicesPage({super.key});

  @override
  State<ServicesPage> createState() => _ServicesPageState();
}

class _ServicesPageState extends State<ServicesPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  late final Animation<double> _heroFade;
  late final Animation<Offset> _heroSlide;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _heroFade = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.55, curve: Curves.easeOut),
    );

    _heroSlide = Tween<Offset>(begin: const Offset(0, 0.08), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.0, 0.60, curve: Curves.easeOutCubic),
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
    return Scaffold(
      backgroundColor: Colors.white,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;

          final bool isMobile = width < 768;
          final bool isTablet = width >= 768 && width < 1200;

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _TopBar(isMobile: isMobile, isTablet: isTablet),
                _Hero(
                  isMobile: isMobile,
                  isTablet: isTablet,
                  fade: _heroFade,
                  slide: _heroSlide,
                ),
                _ServicesGrid(isMobile: isMobile, isTablet: isTablet),
                _WhyServices(isMobile: isMobile, isTablet: isTablet),
                _BottomCta(isMobile: isMobile, isTablet: isTablet),
                const _Footer(),
              ],
            ),
          );
        },
      ),
    );
  }
}

// ============================================================
// COLORS
// ============================================================

class ServicesColors {
  static const Color primary = Color(0xFF087EA4);
  static const Color darkText = Color(0xFF102A43);
  static const Color bodyText = Color(0xFF52667A);
  static const Color lightBg = Color(0xFFF6FBFD);
}

// ============================================================
// TOP BAR
// ============================================================

class _TopBar extends StatefulWidget {
  final bool isMobile;
  final bool isTablet;

  const _TopBar({required this.isMobile, required this.isTablet});

  @override
  State<_TopBar> createState() => _TopBarState();
}

class _TopBarState extends State<_TopBar> {
  bool _backHovered = false;

  @override
  Widget build(BuildContext context) {
    final horizontalPadding = widget.isMobile
        ? 20.0
        : widget.isTablet
        ? 40.0
        : 70.0;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: widget.isMobile ? 16 : 20,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Row(
        children: [
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: const Duration(milliseconds: 700),
            curve: Curves.easeOutBack,
            builder: (context, value, child) {
              return Transform.scale(
                scale: 0.75 + (value.clamp(0.0, 1.0) * 0.25),
                child: child,
              );
            },
            child: Container(
              width: widget.isMobile ? 42 : 48,
              height: widget.isMobile ? 42 : 48,
              decoration: BoxDecoration(
                color: ServicesColors.primary,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: ServicesColors.primary.withValues(alpha: 0.20),
                    blurRadius: 18,
                    offset: const Offset(0, 7),
                  ),
                ],
              ),
              child: Icon(
                Icons.water_drop_rounded,
                color: Colors.white,
                size: widget.isMobile ? 23 : 27,
              ),
            ),
          ),
          const SizedBox(width: 12),
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: const Duration(milliseconds: 700),
            curve: Curves.easeOutCubic,
            builder: (context, value, child) {
              return Opacity(
                opacity: value.clamp(0.0, 1.0),
                child: Transform.translate(
                  offset: Offset(-12 * (1 - value), 0),
                  child: child,
                ),
              );
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'AquaFlow',
                  style: TextStyle(
                    fontSize: widget.isMobile ? 18 : 21,
                    fontWeight: FontWeight.w800,
                    color: ServicesColors.darkText,
                  ),
                ),
                Text(
                  'DUBAI',
                  style: TextStyle(
                    fontSize: widget.isMobile ? 8 : 9,
                    letterSpacing: 2,
                    fontWeight: FontWeight.w700,
                    color: ServicesColors.primary,
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          MouseRegion(
            cursor: SystemMouseCursors.click,
            onEnter: (_) {
              setState(() {
                _backHovered = true;
              });
            },
            onExit: (_) {
              setState(() {
                _backHovered = false;
              });
            },
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).maybePop();
              },
              child: AnimatedScale(
                scale: _backHovered ? 1.04 : 1.0,
                duration: const Duration(milliseconds: 180),
                curve: Curves.easeOutCubic,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  curve: Curves.easeOutCubic,
                  padding: EdgeInsets.symmetric(
                    horizontal: widget.isMobile ? 8 : 14,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: _backHovered
                        ? ServicesColors.primary.withValues(alpha: 0.08)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AnimatedSlide(
                        offset: _backHovered
                            ? const Offset(-0.08, 0)
                            : Offset.zero,
                        duration: const Duration(milliseconds: 180),
                        child: Icon(
                          Icons.arrow_back_rounded,
                          size: widget.isMobile ? 18 : 20,
                          color: ServicesColors.primary,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        widget.isMobile ? 'Back' : 'Back Home',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: widget.isMobile ? 13 : 14,
                          color: ServicesColors.primary,
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
    );
  }
}

// ============================================================
// HERO
// ============================================================

class _Hero extends StatelessWidget {
  final bool isMobile;
  final bool isTablet;
  final Animation<double> fade;
  final Animation<Offset> slide;

  const _Hero({
    required this.isMobile,
    required this.isTablet,
    required this.fade,
    required this.slide,
  });

  @override
  Widget build(BuildContext context) {
    final horizontalPadding = isMobile
        ? 22.0
        : isTablet
        ? 50.0
        : 100.0;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: isMobile
            ? 60
            : isTablet
            ? 80
            : 105,
      ),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFF0FAFD), Colors.white, Color(0xFFEAF8FC)],
        ),
      ),
      child: FadeTransition(
        opacity: fade,
        child: SlideTransition(
          position: slide,
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1000),
              child: Column(
                children: [
                  TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0.0, end: 1.0),
                    duration: const Duration(milliseconds: 900),
                    curve: Curves.easeOutBack,
                    builder: (context, value, child) {
                      return Transform.scale(
                        scale: 0.85 + (value.clamp(0.0, 1.0) * 0.15),
                        child: child,
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: ServicesColors.primary.withValues(alpha: 0.09),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: const Text(
                        'OUR SERVICES',
                        style: TextStyle(
                          color: ServicesColors.primary,
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Water Delivery Solutions\nAcross Dubai',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: isMobile
                          ? 34
                          : isTablet
                          ? 46
                          : 58,
                      height: 1.08,
                      fontWeight: FontWeight.w800,
                      color: ServicesColors.darkText,
                      letterSpacing: -1.2,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 700),
                    child: Text(
                      'Reliable tanker water supply for homes, businesses, '
                      'construction sites, swimming pools and more.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: isMobile ? 15 : 17,
                        height: 1.7,
                        color: ServicesColors.bodyText,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ============================================================
// SERVICES GRID
// ============================================================

class _ServicesGrid extends StatelessWidget {
  final bool isMobile;
  final bool isTablet;

  const _ServicesGrid({required this.isMobile, required this.isTablet});

  @override
  Widget build(BuildContext context) {
    final horizontalPadding = isMobile
        ? 20.0
        : isTablet
        ? 40.0
        : 70.0;

    final crossAxisCount = isMobile
        ? 1
        : isTablet
        ? 2
        : 4;

    return Container(
      color: Colors.white,
      padding: EdgeInsets.fromLTRB(
        horizontalPadding,
        isMobile ? 55 : 80,
        horizontalPadding,
        isMobile ? 60 : 90,
      ),
      child: Column(
        children: [
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: const Duration(milliseconds: 850),
            curve: Curves.easeOutCubic,
            builder: (context, value, child) {
              return Opacity(
                opacity: value.clamp(0.0, 1.0),
                child: Transform.translate(
                  offset: Offset(0, 18 * (1 - value)),
                  child: child,
                ),
              );
            },
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 850),
              child: Column(
                children: [
                  const Text(
                    'WHAT WE PROVIDE',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      letterSpacing: 1.8,
                      fontWeight: FontWeight.w800,
                      color: ServicesColors.primary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Services Built Around Your Needs',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: isMobile
                          ? 29
                          : isTablet
                          ? 36
                          : 42,
                      fontWeight: FontWeight.w800,
                      color: ServicesColors.darkText,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    'Flexible water delivery solutions for different '
                    'properties and project requirements.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: isMobile ? 14 : 16,
                      height: 1.6,
                      color: ServicesColors.bodyText,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: isMobile ? 40 : 55),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _ServiceData.items.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: isMobile ? 0 : 22,
              mainAxisSpacing: isMobile ? 20 : 22,
              mainAxisExtent: isMobile
                  ? 385
                  : isTablet
                  ? 375
                  : 365,
            ),
            itemBuilder: (context, index) {
              final service = _ServiceData.items[index];

              return _ServiceCard(service: service, index: index);
            },
          ),
        ],
      ),
    );
  }
}

// ============================================================
// SERVICE CARD
// ============================================================

class _ServiceCard extends StatefulWidget {
  final _ServiceItem service;
  final int index;

  const _ServiceCard({required this.service, required this.index});

  @override
  State<_ServiceCard> createState() => _ServiceCardState();
}

class _ServiceCardState extends State<_ServiceCard> {
  bool _hovered = false;

  void _openServiceDetails(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ServiceDetailPage(
          title: widget.service.title,
          description: widget.service.description,
          image: widget.service.image,
          icon: widget.service.icon,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 550 + (widget.index * 80)),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        final progress = value.clamp(0.0, 1.0);

        return Opacity(
          opacity: progress,
          child: Transform.translate(
            offset: Offset(0, 25 * (1 - progress)),
            child: child,
          ),
        );
      },
      child: MouseRegion(
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
        child: GestureDetector(
          onTap: () => _openServiceDetails(context),
          child: AnimatedScale(
            scale: _hovered ? 1.015 : 1.0,
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOutCubic,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                AnimatedOpacity(
                  opacity: _hovered ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 220),
                  curve: Curves.easeOutCubic,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(22),
                      boxShadow: [
                        BoxShadow(
                          color: ServicesColors.primary.withValues(alpha: 0.16),
                          blurRadius: 28,
                          offset: const Offset(0, 14),
                        ),
                      ],
                    ),
                  ),
                ),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 220),
                  curve: Curves.easeOutCubic,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(
                      color: _hovered
                          ? ServicesColors.primary.withValues(alpha: 0.30)
                          : const Color(0xFFE7EEF2),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(
                          alpha: _hovered ? 0.065 : 0.045,
                        ),
                        blurRadius: _hovered ? 24 : 18,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(
                        height: 165,
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            AnimatedScale(
                              scale: _hovered ? 1.045 : 1.0,
                              duration: const Duration(milliseconds: 350),
                              curve: Curves.easeOutCubic,
                              child: Image.asset(
                                widget.service.image,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    color: const Color(0xFFEAF7FA),
                                    child: Icon(
                                      widget.service.icon,
                                      size: 52,
                                      color: ServicesColors.primary,
                                    ),
                                  );
                                },
                              ),
                            ),

                            DecoratedBox(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.black.withValues(alpha: 0.03),
                                    Colors.black.withValues(alpha: 0.52),
                                  ],
                                ),
                              ),
                            ),

                            Positioned(
                              left: 16,
                              bottom: 14,
                              child: AnimatedSlide(
                                offset: _hovered
                                    ? const Offset(0.03, 0)
                                    : Offset.zero,
                                duration: const Duration(milliseconds: 220),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.94),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    widget.service.category,
                                    style: const TextStyle(
                                      color: ServicesColors.primary,
                                      fontSize: 9,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: 1.1,
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            Positioned(
                              top: 14,
                              right: 14,
                              child: AnimatedScale(
                                scale: _hovered ? 1.08 : 1.0,
                                duration: const Duration(milliseconds: 220),
                                curve: Curves.easeOutBack,
                                child: Container(
                                  width: 42,
                                  height: 42,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.95),
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(
                                          alpha: 0.08,
                                        ),
                                        blurRadius: 12,
                                      ),
                                    ],
                                  ),
                                  child: Icon(
                                    widget.service.icon,
                                    color: ServicesColors.primary,
                                    size: 21,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(18, 17, 18, 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.service.title,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                  color: ServicesColors.darkText,
                                ),
                              ),
                              const SizedBox(height: 9),
                              Expanded(
                                child: Text(
                                  widget.service.description,
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    height: 1.55,
                                    color: ServicesColors.bodyText,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              _LearnMoreButton(
                                hovered: _hovered,
                                onTap: () => _openServiceDetails(context),
                              ),
                            ],
                          ),
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
    );
  }
}

// ============================================================
// LEARN MORE BUTTON
// ============================================================

class _LearnMoreButton extends StatelessWidget {
  final bool hovered;
  final VoidCallback onTap;

  const _LearnMoreButton({required this.hovered, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 180),
            style: TextStyle(
              color: ServicesColors.primary,
              fontSize: 13,
              fontWeight: hovered ? FontWeight.w900 : FontWeight.w800,
            ),
            child: const Text('Learn More'),
          ),
          const SizedBox(width: 6),
          AnimatedSlide(
            offset: hovered ? const Offset(0.20, 0) : Offset.zero,
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOutCubic,
            child: const Icon(
              Icons.arrow_forward_rounded,
              size: 17,
              color: ServicesColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// SERVICE DATA
// ============================================================

class _ServiceItem {
  final String title;
  final String description;
  final String image;
  final String category;
  final IconData icon;

  const _ServiceItem({
    required this.title,
    required this.description,
    required this.image,
    required this.category,
    required this.icon,
  });
}

class _ServiceData {
  static const List<_ServiceItem> items = [
    _ServiceItem(
      title: 'Sweet Water Supply',
      description:
          'Fresh and reliable sweet water delivery for homes, '
          'businesses and daily requirements.',
      image: 'assets/images/services/sweet-water.jpg',
      category: 'SWEET WATER',
      icon: Icons.water_drop_rounded,
    ),
    _ServiceItem(
      title: 'Swimming Pool Water',
      description:
          'Clean water delivery for swimming pools, villas, '
          'hotels and recreational facilities.',
      image: 'assets/images/services/pool-water.jpg',
      category: 'POOL WATER',
      icon: Icons.pool_rounded,
    ),
    _ServiceItem(
      title: 'Residential Supply',
      description:
          'Convenient water tanker delivery for villas, '
          'apartments and residential properties.',
      image: 'assets/images/services/residential.jpg',
      category: 'RESIDENTIAL',
      icon: Icons.home_rounded,
    ),
    _ServiceItem(
      title: 'Commercial Supply',
      description:
          'Dependable water supply for offices, shops, '
          'warehouses, hotels and commercial facilities.',
      image: 'assets/images/services/commercial.jpg',
      category: 'COMMERCIAL',
      icon: Icons.business_rounded,
    ),
    _ServiceItem(
      title: 'Construction Water',
      description:
          'Water tanker solutions for construction sites, '
          'infrastructure projects and building works.',
      image: 'assets/images/services/construction.jpg',
      category: 'CONSTRUCTION',
      icon: Icons.construction_rounded,
    ),
    _ServiceItem(
      title: 'Garden & Nursery',
      description:
          'Water delivery for gardens, landscaping projects, '
          'nurseries and outdoor spaces.',
      image: 'assets/images/services/garden.jpg',
      category: 'GARDEN & NURSERY',
      icon: Icons.local_florist_rounded,
    ),
    _ServiceItem(
      title: 'Wastewater Removal',
      description:
          'Professional wastewater and drainage support for '
          'properties and project sites.',
      image: 'assets/images/services/wastewater.jpg',
      category: 'WASTEWATER',
      icon: Icons.cleaning_services_rounded,
    ),
    _ServiceItem(
      title: 'Emergency Delivery',
      description:
          'Fast water delivery support when you need an '
          'urgent and dependable supply.',
      image: 'assets/images/services/emergency.jpg',
      category: 'EMERGENCY',
      icon: Icons.local_shipping_rounded,
    ),
  ];
}

// ============================================================
// WHY AQUAFLOW
// ============================================================

class _WhyServices extends StatelessWidget {
  final bool isMobile;
  final bool isTablet;

  const _WhyServices({required this.isMobile, required this.isTablet});

  @override
  Widget build(BuildContext context) {
    final horizontalPadding = isMobile
        ? 22.0
        : isTablet
        ? 50.0
        : 100.0;

    const benefits = [
      _BenefitItem(
        icon: Icons.schedule_rounded,
        title: 'On-Time Delivery',
        description: 'We focus on dependable delivery scheduling.',
      ),
      _BenefitItem(
        icon: Icons.verified_rounded,
        title: 'Quality Service',
        description: 'Professional service from request to delivery.',
      ),
      _BenefitItem(
        icon: Icons.location_on_rounded,
        title: 'Dubai Coverage',
        description: 'Serving residential and commercial areas across Dubai.',
      ),
      _BenefitItem(
        icon: Icons.support_agent_rounded,
        title: 'Customer Support',
        description: 'Friendly assistance whenever you need it.',
      ),
    ];

    return Container(
      color: ServicesColors.lightBg,
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: isMobile ? 60 : 85,
      ),
      child: Column(
        children: [
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeOutCubic,
            builder: (context, value, child) {
              return Opacity(
                opacity: value.clamp(0.0, 1.0),
                child: Transform.translate(
                  offset: Offset(0, 18 * (1 - value)),
                  child: child,
                ),
              );
            },
            child: Column(
              children: [
                const Text(
                  'WHY AQUAFLOW',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    letterSpacing: 1.8,
                    fontWeight: FontWeight.w800,
                    color: ServicesColors.primary,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'A Better Water Delivery Experience',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: isMobile
                        ? 28
                        : isTablet
                        ? 35
                        : 42,
                    fontWeight: FontWeight.w800,
                    color: ServicesColors.darkText,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 45),
          LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth;

              final crossAxisCount = width < 700
                  ? 1
                  : width < 1050
                  ? 2
                  : 4;

              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: benefits.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                  mainAxisExtent: 190,
                ),
                itemBuilder: (context, index) {
                  return _BenefitCard(item: benefits[index], index: index);
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

// ============================================================
// BENEFIT ITEM
// ============================================================

class _BenefitItem {
  final IconData icon;
  final String title;
  final String description;

  const _BenefitItem({
    required this.icon,
    required this.title,
    required this.description,
  });
}

// ============================================================
// BENEFIT CARD
// ============================================================

class _BenefitCard extends StatefulWidget {
  final _BenefitItem item;
  final int index;

  const _BenefitCard({required this.item, required this.index});

  @override
  State<_BenefitCard> createState() => _BenefitCardState();
}

class _BenefitCardState extends State<_BenefitCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 600 + (widget.index * 100)),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        final progress = value.clamp(0.0, 1.0);

        return Opacity(
          opacity: progress,
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - progress)),
            child: child,
          ),
        );
      },
      child: MouseRegion(
        cursor: SystemMouseCursors.basic,
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
          scale: _hovered ? 1.025 : 1.0,
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOutCubic,
          child: Stack(
            children: [
              AnimatedOpacity(
                opacity: _hovered ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 220),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: ServicesColors.primary.withValues(alpha: 0.13),
                        blurRadius: 25,
                        offset: const Offset(0, 12),
                      ),
                    ],
                  ),
                ),
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeOutCubic,
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: _hovered
                        ? ServicesColors.primary.withValues(alpha: 0.25)
                        : const Color(0xFFE5EEF2),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(
                        alpha: _hovered ? 0.055 : 0.035,
                      ),
                      blurRadius: _hovered ? 22 : 18,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AnimatedScale(
                      scale: _hovered ? 1.08 : 1.0,
                      duration: const Duration(milliseconds: 220),
                      curve: Curves.easeOutBack,
                      child: Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: ServicesColors.primary.withValues(alpha: 0.10),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Icon(
                          widget.item.icon,
                          color: ServicesColors.primary,
                          size: 24,
                        ),
                      ),
                    ),
                    const SizedBox(height: 17),
                    Text(
                      widget.item.title,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        color: ServicesColors.darkText,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: Text(
                        widget.item.description,
                        style: const TextStyle(
                          fontSize: 13,
                          height: 1.55,
                          color: ServicesColors.bodyText,
                        ),
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
// BOTTOM CTA
// ============================================================

class _BottomCta extends StatelessWidget {
  final bool isMobile;
  final bool isTablet;

  const _BottomCta({required this.isMobile, required this.isTablet});

  @override
  Widget build(BuildContext context) {
    final horizontalPadding = isMobile
        ? 22.0
        : isTablet
        ? 50.0
        : 100.0;

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 900),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        final progress = value.clamp(0.0, 1.0);

        return Opacity(
          opacity: progress,
          child: Transform.translate(
            offset: Offset(0, 25 * (1 - progress)),
            child: child,
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: horizontalPadding,
          vertical: isMobile ? 50 : 75,
        ),
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 25 : 55,
          vertical: isMobile ? 35 : 45,
        ),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF087EA4), Color(0xFF075E7C)],
          ),
          borderRadius: BorderRadius.circular(26),
          boxShadow: [
            BoxShadow(
              color: ServicesColors.primary.withValues(alpha: 0.18),
              blurRadius: 28,
              offset: const Offset(0, 14),
            ),
          ],
        ),
        child: isMobile
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _CtaText(isMobile: isMobile),
                  const SizedBox(height: 25),
                  const _CtaButton(),
                ],
              )
            : Row(
                children: [
                  Expanded(child: _CtaText(isMobile: isMobile)),
                  const SizedBox(width: 30),
                  const _CtaButton(),
                ],
              ),
      ),
    );
  }
}

// ============================================================
// CTA TEXT
// ============================================================

class _CtaText extends StatelessWidget {
  final bool isMobile;

  const _CtaText({required this.isMobile});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Need Water Delivered?',
          style: TextStyle(
            color: Colors.white,
            fontSize: isMobile ? 25 : 32,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          'Tell us what you need and our team will help arrange your water delivery.',
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.86),
            fontSize: isMobile ? 14 : 15,
            height: 1.6,
          ),
        ),
      ],
    );
  }
}

// ============================================================
// CTA BUTTON
// ============================================================

class _CtaButton extends StatefulWidget {
  const _CtaButton();

  @override
  State<_CtaButton> createState() => _CtaButtonState();
}

class _CtaButtonState extends State<_CtaButton> {
  bool _hovered = false;
  bool _pressed = false;

  static const String whatsappNumber = '923104939138';

  Future<void> _openWhatsApp() async {
    final message = Uri.encodeComponent(
      'Hello AquaFlow Dubai,\n\n'
      'I would like to request a water delivery quote.\n\n'
      'Please share the available services, pricing and delivery details.',
    );

    final uri = Uri.parse('https://wa.me/$whatsappNumber?text=$message');

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
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
          _pressed = false;
        });
      },
      child: GestureDetector(
        onTapDown: (_) {
          setState(() {
            _pressed = true;
          });
        },
        onTapUp: (_) {
          setState(() {
            _pressed = false;
          });
        },
        onTapCancel: () {
          setState(() {
            _pressed = false;
          });
        },
        onTap: _openWhatsApp,
        child: AnimatedScale(
          scale: _pressed
              ? 0.96
              : _hovered
              ? 1.04
              : 1.0,
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOutCubic,
          child: Stack(
            alignment: Alignment.center,
            children: [
              AnimatedOpacity(
                opacity: _hovered ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 200),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white.withValues(alpha: 0.22),
                        blurRadius: 22,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                ),
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                curve: Curves.easeOutCubic,
                padding: const EdgeInsets.symmetric(
                  horizontal: 25,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  color: _hovered ? const Color(0xFFF8FDFF) : Colors.white,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Request a Quote',
                      style: TextStyle(
                        color: ServicesColors.primary,
                        fontWeight: FontWeight.w800,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(width: 8),
                    AnimatedSlide(
                      offset: _hovered ? const Offset(0.18, 0) : Offset.zero,
                      duration: const Duration(milliseconds: 180),
                      child: const Icon(
                        Icons.arrow_forward_rounded,
                        size: 18,
                        color: ServicesColors.primary,
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
// FOOTER
// ============================================================

class _Footer extends StatelessWidget {
  const _Footer();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
      decoration: const BoxDecoration(color: Color(0xFF0D2535)),
      child: const Center(
        child: Text(
          '© 2026 AquaFlow Dubai. Reliable Water Delivery.',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white70, fontSize: 13),
        ),
      ),
    );
  }
}
