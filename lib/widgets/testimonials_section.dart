import 'package:flutter/material.dart';

class TestimonialsSection extends StatefulWidget {
  const TestimonialsSection({super.key});

  static const Color primary = Color(0xFF087EA4);
  static const Color darkText = Color(0xFF102A43);
  static const Color bodyText = Color(0xFF52667A);
  static const Color lightBg = Color(0xFFF6FBFD);

  @override
  State<TestimonialsSection> createState() => _TestimonialsSectionState();
}

class _TestimonialsSectionState extends State<TestimonialsSection>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  late final Animation<double> _headingFade;
  late final Animation<Offset> _headingSlide;

  late final Animation<double> _gridFade;
  late final Animation<Offset> _gridSlide;

  late final Animation<double> _trustFade;
  late final Animation<Offset> _trustSlide;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _headingFade = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.30, curve: Curves.easeOut),
    );

    _headingSlide =
        Tween<Offset>(begin: const Offset(0, 0.12), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.0, 0.30, curve: Curves.easeOutCubic),
          ),
        );

    _gridFade = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.18, 0.68, curve: Curves.easeOut),
    );

    _gridSlide = Tween<Offset>(begin: const Offset(0, 0.10), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.18, 0.68, curve: Curves.easeOutCubic),
          ),
        );

    _trustFade = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.55, 1.0, curve: Curves.easeOut),
    );

    _trustSlide = Tween<Offset>(begin: const Offset(0, 0.08), end: Offset.zero)
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
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 800;

    return Container(
      width: double.infinity,
      color: TestimonialsSection.lightBg,
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

          FadeTransition(
            opacity: _gridFade,
            child: SlideTransition(
              position: _gridSlide,
              child: _TestimonialsGrid(isMobile: isMobile),
            ),
          ),

          const SizedBox(height: 45),

          FadeTransition(
            opacity: _trustFade,
            child: SlideTransition(
              position: _trustSlide,
              child: _TrustRow(isMobile: isMobile),
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
          tween: Tween(begin: 0.0, end: 1.0),
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeOutBack,
          builder: (context, value, child) {
            return Transform.scale(
              scale: 0.85 + (value * 0.15),
              child: Opacity(opacity: value.clamp(0.0, 1.0), child: child),
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
              'CUSTOMER REVIEWS',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.8,
                color: TestimonialsSection.primary,
              ),
            ),
          ),
        ),

        const SizedBox(height: 18),

        Text(
          'Trusted by Customers Across Dubai',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: isMobile ? 31 : 44,
            height: 1.15,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.8,
            color: TestimonialsSection.darkText,
          ),
        ),

        const SizedBox(height: 15),

        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 680),
          child: const Text(
            'Reliable service, fast response and professional water delivery '
            'are what our customers value most.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              height: 1.7,
              color: TestimonialsSection.bodyText,
            ),
          ),
        ),
      ],
    );
  }
}

// ============================================================
// TESTIMONIALS GRID
// ============================================================

class _TestimonialsGrid extends StatelessWidget {
  final bool isMobile;

  const _TestimonialsGrid({required this.isMobile});

  @override
  Widget build(BuildContext context) {
    const testimonials = [
      _TestimonialData(
        initials: 'AK',
        name: 'Ahmed K.',
        type: 'Villa Owner',
        review:
            'Excellent service. The tanker arrived on time and the whole '
            'delivery process was very smooth. I would definitely use them again.',
      ),
      _TestimonialData(
        initials: 'MR',
        name: 'Mohammed R.',
        type: 'Business Owner',
        review:
            'Very professional team and quick response. We needed water '
            'for our commercial property and they handled everything perfectly.',
      ),
      _TestimonialData(
        initials: 'SA',
        name: 'Sara A.',
        type: 'Property Manager',
        review:
            'Reliable and easy to deal with. Communication was clear and '
            'the delivery reached our property exactly when expected.',
      ),
    ];

    if (isMobile) {
      return Column(
        children: testimonials.asMap().entries.map((entry) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 18),
            child: _TestimonialCard(testimonial: entry.value, index: entry.key),
          );
        }).toList(),
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: testimonials.asMap().entries.map((entry) {
        final isLast = entry.key == testimonials.length - 1;

        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: isLast ? 0 : 18),
            child: _TestimonialCard(testimonial: entry.value, index: entry.key),
          ),
        );
      }).toList(),
    );
  }
}

// ============================================================
// TESTIMONIAL CARD
// ============================================================

class _TestimonialCard extends StatefulWidget {
  final _TestimonialData testimonial;
  final int index;

  const _TestimonialCard({required this.testimonial, required this.index});

  @override
  State<_TestimonialCard> createState() => _TestimonialCardState();
}

class _TestimonialCardState extends State<_TestimonialCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  bool _isHovered = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 750 + (widget.index * 130)),
    );

    Future.delayed(Duration(milliseconds: 120 + (widget.index * 130)), () {
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
        position: Tween<Offset>(begin: const Offset(0, 0.12), end: Offset.zero)
            .animate(
              CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
            ),
        child: MouseRegion(
          cursor: SystemMouseCursors.basic,
          onEnter: (_) => _setHover(true),
          onExit: (_) => _setHover(false),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 260),
            curve: Curves.easeOutCubic,
            transform: Matrix4.translationValues(0, _isHovered ? -8 : 0, 0),
            padding: const EdgeInsets.all(26),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(23),
              border: Border.all(
                color: _isHovered
                    ? const Color(0xFFB9E8F1)
                    : const Color(0xFFE1EEF2),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(
                    alpha: _isHovered ? 0.075 : 0.035,
                  ),
                  blurRadius: _isHovered ? 28 : 20,
                  offset: Offset(0, _isHovered ? 14 : 8),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ==================================================
                // STARS
                // ==================================================

                Row(
                  children: List.generate(5, (index) {
                    return TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0.0, end: 1.0),
                      duration: Duration(milliseconds: 400 + (index * 90)),
                      curve: Curves.easeOutBack,
                      builder: (context, value, child) {
                        return Transform.scale(
                          scale: 0.5 + (value * 0.5),
                          child: Opacity(
                            opacity: value.clamp(0.0, 1.0),
                            child: child,
                          ),
                        );
                      },
                      child: const Padding(
                        padding: EdgeInsets.only(right: 3),
                        child: Icon(
                          Icons.star_rounded,
                          size: 18,
                          color: Color(0xFFF5B83D),
                        ),
                      ),
                    );
                  }),
                ),

                const SizedBox(height: 20),

                // ==================================================
                // QUOTE ICON
                // ==================================================
                AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  transform: Matrix4.translationValues(
                    _isHovered ? 4 : 0,
                    0,
                    0,
                  ),
                  child: Icon(
                    Icons.format_quote_rounded,
                    size: _isHovered ? 36 : 32,
                    color: const Color(0xFFD9F1F5),
                  ),
                ),

                const SizedBox(height: 5),

                // ==================================================
                // REVIEW
                // ==================================================
                Text(
                  widget.testimonial.review,
                  style: const TextStyle(
                    fontSize: 14,
                    height: 1.65,
                    color: TestimonialsSection.bodyText,
                  ),
                ),

                const SizedBox(height: 24),

                const Divider(color: Color(0xFFEAF1F3), height: 1),

                const SizedBox(height: 20),

                // ==================================================
                // CUSTOMER
                // ==================================================
                Row(
                  children: [
                    AnimatedScale(
                      scale: _isHovered ? 1.08 : 1.0,
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeOutBack,
                      child: Container(
                        width: 45,
                        height: 45,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [Color(0xFF18A6C8), Color(0xFF087EA4)],
                          ),
                        ),
                        child: Center(
                          child: Text(
                            widget.testimonial.initials,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.testimonial.name,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                              color: TestimonialsSection.darkText,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            widget.testimonial.type,
                            style: const TextStyle(
                              fontSize: 11,
                              color: TestimonialsSection.bodyText,
                            ),
                          ),
                        ],
                      ),
                    ),

                    AnimatedScale(
                      scale: _isHovered ? 1.18 : 1.0,
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeOutBack,
                      child: const Icon(
                        Icons.verified_rounded,
                        size: 18,
                        color: TestimonialsSection.primary,
                      ),
                    ),
                  ],
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
// TRUST ROW
// ============================================================

class _TrustRow extends StatelessWidget {
  final bool isMobile;

  const _TrustRow({required this.isMobile});

  @override
  Widget build(BuildContext context) {
    final items = [
      _TrustData(
        icon: Icons.star_rounded,
        value: '5.0',
        label: 'Customer Rating',
      ),
      _TrustData(
        icon: Icons.local_shipping_rounded,
        value: 'Fast',
        label: 'Water Delivery',
      ),
      _TrustData(
        icon: Icons.support_agent_rounded,
        value: '24/7',
        label: 'Customer Support',
      ),
    ];

    if (isMobile) {
      return Column(
        children: items.asMap().entries.map((entry) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _TrustItem(item: entry.value, index: entry.key),
          );
        }).toList(),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE1EEF2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.025),
            blurRadius: 18,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: Row(
        children: items.asMap().entries.map((entry) {
          return Expanded(
            child: _TrustItem(item: entry.value, index: entry.key),
          );
        }).toList(),
      ),
    );
  }
}

// ============================================================
// TRUST ITEM
// ============================================================

class _TrustItem extends StatefulWidget {
  final _TrustData item;
  final int index;

  const _TrustItem({required this.item, required this.index});

  @override
  State<_TrustItem> createState() => _TrustItemState();
}

class _TrustItemState extends State<_TrustItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.basic,
      onEnter: (_) {
        setState(() {
          _isHovered = true;
        });
      },
      onExit: (_) {
        setState(() {
          _isHovered = false;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 240),
        curve: Curves.easeOutCubic,
        transform: Matrix4.translationValues(0, _isHovered ? -3 : 0, 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 240),
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: _isHovered
                    ? const Color(0xFFDDF4F8)
                    : const Color(0xFFEAF8FB),
                borderRadius: BorderRadius.circular(12),
              ),
              child: AnimatedScale(
                scale: _isHovered ? 1.12 : 1.0,
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeOutBack,
                child: Icon(
                  widget.item.icon,
                  size: 20,
                  color: TestimonialsSection.primary,
                ),
              ),
            ),

            const SizedBox(width: 11),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.item.value,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: TestimonialsSection.darkText,
                  ),
                ),

                const SizedBox(height: 2),

                Text(
                  widget.item.label,
                  style: const TextStyle(
                    fontSize: 11,
                    color: TestimonialsSection.bodyText,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// DATA
// ============================================================

class _TestimonialData {
  final String initials;
  final String name;
  final String type;
  final String review;

  const _TestimonialData({
    required this.initials,
    required this.name,
    required this.type,
    required this.review,
  });
}

class _TrustData {
  final IconData icon;
  final String value;
  final String label;

  const _TrustData({
    required this.icon,
    required this.value,
    required this.label,
  });
}
