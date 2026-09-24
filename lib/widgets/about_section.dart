import 'package:flutter/material.dart';

class AboutSection extends StatefulWidget {
  const AboutSection({super.key});

  static const Color primary = Color(0xFF087EA4);
  static const Color darkText = Color(0xFF102A43);
  static const Color bodyText = Color(0xFF52667A);
  static const Color lightBg = Color(0xFFF6FBFD);

  @override
  State<AboutSection> createState() => _AboutSectionState();
}

class _AboutSectionState extends State<AboutSection>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  late final Animation<double> _visualFade;
  late final Animation<Offset> _visualSlide;
  late final Animation<double> _contentFade;
  late final Animation<Offset> _contentSlide;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _visualFade = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.10, 0.65, curve: Curves.easeOut),
    );

    _visualSlide =
        Tween<Offset>(begin: const Offset(-0.08, 0), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.10, 0.70, curve: Curves.easeOutCubic),
          ),
        );

    _contentFade = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.22, 0.78, curve: Curves.easeOut),
    );

    _contentSlide =
        Tween<Offset>(begin: const Offset(0.08, 0), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.22, 0.80, curve: Curves.easeOutCubic),
          ),
        );

    _controller.forward();
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
    final isTablet = width >= 800 && width < 1100;

    return Container(
      width: double.infinity,
      color: AboutSection.lightBg,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile
            ? 24
            : isTablet
            ? 40
            : 70,
        vertical: isMobile ? 70 : 105,
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1180),
        child: isMobile
            ? Column(
                children: [
                  FadeTransition(
                    opacity: _visualFade,
                    child: SlideTransition(
                      position: _visualSlide,
                      child: const _AboutVisual(),
                    ),
                  ),
                  const SizedBox(height: 45),
                  FadeTransition(
                    opacity: _contentFade,
                    child: SlideTransition(
                      position: _contentSlide,
                      child: const _AboutContent(),
                    ),
                  ),
                ],
              )
            : Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 5,
                    child: FadeTransition(
                      opacity: _visualFade,
                      child: SlideTransition(
                        position: _visualSlide,
                        child: _AboutVisual(isTablet: isTablet),
                      ),
                    ),
                  ),
                  SizedBox(width: isTablet ? 45 : 75),
                  Expanded(
                    flex: 5,
                    child: FadeTransition(
                      opacity: _contentFade,
                      child: SlideTransition(
                        position: _contentSlide,
                        child: const _AboutContent(),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

class _AboutVisual extends StatefulWidget {
  final bool isTablet;

  const _AboutVisual({this.isTablet = false});

  @override
  State<_AboutVisual> createState() => _AboutVisualState();
}

class _AboutVisualState extends State<_AboutVisual>
    with SingleTickerProviderStateMixin {
  late final AnimationController _imageController;
  bool _hovering = false;

  @override
  void initState() {
    super.initState();

    _imageController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..forward();
  }

  @override
  void dispose() {
    _imageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 800;

    return AspectRatio(
      aspectRatio: isMobile ? 1.15 : 0.95,
      child: MouseRegion(
        onEnter: (_) {
          if (!isMobile) {
            setState(() => _hovering = true);
          }
        },
        onExit: (_) {
          if (!isMobile) {
            setState(() => _hovering = false);
          }
        },
        child: AnimatedScale(
          scale: _hovering ? 1.015 : 1.0,
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeOutCubic,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // Main image.
              Positioned.fill(
                child: AnimatedBuilder(
                  animation: _imageController,
                  builder: (context, child) {
                    final imageScale =
                        1.08 - (_imageController.value.clamp(0.0, 1.0) * 0.08);

                    return ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: Transform.scale(scale: imageScale, child: child),
                    );
                  },
                  child: Image.asset(
                    'assets/images/about/about-tanker.jpg',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [Color(0xFFE8F8FC), Color(0xFFCDEEF5)],
                          ),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.local_shipping_rounded,
                            size: 100,
                            color: AboutSection.primary,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),

              // Subtle image overlay.
              Positioned.fill(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 350),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withValues(
                            alpha: _hovering ? 0.01 : 0.02,
                          ),
                          Colors.black.withValues(
                            alpha: _hovering ? 0.03 : 0.04,
                          ),
                          Colors.black.withValues(
                            alpha: _hovering ? 0.40 : 0.48,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // Top label.
              Positioned(
                top: 20,
                left: 20,
                child: TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0, end: 1),
                  duration: const Duration(milliseconds: 700),
                  curve: Curves.easeOutBack,
                  builder: (context, value, child) {
                    return Opacity(
                      opacity: value.clamp(0.0, 1.0),
                      child: Transform.translate(
                        offset: Offset(0, (1 - value) * -15),
                        child: child,
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 9,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.95),
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.08),
                          blurRadius: 15,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.verified_rounded,
                          color: AboutSection.primary,
                          size: 16,
                        ),
                        SizedBox(width: 7),
                        Text(
                          'Trusted Water Supply',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            color: AboutSection.darkText,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Bottom information card.
              Positioned(
                left: 20,
                right: 20,
                bottom: 20,
                child: TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0, end: 1),
                  duration: const Duration(milliseconds: 900),
                  curve: Curves.easeOutCubic,
                  builder: (context, value, child) {
                    return Opacity(
                      opacity: value.clamp(0.0, 1.0),
                      child: Transform.translate(
                        offset: Offset(0, (1 - value) * 25),
                        child: child,
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.94),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.8),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.10),
                          blurRadius: 25,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [Color(0xFF18A6C8), Color(0xFF087EA4)],
                            ),
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: _hovering
                                ? [
                                    BoxShadow(
                                      color: AboutSection.primary.withValues(
                                        alpha: 0.25,
                                      ),
                                      blurRadius: 14,
                                      offset: const Offset(0, 5),
                                    ),
                                  ]
                                : null,
                          ),
                          child: AnimatedScale(
                            scale: _hovering ? 1.08 : 1.0,
                            duration: const Duration(milliseconds: 250),
                            curve: Curves.easeOutBack,
                            child: const Icon(
                              Icons.water_drop_rounded,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                        ),
                        const SizedBox(width: 13),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '24/7 Water Availability',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w800,
                                  color: AboutSection.darkText,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Ready when your business or home needs us.',
                                style: TextStyle(
                                  fontSize: 11.5,
                                  height: 1.4,
                                  color: AboutSection.bodyText,
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

              // Floating quality badge.
              if (!isMobile)
                Positioned(
                  right: -18,
                  top: 75,
                  child: TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0, end: 1),
                    duration: const Duration(milliseconds: 1000),
                    curve: Curves.easeOutBack,
                    builder: (context, value, child) {
                      return Opacity(
                        opacity: value.clamp(0.0, 1.0),
                        child: Transform.translate(
                          offset: Offset((1 - value) * 25, 0),
                          child: Transform.rotate(
                            angle: (1 - value) * 0.08,
                            child: child,
                          ),
                        ),
                      );
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        color: AboutSection.primary,
                        borderRadius: BorderRadius.circular(17),
                        boxShadow: [
                          BoxShadow(
                            color: AboutSection.primary.withValues(
                              alpha: _hovering ? 0.35 : 0.25,
                            ),
                            blurRadius: _hovering ? 28 : 22,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.workspace_premium_rounded,
                            color: Colors.white,
                            size: 21,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Quality First',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
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
    );
  }
}

class _AboutContent extends StatelessWidget {
  const _AboutContent();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 800;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: 1),
          duration: const Duration(milliseconds: 650),
          curve: Curves.easeOutCubic,
          builder: (context, value, child) {
            return Opacity(
              opacity: value.clamp(0.0, 1.0),
              child: Transform.translate(
                offset: Offset(0, (1 - value) * 15),
                child: child,
              ),
            );
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: const Color(0xFFB9E8F1)),
            ),
            child: const Text(
              'ABOUT AQUAFLOW',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.8,
                color: AboutSection.primary,
              ),
            ),
          ),
        ),

        const SizedBox(height: 20),

        TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: 1),
          duration: const Duration(milliseconds: 750),
          curve: Curves.easeOutCubic,
          builder: (context, value, child) {
            return Opacity(
              opacity: value.clamp(0.0, 1.0),
              child: Transform.translate(
                offset: Offset(0, (1 - value) * 18),
                child: child,
              ),
            );
          },
          child: Text(
            'Reliable Water Supply, Right When You Need It.',
            style: TextStyle(
              fontSize: isMobile ? 31 : 42,
              height: 1.14,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.8,
              color: AboutSection.darkText,
            ),
          ),
        ),

        const SizedBox(height: 18),

        TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: 1),
          duration: const Duration(milliseconds: 850),
          curve: Curves.easeOutCubic,
          builder: (context, value, child) {
            return Opacity(
              opacity: value.clamp(0.0, 1.0),
              child: Transform.translate(
                offset: Offset(0, (1 - value) * 20),
                child: child,
              ),
            );
          },
          child: const Text(
            'AquaFlow Dubai provides dependable water delivery '
            'solutions for homes, businesses, construction sites, '
            'gardens and swimming pools across Dubai.',
            style: TextStyle(
              fontSize: 15,
              height: 1.75,
              color: AboutSection.bodyText,
            ),
          ),
        ),

        const SizedBox(height: 30),

        const _AnimatedBenefitItem(
          delay: 100,
          icon: Icons.schedule_rounded,
          title: 'Reliable Service',
          description: 'Professional water delivery whenever you need it.',
        ),

        const SizedBox(height: 18),

        const _AnimatedBenefitItem(
          delay: 200,
          icon: Icons.local_shipping_rounded,
          title: 'Professional Fleet',
          description:
              'Modern tankers prepared for different water requirements.',
        ),

        const SizedBox(height: 18),

        const _AnimatedBenefitItem(
          delay: 300,
          icon: Icons.support_agent_rounded,
          title: 'Customer Support',
          description: 'Our team is ready to help you choose the right supply.',
        ),

        const SizedBox(height: 35),

        TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: 1),
          duration: const Duration(milliseconds: 1100),
          curve: Curves.easeOutCubic,
          builder: (context, value, child) {
            return Opacity(
              opacity: value.clamp(0.0, 1.0),
              child: Transform.translate(
                offset: Offset(0, (1 - value) * 20),
                child: child,
              ),
            );
          },
          child: const Wrap(
            spacing: 14,
            runSpacing: 14,
            children: [
              _StatCard(value: '24/7', label: 'Availability'),
              _StatCard(value: 'Dubai', label: 'Wide Coverage'),
            ],
          ),
        ),
      ],
    );
  }
}

class _AnimatedBenefitItem extends StatefulWidget {
  final int delay;
  final IconData icon;
  final String title;
  final String description;

  const _AnimatedBenefitItem({
    required this.delay,
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  State<_AnimatedBenefitItem> createState() => _AnimatedBenefitItemState();
}

class _AnimatedBenefitItemState extends State<_AnimatedBenefitItem> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 650 + widget.delay),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Opacity(
          opacity: value.clamp(0.0, 1.0),
          child: Transform.translate(
            offset: Offset((1 - value) * 25, 0),
            child: child,
          ),
        );
      },
      child: MouseRegion(
        onEnter: (_) => setState(() => _hovering = true),
        onExit: (_) => setState(() => _hovering = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOutCubic,
          child: Transform.translate(
            offset: Offset(_hovering ? 5.0 : 0.0, 0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: _hovering
                        ? AboutSection.primary.withValues(alpha: 0.12)
                        : const Color(0xFFEAF8FB),
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: _hovering
                        ? [
                            BoxShadow(
                              color: AboutSection.primary.withValues(
                                alpha: 0.14,
                              ),
                              blurRadius: 14,
                              offset: const Offset(0, 5),
                            ),
                          ]
                        : null,
                  ),
                  child: AnimatedScale(
                    scale: _hovering ? 1.10 : 1.0,
                    duration: const Duration(milliseconds: 220),
                    curve: Curves.easeOutBack,
                    child: Icon(
                      widget.icon,
                      color: AboutSection.primary,
                      size: 22,
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AnimatedDefaultTextStyle(
                        duration: const Duration(milliseconds: 200),
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: _hovering
                              ? FontWeight.w900
                              : FontWeight.w800,
                          color: AboutSection.darkText,
                        ),
                        child: Text(widget.title),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.description,
                        style: const TextStyle(
                          fontSize: 13,
                          height: 1.5,
                          color: AboutSection.bodyText,
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

class _StatCard extends StatefulWidget {
  final String value;
  final String label;

  const _StatCard({required this.value, required this.label});

  @override
  State<_StatCard> createState() => _StatCardState();
}

class _StatCardState extends State<_StatCard> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: Transform.translate(
        offset: Offset(0, _hovering ? -5.0 : 0.0),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 280),
          curve: Curves.easeOutCubic,
          width: 145,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _hovering
                  ? AboutSection.primary.withValues(alpha: 0.25)
                  : const Color(0xFFE1EEF2),
            ),
            boxShadow: [
              BoxShadow(
                color: _hovering
                    ? AboutSection.primary.withValues(alpha: 0.12)
                    : Colors.black.withValues(alpha: 0.025),
                blurRadius: _hovering ? 22 : 15,
                offset: Offset(0, _hovering ? 10 : 7),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 220),
                style: TextStyle(
                  fontSize: _hovering ? 22 : 20,
                  fontWeight: FontWeight.w900,
                  color: AboutSection.primary,
                ),
                child: Text(widget.value),
              ),
              const SizedBox(height: 4),
              Text(
                widget.label,
                style: const TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w600,
                  color: AboutSection.bodyText,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
