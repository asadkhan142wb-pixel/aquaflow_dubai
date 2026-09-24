import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  static const Color primary = Color(0xFF087EA4);
  static const Color darkText = Color(0xFF102A43);
  static const Color bodyText = Color(0xFF52667A);
  static const Color lightBg = Color(0xFFF6FBFD);

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage>
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
      curve: const Interval(0.0, 0.55, curve: Curves.easeOutCubic),
    );

    _heroSlide = Tween<Offset>(begin: const Offset(0, 0.08), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.0, 0.55, curve: Curves.easeOutCubic),
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            const _TopBar(),
            _Hero(fade: _heroFade, slide: _heroSlide),
            const _AboutIntro(),
            const _WhyChoose(),
            const _HowWeWork(),
            const _Stats(),
            const _BottomCta(),
            const _Footer(),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// TOP BAR
// ============================================================

class _TopBar extends StatefulWidget {
  const _TopBar();

  @override
  State<_TopBar> createState() => _TopBarState();
}

class _TopBarState extends State<_TopBar> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        final verySmall = width < 360;
        final mobile = width < 600;
        final tablet = width >= 600 && width < 1000;

        final horizontalPadding = verySmall
            ? 14.0
            : mobile
            ? 18.0
            : tablet
            ? 28.0
            : 40.0;

        final logoSize = verySmall
            ? 40.0
            : mobile
            ? 42.0
            : 44.0;

        return Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: tablet ? 14 : 16,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              bottom: BorderSide(
                color: AboutPage.primary.withValues(alpha: 0.08),
              ),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0.75, end: 1.0),
                      duration: const Duration(milliseconds: 700),
                      curve: Curves.easeOutBack,
                      builder: (context, value, child) {
                        return Transform.scale(scale: value, child: child);
                      },
                      child: Container(
                        width: logoSize,
                        height: logoSize,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [AboutPage.primary, Color(0xFF0AA8D0)],
                          ),
                          borderRadius: BorderRadius.circular(
                            verySmall ? 11 : 13,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AboutPage.primary.withValues(alpha: 0.18),
                              blurRadius: 18,
                              offset: const Offset(0, 7),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.water_drop_rounded,
                          color: Colors.white,
                          size: verySmall ? 22 : 25,
                        ),
                      ),
                    ),
                    SizedBox(width: verySmall ? 8 : 12),
                    Flexible(
                      child: TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0.0, end: 1.0),
                        duration: const Duration(milliseconds: 750),
                        curve: Curves.easeOutCubic,
                        builder: (context, value, child) {
                          final progress = value.clamp(0.0, 1.0);

                          return Opacity(
                            opacity: progress,
                            child: Transform.translate(
                              offset: Offset(-15 * (1 - progress), 0),
                              child: child,
                            ),
                          );
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'AquaFlow',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: verySmall
                                    ? 17
                                    : tablet
                                    ? 18
                                    : 19,
                                fontWeight: FontWeight.w800,
                                color: AboutPage.darkText,
                              ),
                            ),
                            Text(
                              'DUBAI',
                              maxLines: 1,
                              overflow: TextOverflow.clip,
                              style: TextStyle(
                                fontSize: verySmall ? 8 : 9,
                                fontWeight: FontWeight.w700,
                                letterSpacing: verySmall ? 1.5 : 2,
                                color: AboutPage.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              MouseRegion(
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
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: AnimatedScale(
                    scale: _hovered ? 1.04 : 1.0,
                    duration: const Duration(milliseconds: 180),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      padding: EdgeInsets.symmetric(
                        horizontal: verySmall
                            ? 10
                            : tablet
                            ? 14
                            : 18,
                        vertical: verySmall
                            ? 9
                            : tablet
                            ? 11
                            : 13,
                      ),
                      decoration: BoxDecoration(
                        color: _hovered
                            ? AboutPage.primary.withValues(alpha: 0.07)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(
                          verySmall ? 10 : 12,
                        ),
                        border: Border.all(
                          color: _hovered
                              ? AboutPage.primary.withValues(alpha: 0.38)
                              : AboutPage.primary.withValues(alpha: 0.25),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          AnimatedSlide(
                            offset: _hovered
                                ? const Offset(-0.08, 0)
                                : Offset.zero,
                            duration: const Duration(milliseconds: 180),
                            child: Icon(
                              Icons.arrow_back_rounded,
                              size: verySmall
                                  ? 16
                                  : tablet
                                  ? 17
                                  : 18,
                              color: AboutPage.primary,
                            ),
                          ),
                          SizedBox(width: verySmall ? 4 : 7),
                          Text(
                            verySmall ? 'Home' : 'Back Home',
                            style: TextStyle(
                              color: AboutPage.primary,
                              fontWeight: FontWeight.w700,
                              fontSize: verySmall
                                  ? 12
                                  : tablet
                                  ? 13
                                  : 14,
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
      },
    );
  }
}

// ============================================================
// HERO
// ============================================================

class _Hero extends StatelessWidget {
  final Animation<double> fade;
  final Animation<Offset> slide;

  const _Hero({required this.fade, required this.slide});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        final mobile = width < 700;
        final verySmall = width < 380;

        final horizontalPadding = verySmall
            ? 16.0
            : mobile
            ? 20.0
            : 24.0;

        final verticalPadding = verySmall
            ? 60.0
            : mobile
            ? 70.0
            : 82.0;

        final titleSize = verySmall
            ? 31.0
            : mobile
            ? 36.0
            : 48.0;

        final descriptionSize = verySmall ? 14.0 : 17.0;

        return Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: verticalPadding,
          ),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFFF4FCFE), Colors.white],
            ),
          ),
          child: FadeTransition(
            opacity: fade,
            child: SlideTransition(
              position: slide,
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 900),
                  child: Column(
                    children: [
                      TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0.0, end: 1.0),
                        duration: const Duration(milliseconds: 700),
                        curve: Curves.easeOutBack,
                        builder: (context, value, child) {
                          final progress = value.clamp(0.0, 1.0);

                          return Transform.scale(
                            scale: 0.88 + progress * 0.12,
                            child: child,
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: AboutPage.primary.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Text(
                            'ABOUT AQUAFLOW',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: AboutPage.primary,
                              fontSize: verySmall ? 10 : 12,
                              fontWeight: FontWeight.w800,
                              letterSpacing: verySmall ? 1.4 : 1.8,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 22),
                      Text(
                        'Reliable Water Supply,\n'
                        'Right When You Need It.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: titleSize,
                          height: 1.12,
                          fontWeight: FontWeight.w900,
                          color: AboutPage.darkText,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'AquaFlow Dubai provides dependable '
                        'water tanker delivery solutions for '
                        'homes, businesses, construction sites, '
                        'gardens and swimming pools across Dubai.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: descriptionSize,
                          height: 1.7,
                          color: AboutPage.bodyText,
                        ),
                      ),
                    ],
                  ),
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
// ABOUT INTRO
// ============================================================

class _AboutIntro extends StatelessWidget {
  const _AboutIntro();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, screenConstraints) {
        final width = screenConstraints.maxWidth;
        final mobile = width < 800;
        final verySmall = width < 380;

        return Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(
            horizontal: verySmall ? 16 : 24,
            vertical: mobile ? 65 : 90,
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1180),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  if (mobile) {
                    return Column(
                      children: [
                        const _AboutVisual(),
                        SizedBox(height: verySmall ? 35 : 45),
                        const _AboutContent(),
                      ],
                    );
                  }

                  return const Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(child: _AboutVisual()),
                      SizedBox(width: 70),
                      Expanded(child: _AboutContent()),
                    ],
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}

// ============================================================
// ABOUT VISUAL - REAL TANKER IMAGE
// ============================================================

class _AboutVisual extends StatefulWidget {
  const _AboutVisual();

  @override
  State<_AboutVisual> createState() => _AboutVisualState();
}

class _AboutVisualState extends State<_AboutVisual> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        final verySmall = width < 380;
        final small = width < 500;

        final visualHeight = verySmall
            ? 350.0
            : small
            ? 390.0
            : 430.0;

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
                // ==================================================
                // HOVER SHADOW
                // ==================================================

                AnimatedOpacity(
                  opacity: _hovered ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 250),
                  child: Container(
                    height: visualHeight,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(32),
                      boxShadow: [
                        BoxShadow(
                          color: AboutPage.primary.withValues(alpha: 0.28),
                          blurRadius: 40,
                          offset: const Offset(0, 20),
                        ),
                      ],
                    ),
                  ),
                ),

                // ==================================================
                // IMAGE CONTAINER
                // ==================================================
                Container(
                  width: double.infinity,
                  height: visualHeight,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(32),
                    boxShadow: [
                      BoxShadow(
                        color: AboutPage.primary.withValues(alpha: 0.18),
                        blurRadius: 35,
                        offset: const Offset(0, 18),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(32),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        // ==================================================
                        // REAL TANKER IMAGE
                        // ==================================================

                        AnimatedScale(
                          scale: _hovered ? 1.035 : 1.0,
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeOutCubic,
                          child: Image.asset(
                            'assets/images/about/about-tanker.jpg',
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                decoration: const BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      Color(0xFF087EA4),
                                      Color(0xFF075B78),
                                    ],
                                  ),
                                ),
                                child: const Center(
                                  child: Icon(
                                    Icons.local_shipping_rounded,
                                    color: Colors.white,
                                    size: 80,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),

                        // ==================================================
                        // DARK PROFESSIONAL OVERLAY
                        // ==================================================
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.black.withValues(alpha: 0.04),
                                Colors.black.withValues(alpha: 0.10),
                                Colors.black.withValues(alpha: 0.68),
                              ],
                              stops: const [0.0, 0.48, 1.0],
                            ),
                          ),
                        ),

                        // ==================================================
                        // BLUE BRAND OVERLAY
                        // ==================================================
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                AboutPage.primary.withValues(alpha: 0.12),
                                Colors.transparent,
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),

                        // ==================================================
                        // TOP BADGE
                        // ==================================================
                        Positioned(
                          left: verySmall ? 12 : 20,
                          top: verySmall ? 12 : 20,
                          child: const _SmallBadge(
                            icon: Icons.verified_rounded,
                            text: 'Trusted Service',
                          ),
                        ),

                        // ==================================================
                        // BOTTOM BADGE
                        // ==================================================
                        Positioned(
                          right: verySmall ? 12 : 20,
                          bottom: verySmall ? 12 : 20,
                          child: const _SmallBadge(
                            icon: Icons.access_time_rounded,
                            text: '24/7 Available',
                          ),
                        ),

                        // ==================================================
                        // BOTTOM TEXT
                        // ==================================================
                        Positioned(
                          left: verySmall ? 20 : 28,
                          right: verySmall ? 20 : 28,
                          bottom: verySmall ? 62 : 72,
                          child: TweenAnimationBuilder<double>(
                            tween: Tween(begin: 0.0, end: 1.0),
                            duration: const Duration(milliseconds: 900),
                            curve: Curves.easeOutCubic,
                            builder: (context, value, child) {
                              final progress = value.clamp(0.0, 1.0);

                              return Opacity(
                                opacity: progress,
                                child: Transform.translate(
                                  offset: Offset(0, 18 * (1 - progress)),
                                  child: child,
                                ),
                              );
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'AQUAFLOW DUBAI',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: verySmall ? 19 : 24,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: verySmall ? 1.0 : 1.5,
                                  ),
                                ),
                                const SizedBox(height: 7),
                                Text(
                                  'WATER DELIVERY SOLUTIONS',
                                  style: TextStyle(
                                    color: Colors.white.withValues(alpha: 0.85),
                                    fontSize: verySmall ? 9 : 11,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: verySmall ? 1.0 : 1.5,
                                  ),
                                ),
                              ],
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
      },
    );
  }
}

// ============================================================
// SMALL BADGE
// ============================================================

class _SmallBadge extends StatefulWidget {
  final IconData icon;
  final String text;

  const _SmallBadge({required this.icon, required this.text});

  @override
  State<_SmallBadge> createState() => _SmallBadgeState();
}

class _SmallBadgeState extends State<_SmallBadge> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
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
        child: Container(
          constraints: const BoxConstraints(maxWidth: 150),
          padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.13),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: Colors.white.withValues(alpha: 0.16)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(widget.icon, color: Colors.white, size: 14),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  widget.text,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
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
// ABOUT CONTENT
// ============================================================

class _AboutContent extends StatelessWidget {
  const _AboutContent();

  @override
  Widget build(BuildContext context) {
    const checks = [
      'Reliable and professional service',
      'Fast response across Dubai',
      'Residential and commercial solutions',
      'Flexible delivery requirements',
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final small = constraints.maxWidth < 500;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'WHO WE ARE',
              style: TextStyle(
                color: AboutPage.primary,
                fontSize: 12,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.8,
              ),
            ),
            const SizedBox(height: 15),
            Text(
              'Your Reliable Water Delivery Partner in Dubai',
              style: TextStyle(
                color: AboutPage.darkText,
                fontSize: small ? 29 : 35,
                height: 1.18,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'AquaFlow Dubai is focused on making water delivery simple, '
              'reliable and convenient. We provide professional tanker '
              'water supply for residential, commercial and industrial needs.',
              style: TextStyle(
                color: AboutPage.bodyText,
                fontSize: 15,
                height: 1.75,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'From emergency water requirements to planned deliveries, '
              'our team is ready to help customers get the water they need '
              'when they need it.',
              style: TextStyle(
                color: AboutPage.bodyText,
                fontSize: 15,
                height: 1.75,
              ),
            ),
            const SizedBox(height: 28),
            ...List.generate(
              checks.length,
              (index) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _AnimatedCheckRow(text: checks[index], index: index),
              ),
            ),
          ],
        );
      },
    );
  }
}

// ============================================================
// CHECK ROW
// ============================================================

class _AnimatedCheckRow extends StatelessWidget {
  final String text;
  final int index;

  const _AnimatedCheckRow({required this.text, required this.index});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 500 + (index * 100)),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        final progress = value.clamp(0.0, 1.0);

        return Opacity(
          opacity: progress,
          child: Transform.translate(
            offset: Offset(18 * (1 - progress), 0),
            child: child,
          ),
        );
      },
      child: Row(
        children: [
          Container(
            width: 23,
            height: 23,
            decoration: BoxDecoration(
              color: AboutPage.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check_rounded,
              color: AboutPage.primary,
              size: 15,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: AboutPage.darkText,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// WHY CHOOSE US
// ============================================================

class _WhyChoose extends StatelessWidget {
  const _WhyChoose();

  @override
  Widget build(BuildContext context) {
    const items = [
      (
        Icons.schedule_rounded,
        '24/7 Availability',
        'Water delivery support whenever you need it.',
      ),
      (
        Icons.speed_rounded,
        'Fast Response',
        'Quick coordination for urgent and planned deliveries.',
      ),
      (
        Icons.local_shipping_rounded,
        'Professional Fleet',
        'Modern tanker solutions for different requirements.',
      ),
      (
        Icons.location_on_rounded,
        'Dubai Coverage',
        'Serving residential, commercial and project locations.',
      ),
    ];

    return LayoutBuilder(
      builder: (context, screenConstraints) {
        final verySmall = screenConstraints.maxWidth < 380;

        return Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(
            horizontal: verySmall ? 16 : 24,
            vertical: 85,
          ),
          color: AboutPage.lightBg,
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1180),
              child: Column(
                children: [
                  const Text(
                    'WHY AQUAFLOW',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AboutPage.primary,
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.8,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    'Built Around Reliability',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AboutPage.darkText,
                      fontSize: verySmall ? 30 : 36,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 14),
                  const Text(
                    'Everything we do is focused on dependable service '
                    'and a smooth customer experience.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AboutPage.bodyText,
                      fontSize: 15,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 45),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final width = constraints.maxWidth;

                      final double cardWidth;

                      if (width < 600) {
                        cardWidth = width;
                      } else if (width < 950) {
                        cardWidth = (width - 16) / 2;
                      } else {
                        cardWidth = (width - 42) / 4;
                      }

                      return Wrap(
                        spacing: 14,
                        runSpacing: 14,
                        alignment: WrapAlignment.center,
                        children: List.generate(items.length, (index) {
                          final item = items[index];

                          return SizedBox(
                            width: cardWidth,
                            child: _WhyCard(
                              icon: item.$1,
                              title: item.$2,
                              text: item.$3,
                              index: index,
                            ),
                          );
                        }),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// ============================================================
// WHY CARD
// ============================================================

class _WhyCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final String text;
  final int index;

  const _WhyCard({
    required this.icon,
    required this.title,
    required this.text,
    required this.index,
  });

  @override
  State<_WhyCard> createState() => _WhyCardState();
}

class _WhyCardState extends State<_WhyCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 600 + (widget.index * 120)),
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
                    borderRadius: BorderRadius.circular(22),
                    boxShadow: [
                      BoxShadow(
                        color: AboutPage.primary.withValues(alpha: 0.16),
                        blurRadius: 28,
                        offset: const Offset(0, 13),
                      ),
                    ],
                  ),
                ),
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                padding: const EdgeInsets.all(25),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(
                    color: _hovered
                        ? AboutPage.primary.withValues(alpha: 0.22)
                        : AboutPage.primary.withValues(alpha: 0.08),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.035),
                      blurRadius: 14,
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
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: AboutPage.primary.withValues(alpha: 0.09),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Icon(
                          widget.icon,
                          color: AboutPage.primary,
                          size: 25,
                        ),
                      ),
                    ),
                    const SizedBox(height: 22),
                    Text(
                      widget.title,
                      style: const TextStyle(
                        color: AboutPage.darkText,
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 9),
                    Text(
                      widget.text,
                      style: const TextStyle(
                        color: AboutPage.bodyText,
                        fontSize: 13,
                        height: 1.55,
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
// HOW WE WORK
// ============================================================

class _HowWeWork extends StatelessWidget {
  const _HowWeWork();

  @override
  Widget build(BuildContext context) {
    const steps = [
      (
        '01',
        Icons.phone_in_talk_rounded,
        'Contact Us',
        'Tell us what type of water delivery you need.',
      ),
      (
        '02',
        Icons.event_available_rounded,
        'Schedule Delivery',
        'Choose your preferred delivery time and location.',
      ),
      (
        '03',
        Icons.local_shipping_rounded,
        'We Deliver',
        'Our tanker reaches your location and delivers your water.',
      ),
    ];

    return LayoutBuilder(
      builder: (context, screenConstraints) {
        final verySmall = screenConstraints.maxWidth < 380;

        return Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(
            horizontal: verySmall ? 16 : 24,
            vertical: 90,
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1100),
              child: Column(
                children: [
                  const Text(
                    'OUR PROCESS',
                    style: TextStyle(
                      color: AboutPage.primary,
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.8,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    'Simple From Start to Finish',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AboutPage.darkText,
                      fontSize: verySmall ? 30 : 36,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 48),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final mobile = constraints.maxWidth < 700;

                      if (mobile) {
                        return Column(
                          children: List.generate(steps.length, (index) {
                            final step = steps[index];

                            return Padding(
                              padding: const EdgeInsets.only(bottom: 18),
                              child: _ProcessCard(
                                number: step.$1,
                                icon: step.$2,
                                title: step.$3,
                                text: step.$4,
                                index: index,
                              ),
                            );
                          }),
                        );
                      }

                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: List.generate(steps.length, (index) {
                          final step = steps[index];

                          return Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                              ),
                              child: _ProcessCard(
                                number: step.$1,
                                icon: step.$2,
                                title: step.$3,
                                text: step.$4,
                                index: index,
                              ),
                            ),
                          );
                        }),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// ============================================================
// PROCESS CARD
// ============================================================

class _ProcessCard extends StatefulWidget {
  final String number;
  final IconData icon;
  final String title;
  final String text;
  final int index;

  const _ProcessCard({
    required this.number,
    required this.icon,
    required this.title,
    required this.text,
    required this.index,
  });

  @override
  State<_ProcessCard> createState() => _ProcessCardState();
}

class _ProcessCardState extends State<_ProcessCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 650 + (widget.index * 130)),
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
                    borderRadius: BorderRadius.circular(22),
                    boxShadow: [
                      BoxShadow(
                        color: AboutPage.primary.withValues(alpha: 0.14),
                        blurRadius: 25,
                        offset: const Offset(0, 12),
                      ),
                    ],
                  ),
                ),
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                padding: const EdgeInsets.all(25),
                decoration: BoxDecoration(
                  color: AboutPage.lightBg,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(
                    color: _hovered
                        ? AboutPage.primary.withValues(alpha: 0.20)
                        : AboutPage.primary.withValues(alpha: 0.08),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        AnimatedScale(
                          scale: _hovered ? 1.08 : 1.0,
                          duration: const Duration(milliseconds: 220),
                          curve: Curves.easeOutBack,
                          child: Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: AboutPage.primary,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Icon(
                              widget.icon,
                              color: Colors.white,
                              size: 23,
                            ),
                          ),
                        ),
                        const Spacer(),
                        Text(
                          widget.number,
                          style: TextStyle(
                            color: AboutPage.primary.withValues(
                              alpha: _hovered ? 0.28 : 0.18,
                            ),
                            fontSize: 32,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 23),
                    Text(
                      widget.title,
                      style: const TextStyle(
                        color: AboutPage.darkText,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 9),
                    Text(
                      widget.text,
                      style: const TextStyle(
                        color: AboutPage.bodyText,
                        fontSize: 13,
                        height: 1.55,
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
// STATS
// ============================================================

class _Stats extends StatelessWidget {
  const _Stats();

  @override
  Widget build(BuildContext context) {
    const stats = [
      ('24/7', 'Availability'),
      ('Dubai', 'Wide Coverage'),
      ('Fast', 'Response'),
      ('100%', 'Customer Focus'),
    ];

    return LayoutBuilder(
      builder: (context, screenConstraints) {
        final mobile = screenConstraints.maxWidth < 650;
        final verySmall = screenConstraints.maxWidth < 380;

        return Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(
            horizontal: verySmall ? 16 : 24,
            vertical: 55,
          ),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF075B78), AboutPage.primary],
            ),
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1100),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  if (mobile) {
                    return Wrap(
                      alignment: WrapAlignment.center,
                      spacing: verySmall ? 25 : 35,
                      runSpacing: 30,
                      children: List.generate(
                        stats.length,
                        (index) => _StatItem(
                          value: stats[index].$1,
                          label: stats[index].$2,
                          index: index,
                        ),
                      ),
                    );
                  }

                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: List.generate(
                      stats.length,
                      (index) => _StatItem(
                        value: stats[index].$1,
                        label: stats[index].$2,
                        index: index,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}

// ============================================================
// STAT ITEM
// ============================================================

class _StatItem extends StatelessWidget {
  final String value;
  final String label;
  final int index;

  const _StatItem({
    required this.value,
    required this.label,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 650 + (index * 120)),
      curve: Curves.easeOutCubic,
      builder: (context, animation, child) {
        final progress = animation.clamp(0.0, 1.0);

        return Opacity(
          opacity: progress,
          child: Transform.scale(scale: 0.85 + (progress * 0.15), child: child),
        );
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.72),
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// BOTTOM CTA
// ============================================================

class _BottomCta extends StatefulWidget {
  const _BottomCta();

  @override
  State<_BottomCta> createState() => _BottomCtaState();
}

class _BottomCtaState extends State<_BottomCta> {
  bool _hovered = false;
  bool _pressed = false;

  Future<void> _openWhatsApp() async {
    const whatsappNumber = '923104939138';

    final message = Uri.encodeComponent(
      'Hello AquaFlow Dubai,\n\n'
      'I would like to request a quote for water delivery.\n\n'
      'Please share the details and pricing.',
    );

    final uri = Uri.parse('https://wa.me/$whatsappNumber?text=$message');

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, screenConstraints) {
        final width = screenConstraints.maxWidth;

        final verySmall = width < 380;
        final mobile = width < 600;

        return Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(
            horizontal: verySmall ? 16 : 24,
            vertical: 75,
          ),
          color: AboutPage.lightBg,
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 900),
              child: TweenAnimationBuilder<double>(
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
                  padding: EdgeInsets.symmetric(
                    horizontal: verySmall
                        ? 18
                        : mobile
                        ? 24
                        : 35,
                    vertical: 42,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(
                      color: AboutPage.primary.withValues(alpha: 0.1),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 30,
                        offset: const Offset(0, 14),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Need Reliable Water Delivery?',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AboutPage.darkText,
                          fontSize: verySmall ? 25 : 30,
                          height: 1.2,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Get in touch with AquaFlow Dubai today.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AboutPage.bodyText,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 25),
                      MouseRegion(
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
                                          color: AboutPage.primary.withValues(
                                            alpha: 0.25,
                                          ),
                                          blurRadius: 22,
                                          offset: const Offset(0, 9),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                AnimatedContainer(
                                  duration: const Duration(milliseconds: 180),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: verySmall ? 18 : 24,
                                    vertical: 16,
                                  ),
                                  decoration: BoxDecoration(
                                    color: _hovered
                                        ? const Color(0xFF096F90)
                                        : AboutPage.primary,
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(
                                        Icons.request_quote_rounded,
                                        color: Colors.white,
                                        size: 19,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        'Request a Quote',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w800,
                                          fontSize: verySmall ? 13 : 14,
                                        ),
                                      ),
                                      const SizedBox(width: 7),
                                      AnimatedSlide(
                                        offset: _hovered
                                            ? const Offset(0.15, 0)
                                            : Offset.zero,
                                        duration: const Duration(
                                          milliseconds: 180,
                                        ),
                                        child: const Icon(
                                          Icons.arrow_forward_rounded,
                                          color: Colors.white,
                                          size: 17,
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
              ),
            ),
          ),
        );
      },
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
    return LayoutBuilder(
      builder: (context, screenConstraints) {
        final verySmall = screenConstraints.maxWidth < 380;

        return Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(
            horizontal: verySmall ? 16 : 24,
            vertical: 32,
          ),
          color: const Color(0xFF071D2B),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1180),
              child: Column(
                children: [
                  TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0.0, end: 1.0),
                    duration: const Duration(milliseconds: 700),
                    curve: Curves.easeOutCubic,
                    builder: (context, value, child) {
                      final progress = value.clamp(0.0, 1.0);

                      return Opacity(
                        opacity: progress,
                        child: Transform.translate(
                          offset: Offset(0, 15 * (1 - progress)),
                          child: child,
                        ),
                      );
                    },
                    child: Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: AboutPage.primary,
                            borderRadius: BorderRadius.circular(11),
                          ),
                          child: const Icon(
                            Icons.water_drop_rounded,
                            color: Colors.white,
                            size: 22,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Flexible(
                          child: Text(
                            'AquaFlow Dubai',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 25),
                  Divider(color: Colors.white.withValues(alpha: 0.08)),
                  const SizedBox(height: 18),
                  Text(
                    '© 2026 AquaFlow Dubai. Water Delivery Solutions.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.55),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
