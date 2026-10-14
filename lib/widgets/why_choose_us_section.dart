import 'package:flutter/material.dart';

class WhyChooseUsSection extends StatefulWidget {
  const WhyChooseUsSection({super.key});

  static const Color primary = Color(0xFF087EA4);
  static const Color darkText = Color(0xFF102A43);
  static const Color bodyText = Color(0xFF52667A);
  static const Color lightBg = Color(0xFFF6FBFD);

  @override
  State<WhyChooseUsSection> createState() => _WhyChooseUsSectionState();
}

class _WhyChooseUsSectionState extends State<WhyChooseUsSection>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  late final Animation<double> _headingFade;
  late final Animation<Offset> _headingSlide;

  late final Animation<double> _visualFade;
  late final Animation<Offset> _visualSlide;

  late final Animation<double> _benefitsFade;
  late final Animation<Offset> _benefitsSlide;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _headingFade = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.24, curve: Curves.easeOut),
    );

    _headingSlide =
        Tween<Offset>(begin: const Offset(0, 0.10), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.0, 0.24, curve: Curves.easeOutCubic),
          ),
        );

    _visualFade = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.15, 0.68, curve: Curves.easeOut),
    );

    _visualSlide =
        Tween<Offset>(begin: const Offset(-0.08, 0), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.15, 0.68, curve: Curves.easeOutCubic),
          ),
        );

    _benefitsFade = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.25, 0.82, curve: Curves.easeOut),
    );

    _benefitsSlide =
        Tween<Offset>(begin: const Offset(0.08, 0), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.25, 0.82, curve: Curves.easeOutCubic),
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
      color: Colors.white,
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
              child: _SectionHeading(isMobile: isMobile),
            ),
          ),

          const SizedBox(height: 55),

          isMobile
              ? Column(
                  children: [
                    FadeTransition(
                      opacity: _visualFade,
                      child: SlideTransition(
                        position: _visualSlide,
                        child: const _MainVisual(),
                      ),
                    ),
                    const SizedBox(height: 45),
                    FadeTransition(
                      opacity: _benefitsFade,
                      child: SlideTransition(
                        position: _benefitsSlide,
                        child: const _Benefits(),
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
                          child: const _MainVisual(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 65),
                    Expanded(
                      flex: 5,
                      child: FadeTransition(
                        opacity: _benefitsFade,
                        child: SlideTransition(
                          position: _benefitsSlide,
                          child: const _Benefits(),
                        ),
                      ),
                    ),
                  ],
                ),
        ],
      ),
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
        TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: 1.0),
          duration: const Duration(milliseconds: 850),
          curve: Curves.easeOutBack,
          builder: (context, value, child) {
            return Transform.scale(
              scale: 0.88 + (value * 0.12),
              child: Opacity(opacity: value.clamp(0.0, 1.0), child: child),
            );
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFEAF8FB),
              borderRadius: BorderRadius.circular(30),
            ),
            child: const Text(
              'WHY CHOOSE US',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.8,
                color: WhyChooseUsSection.primary,
              ),
            ),
          ),
        ),

        const SizedBox(height: 18),

        Text(
          'Reliable Water. Professional Service.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: isMobile ? 31 : 44,
            height: 1.15,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.8,
            color: WhyChooseUsSection.darkText,
          ),
        ),

        const SizedBox(height: 15),

        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 670),
          child: const Text(
            'We make water delivery simple, dependable and stress-free '
            'with fast response times and professional service across Dubai.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              height: 1.7,
              color: WhyChooseUsSection.bodyText,
            ),
          ),
        ),
      ],
    );
  }
}

// ============================================================
// MAIN VISUAL
// ============================================================

class _MainVisual extends StatefulWidget {
  const _MainVisual();

  @override
  State<_MainVisual> createState() => _MainVisualState();
}

class _MainVisualState extends State<_MainVisual>
    with SingleTickerProviderStateMixin {
  late final AnimationController _floatController;

  @override
  void initState() {
    super.initState();

    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3200),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _floatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFE8F9FC), Color(0xFFD4F1F6)],
        ),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // ==================================================
          // BACKGROUND CIRCLE
          // ==================================================

          Positioned(
            top: -80,
            right: -70,
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: const Duration(milliseconds: 1400),
              curve: Curves.easeOutCubic,
              builder: (context, value, child) {
                return Transform.scale(
                  scale: 0.85 + (value * 0.15),
                  child: Opacity(opacity: value.clamp(0.0, 1.0), child: child),
                );
              },
              child: Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.65),
                ),
              ),
            ),
          ),

          // ==================================================
          // BACKGROUND CIRCLE
          // ==================================================
          Positioned(
            bottom: -100,
            left: -80,
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: const Duration(milliseconds: 1500),
              curve: Curves.easeOutCubic,
              builder: (context, value, child) {
                return Transform.scale(
                  scale: 0.85 + (value * 0.15),
                  child: Opacity(opacity: value.clamp(0.0, 1.0), child: child),
                );
              },
              child: Container(
                width: 270,
                height: 270,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: WhyChooseUsSection.primary.withValues(alpha: 0.08),
                ),
              ),
            ),
          ),

          // ==================================================
          // CENTER TANKER ICON
          // ==================================================
          Center(
            child: AnimatedBuilder(
              animation: _floatController,
              builder: (context, child) {
                final value = Curves.easeInOut.transform(
                  _floatController.value,
                );

                final offset = (value * 2) - 1;

                return Transform.translate(
                  offset: Offset(0, offset * 7),
                  child: child,
                );
              },
              child: Container(
                width: 235,
                height: 235,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.85),
                  boxShadow: [
                    BoxShadow(
                      color: WhyChooseUsSection.primary.withValues(alpha: 0.12),
                      blurRadius: 35,
                      offset: const Offset(0, 15),
                    ),
                  ],
                ),
                child: const Center(
                  child: Icon(
                    Icons.local_shipping_rounded,
                    size: 115,
                    color: WhyChooseUsSection.primary,
                  ),
                ),
              ),
            ),
          ),

          // ==================================================
          // TOP BADGE
          // ==================================================
          Positioned(
            top: 28,
            left: 28,
            child: _AnimatedFloatingBadge(
              icon: Icons.verified_rounded,
              text: 'Trusted Service',
              direction: -1,
            ),
          ),

          // ==================================================
          // BOTTOM RIGHT BADGE
          // ==================================================
          Positioned(
            bottom: 28,
            right: 28,
            child: _AnimatedFloatingBadge(
              icon: Icons.location_on_rounded,
              text: 'Dubai Wide',
              direction: 1,
            ),
          ),

          // ==================================================
          // 24/7 BADGE
          // ==================================================
          Positioned(
            bottom: 28,
            left: 28,
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: const Duration(milliseconds: 1100),
              curve: Curves.easeOutBack,
              builder: (context, value, child) {
                return Opacity(
                  opacity: value.clamp(0.0, 1.0),
                  child: Transform.translate(
                    offset: Offset(0, 12 * (1 - value)),
                    child: child,
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.06),
                      blurRadius: 18,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.access_time_filled_rounded,
                      size: 17,
                      color: Color(0xFF16A085),
                    ),
                    SizedBox(width: 7),
                    Text(
                      'Available 24/7',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: WhyChooseUsSection.darkText,
                      ),
                    ),
                  ],
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
// ANIMATED FLOATING BADGE
// ============================================================

class _AnimatedFloatingBadge extends StatefulWidget {
  final IconData icon;
  final String text;
  final int direction;

  const _AnimatedFloatingBadge({
    required this.icon,
    required this.text,
    required this.direction,
  });

  @override
  State<_AnimatedFloatingBadge> createState() => _AnimatedFloatingBadgeState();
}

class _AnimatedFloatingBadgeState extends State<_AnimatedFloatingBadge>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2800),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final value = Curves.easeInOut.transform(_controller.value);

        return Transform.translate(
          offset: Offset(value * 3 * widget.direction, -value * 4),
          child: child,
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(widget.icon, size: 17, color: WhyChooseUsSection.primary),
            const SizedBox(width: 7),
            Text(
              widget.text,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                color: WhyChooseUsSection.darkText,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// BENEFITS
// ============================================================

class _Benefits extends StatelessWidget {
  const _Benefits();

  @override
  Widget build(BuildContext context) {
    final benefits = [
      _BenefitData(
        icon: Icons.schedule_rounded,
        title: '24/7 Availability',
        description: 'Water delivery when you need it, including urgent and after-hours requirements.',
      ),
      _BenefitData(
        icon: Icons.speed_rounded,
        title: 'Fast Response',
        description: 'Quick dispatch and dependable delivery to help keep your property or project running.',
      ),
      _BenefitData(
        icon: Icons.verified_user_rounded,
        title: 'Quality & Reliability',
        description: 'Professional water tanker service focused on consistent quality and dependable supply.',
      ),
      _BenefitData(
        icon: Icons.local_shipping_rounded,
        title: 'Modern Fleet',
        description: 'A capable tanker fleet designed to handle residential, commercial and bulk requirements.',
      ),
      _BenefitData(
        icon: Icons.location_on_rounded,
        title: 'Dubai Wide Coverage',
        description: 'Serving customers across Dubai with flexible delivery options for different locations.',
      ),
      _BenefitData(
        icon: Icons.support_agent_rounded,
        title: 'Professional Support',
        description: 'Clear communication and helpful support from enquiry through successful delivery.',
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Everything You Need From a Water Delivery Partner',
          style: TextStyle(
            fontSize: 28,
            height: 1.2,
            fontWeight: FontWeight.w800,
            color: WhyChooseUsSection.darkText,
          ),
        ),

        const SizedBox(height: 14),

        const Text(
          'Whether you need one tanker or regular bulk supply, '
          'our service is built around speed, reliability and convenience.',
          style: TextStyle(
            fontSize: 15,
            height: 1.7,
            color: WhyChooseUsSection.bodyText,
          ),
        ),

        const SizedBox(height: 30),

        ...benefits.asMap().entries.map(
          (entry) => Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: _AnimatedBenefitItem(benefit: entry.value, index: entry.key),
          ),
        ),
      ],
    );
  }
}

// ============================================================
// ANIMATED BENEFIT ITEM
// ============================================================

class _AnimatedBenefitItem extends StatefulWidget {
  final _BenefitData benefit;
  final int index;

  const _AnimatedBenefitItem({required this.benefit, required this.index});

  @override
  State<_AnimatedBenefitItem> createState() => _AnimatedBenefitItemState();
}

class _AnimatedBenefitItemState extends State<_AnimatedBenefitItem>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  bool _isHovered = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
    );

    Future.delayed(Duration(milliseconds: 120 + (widget.index * 90)), () {
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

  void _setHover(bool value) {
    if (!mounted) return;

    setState(() {
      _isHovered = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: CurvedAnimation(parent: _controller, curve: Curves.easeOut),
      child: SlideTransition(
        position: Tween<Offset>(begin: const Offset(0.08, 0), end: Offset.zero)
            .animate(
              CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
            ),
        child: MouseRegion(
          cursor: SystemMouseCursors.basic,
          onEnter: (_) => _setHover(true),
          onExit: (_) => _setHover(false),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 240),
            curve: Curves.easeOutCubic,
            transform: Matrix4.translationValues(
              _isHovered ? 5 : 0,
              _isHovered ? -2 : 0,
              0,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 240),
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: _isHovered
                        ? const Color(0xFFDDF4F8)
                        : const Color(0xFFEAF8FB),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: AnimatedScale(
                    scale: _isHovered ? 1.10 : 1.0,
                    duration: const Duration(milliseconds: 240),
                    curve: Curves.easeOutBack,
                    child: Icon(
                      widget.benefit.icon,
                      color: WhyChooseUsSection.primary,
                      size: 22,
                    ),
                  ),
                ),

                const SizedBox(width: 15),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.benefit.title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: WhyChooseUsSection.darkText,
                        ),
                      ),

                      const SizedBox(height: 5),

                      Text(
                        widget.benefit.description,
                        style: const TextStyle(
                          fontSize: 13.5,
                          height: 1.55,
                          color: WhyChooseUsSection.bodyText,
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
// DATA
// ============================================================

class _BenefitData {
  final IconData icon;
  final String title;
  final String description;

  const _BenefitData({
    required this.icon,
    required this.title,
    required this.description,
  });
}
