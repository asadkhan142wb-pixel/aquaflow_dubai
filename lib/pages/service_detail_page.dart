import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

// ============================================================
// COLORS
// ============================================================

const Color primary = Color(0xFF087EA4);
const Color darkText = Color(0xFF102A43);
const Color bodyText = Color(0xFF52667A);
const Color lightBg = Color(0xFFF6FBFD);

// ============================================================
// SERVICE DETAIL PAGE
// ============================================================

class ServiceDetailPage extends StatefulWidget {
  final String title;
  final String description;
  final String image;
  final IconData icon;

  const ServiceDetailPage({
    super.key,
    required this.title,
    required this.description,
    required this.image,
    required this.icon,
  });

  @override
  State<ServiceDetailPage> createState() => _ServiceDetailPageState();
}

class _ServiceDetailPageState extends State<ServiceDetailPage>
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
      curve: const Interval(0.0, 0.65, curve: Curves.easeOut),
    );

    _heroSlide = Tween<Offset>(begin: const Offset(0, 0.07), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.0, 0.65, curve: Curves.easeOutCubic),
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
              children: [
                _TopBar(isMobile: isMobile, isTablet: isTablet),
                _HeroSection(
                  title: widget.title,
                  description: widget.description,
                  image: widget.image,
                  icon: widget.icon,
                  isMobile: isMobile,
                  isTablet: isTablet,
                  fade: _heroFade,
                  slide: _heroSlide,
                ),
                _ServiceInformation(
                  title: widget.title,
                  isMobile: isMobile,
                  isTablet: isTablet,
                ),
                _QuoteSection(
                  serviceTitle: widget.title,
                  isMobile: isMobile,
                  isTablet: isTablet,
                ),
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
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: widget.isMobile ? 15 : 18,
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
              final progress = value.clamp(0.0, 1.0);

              return Transform.scale(
                scale: 0.75 + (progress * 0.25),
                child: child,
              );
            },
            child: Container(
              width: widget.isMobile ? 42 : 46,
              height: widget.isMobile ? 42 : 46,
              decoration: BoxDecoration(
                color: primary,
                borderRadius: BorderRadius.circular(13),
                boxShadow: [
                  BoxShadow(
                    color: primary.withValues(alpha: 0.20),
                    blurRadius: 18,
                    offset: const Offset(0, 7),
                  ),
                ],
              ),
              child: Icon(
                Icons.water_drop_rounded,
                color: Colors.white,
                size: widget.isMobile ? 23 : 25,
              ),
            ),
          ),
          const SizedBox(width: 12),
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: const Duration(milliseconds: 700),
            curve: Curves.easeOutCubic,
            builder: (context, value, child) {
              final progress = value.clamp(0.0, 1.0);

              return Opacity(
                opacity: progress,
                child: Transform.translate(
                  offset: Offset(-12 * (1 - progress), 0),
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
                    fontSize: widget.isMobile ? 18 : 20,
                    fontWeight: FontWeight.w800,
                    color: darkText,
                  ),
                ),
                const Text(
                  'DUBAI',
                  style: TextStyle(
                    fontSize: 9,
                    letterSpacing: 2,
                    fontWeight: FontWeight.w800,
                    color: primary,
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
                        ? primary.withValues(alpha: 0.08)
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
                          size: widget.isMobile ? 19 : 20,
                          color: primary,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        widget.isMobile ? 'Back' : 'Back to Services',
                        style: TextStyle(
                          color: primary,
                          fontWeight: FontWeight.w700,
                          fontSize: widget.isMobile ? 13 : 14,
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
// HERO SECTION
// ============================================================

class _HeroSection extends StatelessWidget {
  final String title;
  final String description;
  final String image;
  final IconData icon;
  final bool isMobile;
  final bool isTablet;
  final Animation<double> fade;
  final Animation<Offset> slide;

  const _HeroSection({
    required this.title,
    required this.description,
    required this.image,
    required this.icon,
    required this.isMobile,
    required this.isTablet,
    required this.fade,
    required this.slide,
  });

  @override
  Widget build(BuildContext context) {
    final horizontalPadding = isMobile
        ? 20.0
        : isTablet
        ? 40.0
        : 70.0;

    return Container(
      width: double.infinity,
      color: lightBg,
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: isMobile ? 45 : 70,
      ),
      child: FadeTransition(
        opacity: fade,
        child: SlideTransition(
          position: slide,
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1180),
              child: isMobile
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _HeroImage(image: image, icon: icon, height: 280),
                        const SizedBox(height: 30),
                        _HeroText(
                          title: title,
                          description: description,
                          isMobile: true,
                        ),
                      ],
                    )
                  : Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: _HeroText(
                            title: title,
                            description: description,
                            isMobile: false,
                          ),
                        ),
                        const SizedBox(width: 55),
                        Expanded(
                          child: _HeroImage(
                            image: image,
                            icon: icon,
                            height: isTablet ? 360 : 430,
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
// HERO IMAGE
// ============================================================

class _HeroImage extends StatefulWidget {
  final String image;
  final IconData icon;
  final double height;

  const _HeroImage({
    required this.image,
    required this.icon,
    required this.height,
  });

  @override
  State<_HeroImage> createState() => _HeroImageState();
}

class _HeroImageState extends State<_HeroImage> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
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
        scale: _hovered ? 1.015 : 1.0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
        child: Stack(
          children: [
            AnimatedOpacity(
              opacity: _hovered ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 250),
              child: Container(
                height: widget.height,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(26),
                  boxShadow: [
                    BoxShadow(
                      color: primary.withValues(alpha: 0.18),
                      blurRadius: 32,
                      offset: const Offset(0, 16),
                    ),
                  ],
                ),
              ),
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(26),
              child: SizedBox(
                height: widget.height,
                width: double.infinity,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    AnimatedScale(
                      scale: _hovered ? 1.035 : 1.0,
                      duration: const Duration(milliseconds: 450),
                      curve: Curves.easeOutCubic,
                      child: Image.asset(
                        widget.image,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: const Color(0xFFE8F7FA),
                            child: Icon(widget.icon, color: primary, size: 75),
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
                            Colors.transparent,
                            Colors.black.withValues(alpha: 0.45),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      left: 22,
                      bottom: 22,
                      child: AnimatedScale(
                        scale: _hovered ? 1.08 : 1.0,
                        duration: const Duration(milliseconds: 250),
                        curve: Curves.easeOutBack,
                        child: Container(
                          width: 54,
                          height: 54,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.94),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.10),
                                blurRadius: 15,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: Icon(widget.icon, color: primary, size: 27),
                        ),
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

// ============================================================
// HERO TEXT
// ============================================================

class _HeroText extends StatefulWidget {
  final String title;
  final String description;
  final bool isMobile;

  const _HeroText({
    required this.title,
    required this.description,
    required this.isMobile,
  });

  @override
  State<_HeroText> createState() => _HeroTextState();
}

class _HeroTextState extends State<_HeroText> {
  bool _buttonHovered = false;
  bool _buttonPressed = false;

  Future<void> _openWhatsApp({required String serviceTitle}) async {
    const whatsappNumber = '923104939138';

    final message = Uri.encodeComponent(
      'Hello AquaFlow Dubai,\n\n'
      'I would like to request a quote for:\n'
      '$serviceTitle\n\n'
      'Please share the details and pricing.',
    );

    final uri = Uri.parse('https://wa.me/$whatsappNumber?text=$message');

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: 1.0),
          duration: const Duration(milliseconds: 700),
          curve: Curves.easeOutBack,
          builder: (context, value, child) {
            final progress = value.clamp(0.0, 1.0);

            return Transform.scale(
              scale: 0.90 + (progress * 0.10),
              alignment: Alignment.centerLeft,
              child: child,
            );
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 7),
            decoration: BoxDecoration(
              color: primary.withValues(alpha: 0.09),
              borderRadius: BorderRadius.circular(30),
            ),
            child: const Text(
              'AQUAFLOW DUBAI',
              style: TextStyle(
                color: primary,
                fontSize: 10,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.5,
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        Text(
          widget.title,
          style: TextStyle(
            fontSize: widget.isMobile ? 34 : 48,
            height: 1.1,
            fontWeight: FontWeight.w800,
            color: darkText,
            letterSpacing: -1,
          ),
        ),
        const SizedBox(height: 20),
        Text(
          widget.description,
          style: TextStyle(
            fontSize: widget.isMobile ? 15 : 17,
            height: 1.7,
            color: bodyText,
          ),
        ),
        const SizedBox(height: 28),
        MouseRegion(
          cursor: SystemMouseCursors.click,
          onEnter: (_) {
            setState(() {
              _buttonHovered = true;
            });
          },
          onExit: (_) {
            setState(() {
              _buttonHovered = false;
              _buttonPressed = false;
            });
          },
          child: GestureDetector(
            onTapDown: (_) {
              setState(() {
                _buttonPressed = true;
              });
            },
            onTapUp: (_) {
              setState(() {
                _buttonPressed = false;
              });
            },
            onTapCancel: () {
              setState(() {
                _buttonPressed = false;
              });
            },
            onTap: () {
              _openWhatsApp(serviceTitle: widget.title);
            },
            child: AnimatedScale(
              scale: _buttonPressed
                  ? 0.96
                  : _buttonHovered
                  ? 1.04
                  : 1.0,
              duration: const Duration(milliseconds: 180),
              curve: Curves.easeOutCubic,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  AnimatedOpacity(
                    opacity: _buttonHovered ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 200),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(13),
                        boxShadow: [
                          BoxShadow(
                            color: primary.withValues(alpha: 0.25),
                            blurRadius: 22,
                            offset: const Offset(0, 9),
                          ),
                        ],
                      ),
                    ),
                  ),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    curve: Curves.easeOutCubic,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 22,
                      vertical: 15,
                    ),
                    decoration: BoxDecoration(
                      color: _buttonHovered ? const Color(0xFF096F90) : primary,
                      borderRadius: BorderRadius.circular(13),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.request_quote_rounded,
                          size: 19,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Request a Quote',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(width: 7),
                        AnimatedSlide(
                          offset: _buttonHovered
                              ? const Offset(0.15, 0)
                              : Offset.zero,
                          duration: const Duration(milliseconds: 180),
                          child: const Icon(
                            Icons.arrow_forward_rounded,
                            size: 17,
                            color: Colors.white,
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
    );
  }
}

// ============================================================
// SERVICE INFORMATION
// ============================================================

class _ServiceInformation extends StatelessWidget {
  final String title;
  final bool isMobile;
  final bool isTablet;

  const _ServiceInformation({
    required this.title,
    required this.isMobile,
    required this.isTablet,
  });

  @override
  Widget build(BuildContext context) {
    final features = _featuresForService(title);

    final horizontalPadding = isMobile
        ? 20.0
        : isTablet
        ? 40.0
        : 70.0;

    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: isMobile ? 55 : 80,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1180),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.0, end: 1.0),
                duration: const Duration(milliseconds: 850),
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'SERVICE INFORMATION',
                      style: TextStyle(
                        color: primary,
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.7,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Reliable ${title.toLowerCase()}',
                      style: TextStyle(
                        fontSize: isMobile ? 27 : 38,
                        fontWeight: FontWeight.w800,
                        color: darkText,
                      ),
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      'Professional water delivery designed around your property and requirements.',
                      style: TextStyle(
                        fontSize: 15,
                        height: 1.6,
                        color: bodyText,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 35),
              LayoutBuilder(
                builder: (context, constraints) {
                  final columns = constraints.maxWidth < 700 ? 1 : 2;

                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: features.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: columns,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
                      mainAxisExtent: 125,
                    ),
                    itemBuilder: (context, index) {
                      return _FeatureCard(
                        feature: features[index],
                        index: index,
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<_Feature> _featuresForService(String title) {
    switch (title) {
      case 'Sweet Water Supply':
        return const [
          _Feature(
            icon: Icons.water_drop_rounded,
            title: 'Fresh Water',
            description: 'Reliable sweet water supply for daily requirements.',
          ),
          _Feature(
            icon: Icons.local_shipping_rounded,
            title: 'Tanker Delivery',
            description: 'Convenient delivery directly to your property.',
          ),
          _Feature(
            icon: Icons.home_rounded,
            title: 'Residential Use',
            description: 'Suitable for homes, villas and properties.',
          ),
          _Feature(
            icon: Icons.schedule_rounded,
            title: 'Flexible Scheduling',
            description: 'Arrange delivery around your requirements.',
          ),
        ];

      case 'Swimming Pool Water':
        return const [
          _Feature(
            icon: Icons.pool_rounded,
            title: 'Pool Filling',
            description: 'Water supply for swimming pool filling and top-ups.',
          ),
          _Feature(
            icon: Icons.water_drop_rounded,
            title: 'Reliable Supply',
            description: 'Dependable tanker delivery for pool requirements.',
          ),
          _Feature(
            icon: Icons.hotel_rounded,
            title: 'Hotels & Villas',
            description: 'Suitable for residential and hospitality facilities.',
          ),
          _Feature(
            icon: Icons.schedule_rounded,
            title: 'Scheduled Delivery',
            description: 'Plan your delivery according to your needs.',
          ),
        ];

      case 'Residential Supply':
        return const [
          _Feature(
            icon: Icons.home_rounded,
            title: 'Homes & Villas',
            description: 'Water delivery for residential properties.',
          ),
          _Feature(
            icon: Icons.local_shipping_rounded,
            title: 'Tanker Service',
            description: 'Convenient water tanker delivery.',
          ),
          _Feature(
            icon: Icons.water_drop_rounded,
            title: 'Fresh Supply',
            description: 'Reliable water for everyday requirements.',
          ),
          _Feature(
            icon: Icons.schedule_rounded,
            title: 'Convenient Timing',
            description: 'Delivery scheduling around your availability.',
          ),
        ];

      case 'Commercial Supply':
        return const [
          _Feature(
            icon: Icons.business_rounded,
            title: 'Business Supply',
            description: 'Water delivery for offices and businesses.',
          ),
          _Feature(
            icon: Icons.hotel_rounded,
            title: 'Hotels & Facilities',
            description: 'Reliable supply for commercial properties.',
          ),
          _Feature(
            icon: Icons.local_shipping_rounded,
            title: 'Tanker Delivery',
            description: 'Professional delivery to your location.',
          ),
          _Feature(
            icon: Icons.schedule_rounded,
            title: 'Planned Supply',
            description: 'Flexible scheduling for business needs.',
          ),
        ];

      case 'Construction Water':
        return const [
          _Feature(
            icon: Icons.construction_rounded,
            title: 'Construction Sites',
            description: 'Water supply for active construction projects.',
          ),
          _Feature(
            icon: Icons.water_drop_rounded,
            title: 'Project Supply',
            description: 'Dependable water for project requirements.',
          ),
          _Feature(
            icon: Icons.local_shipping_rounded,
            title: 'Tanker Delivery',
            description: 'Direct tanker delivery to project locations.',
          ),
          _Feature(
            icon: Icons.schedule_rounded,
            title: 'Flexible Scheduling',
            description: 'Delivery arrangements based on project needs.',
          ),
        ];

      case 'Garden & Nursery':
        return const [
          _Feature(
            icon: Icons.local_florist_rounded,
            title: 'Garden Supply',
            description: 'Water delivery for gardens and green spaces.',
          ),
          _Feature(
            icon: Icons.grass_rounded,
            title: 'Landscaping',
            description: 'Support for landscaping and outdoor projects.',
          ),
          _Feature(
            icon: Icons.water_drop_rounded,
            title: 'Fresh Water',
            description: 'Reliable supply for plants and outdoor areas.',
          ),
          _Feature(
            icon: Icons.local_shipping_rounded,
            title: 'Tanker Delivery',
            description: 'Convenient delivery directly to your location.',
          ),
        ];

      default:
        return const [
          _Feature(
            icon: Icons.water_drop_rounded,
            title: 'Reliable Supply',
            description: 'Dependable water delivery for your requirements.',
          ),
          _Feature(
            icon: Icons.local_shipping_rounded,
            title: 'Tanker Delivery',
            description: 'Professional delivery directly to your location.',
          ),
          _Feature(
            icon: Icons.schedule_rounded,
            title: 'Flexible Scheduling',
            description: 'Arrange delivery according to your needs.',
          ),
          _Feature(
            icon: Icons.support_agent_rounded,
            title: 'Customer Support',
            description: 'Friendly assistance whenever you need it.',
          ),
        ];
    }
  }
}

// ============================================================
// FEATURE
// ============================================================

class _Feature {
  final IconData icon;
  final String title;
  final String description;

  const _Feature({
    required this.icon,
    required this.title,
    required this.description,
  });
}

// ============================================================
// FEATURE CARD
// ============================================================

class _FeatureCard extends StatefulWidget {
  final _Feature feature;
  final int index;

  const _FeatureCard({required this.feature, required this.index});

  @override
  State<_FeatureCard> createState() => _FeatureCardState();
}

class _FeatureCardState extends State<_FeatureCard> {
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
            offset: Offset(0, 22 * (1 - progress)),
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
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: primary.withValues(alpha: 0.14),
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
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: lightBg,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: _hovered
                        ? primary.withValues(alpha: 0.28)
                        : const Color(0xFFE1EDF1),
                  ),
                ),
                child: Row(
                  children: [
                    AnimatedScale(
                      scale: _hovered ? 1.08 : 1.0,
                      duration: const Duration(milliseconds: 220),
                      curve: Curves.easeOutBack,
                      child: Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: primary.withValues(alpha: 0.10),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Icon(
                          widget.feature.icon,
                          color: primary,
                          size: 23,
                        ),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.feature.title,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              color: darkText,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            widget.feature.description,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 12,
                              height: 1.45,
                              color: bodyText,
                            ),
                          ),
                        ],
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
// QUOTE SECTION
// ============================================================

class _QuoteSection extends StatelessWidget {
  final String serviceTitle;
  final bool isMobile;
  final bool isTablet;

  const _QuoteSection({
    required this.serviceTitle,
    required this.isMobile,
    required this.isTablet,
  });

  @override
  Widget build(BuildContext context) {
    final horizontalPadding = isMobile
        ? 20.0
        : isTablet
        ? 40.0
        : 70.0;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        horizontalPadding,
        20,
        horizontalPadding,
        isMobile ? 55 : 75,
      ),
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.0, end: 1.0),
        duration: const Duration(milliseconds: 950),
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
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 24 : 50,
            vertical: isMobile ? 32 : 42,
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
                color: primary.withValues(alpha: 0.17),
                blurRadius: 28,
                offset: const Offset(0, 14),
              ),
            ],
          ),
          child: isMobile
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _QuoteText(),
                    const SizedBox(height: 25),
                    _QuoteButton(serviceTitle: serviceTitle),
                  ],
                )
              : Row(
                  children: [
                    const Expanded(child: _QuoteText()),
                    const SizedBox(width: 30),
                    _QuoteButton(serviceTitle: serviceTitle),
                  ],
                ),
        ),
      ),
    );
  }
}

// ============================================================
// QUOTE TEXT
// ============================================================

class _QuoteText extends StatelessWidget {
  const _QuoteText();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Need Water Delivered?',
          style: TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.w800,
          ),
        ),
        SizedBox(height: 9),
        Text(
          'Tell us what you need and our team will help arrange your water delivery.',
          style: TextStyle(color: Colors.white70, fontSize: 14, height: 1.6),
        ),
      ],
    );
  }
}

// ============================================================
// QUOTE BUTTON
// ============================================================

class _QuoteButton extends StatefulWidget {
  final String serviceTitle;

  const _QuoteButton({required this.serviceTitle});

  @override
  State<_QuoteButton> createState() => _QuoteButtonState();
}

class _QuoteButtonState extends State<_QuoteButton> {
  bool _hovered = false;
  bool _pressed = false;

  Future<void> _openWhatsApp() async {
    const whatsappNumber = '923104939138';

    final message = Uri.encodeComponent(
      'Hello AquaFlow Dubai,\n\n'
      'I would like to request a quote for:\n'
      '${widget.serviceTitle}\n\n'
      'Please share the details and pricing.',
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
                    borderRadius: BorderRadius.circular(13),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white.withValues(alpha: 0.20),
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
                  horizontal: 22,
                  vertical: 15,
                ),
                decoration: BoxDecoration(
                  color: _hovered ? const Color(0xFFF8FDFF) : Colors.white,
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.request_quote_rounded,
                      size: 18,
                      color: primary,
                    ),
                    const SizedBox(width: 7),
                    const Text(
                      'Request a Quote',
                      style: TextStyle(
                        color: primary,
                        fontWeight: FontWeight.w800,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(width: 7),
                    AnimatedSlide(
                      offset: _hovered ? const Offset(0.15, 0) : Offset.zero,
                      duration: const Duration(milliseconds: 180),
                      child: const Icon(
                        Icons.arrow_forward_rounded,
                        size: 17,
                        color: primary,
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
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
      color: const Color(0xFF0D2535),
      child: const Text(
        '© 2026 AquaFlow Dubai. Reliable Water Delivery.',
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.white70, fontSize: 13),
      ),
    );
  }
}
