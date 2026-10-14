import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HowItWorksSection extends StatefulWidget {
  const HowItWorksSection({super.key});

  static const Color primary = Color(0xFF087EA4);
  static const Color darkText = Color(0xFF102A43);
  static const Color bodyText = Color(0xFF52667A);
  static const Color lightBg = Color(0xFFF6FBFD);

  @override
  State<HowItWorksSection> createState() => _HowItWorksSectionState();
}

class _HowItWorksSectionState extends State<HowItWorksSection>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  late final Animation<double> _headingFade;
  late final Animation<Offset> _headingSlide;

  late final Animation<double> _contentFade;
  late final Animation<Offset> _contentSlide;

  late final Animation<double> _bottomFade;
  late final Animation<Offset> _bottomSlide;

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
        Tween<Offset>(begin: const Offset(0, 0.15), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.0, 0.30, curve: Curves.easeOutCubic),
          ),
        );

    _contentFade = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.20, 0.65, curve: Curves.easeOut),
    );

    _contentSlide =
        Tween<Offset>(begin: const Offset(0, 0.10), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.20, 0.70, curve: Curves.easeOutCubic),
          ),
        );

    _bottomFade = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.70, 1.0, curve: Curves.easeOut),
    );

    _bottomSlide = Tween<Offset>(begin: const Offset(0, 0.12), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.70, 1.0, curve: Curves.easeOutCubic),
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
    final isTablet = width >= 800 && width < 1100;

    return Container(
      width: double.infinity,
      color: HowItWorksSection.lightBg,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile
            ? 24
            : isTablet
            ? 40
            : 70,
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

          SizedBox(height: isMobile ? 45 : 65),

          FadeTransition(
            opacity: _contentFade,
            child: SlideTransition(
              position: _contentSlide,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1180),
                child: isMobile
                    ? const Column(
                        children: [
                          _DeliveryImage(),
                          SizedBox(height: 35),
                          _MobileSteps(),
                        ],
                      )
                    : Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Expanded(flex: 5, child: _DeliveryImage()),
                          SizedBox(width: isTablet ? 35 : 65),
                          Expanded(
                            flex: 5,
                            child: _DesktopSteps(isTablet: isTablet),
                          ),
                        ],
                      ),
              ),
            ),
          ),

          SizedBox(height: isMobile ? 40 : 55),

          FadeTransition(
            opacity: _bottomFade,
            child: SlideTransition(
              position: _bottomSlide,
              child: _BottomNote(isMobile: isMobile),
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
          tween: Tween(begin: 0.85, end: 1),
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
                  color: HowItWorksSection.primary.withValues(alpha: 0.06),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: const Text(
              'HOW IT WORKS',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.8,
                color: HowItWorksSection.primary,
              ),
            ),
          ),
        ),

        const SizedBox(height: 18),

        Text(
          'Water Delivery Made Simple',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: isMobile ? 31 : 44,
            height: 1.15,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.8,
            color: HowItWorksSection.darkText,
          ),
        ),

        const SizedBox(height: 15),

        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 650),
          child: const Text(
            'Getting the water you need is quick and easy. '
            'Just follow three simple steps.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              height: 1.7,
              color: HowItWorksSection.bodyText,
            ),
          ),
        ),
      ],
    );
  }
}

// ============================================================
// DELIVERY IMAGE
// ============================================================

class _DeliveryImage extends StatefulWidget {
  const _DeliveryImage();

  @override
  State<_DeliveryImage> createState() => _DeliveryImageState();
}

class _DeliveryImageState extends State<_DeliveryImage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  late final Animation<double> _imageScale;
  late final Animation<double> _badgeFade;
  late final Animation<Offset> _badgeSlide;
  late final Animation<double> _bottomFade;
  late final Animation<Offset> _bottomSlide;

  bool _hovering = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1300),
    );

    _imageScale = Tween<double>(
      begin: 1.08,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    _badgeFade = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.35, 0.65, curve: Curves.easeOut),
    );

    _badgeSlide = Tween<Offset>(begin: const Offset(-0.12, 0), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.35, 0.70, curve: Curves.easeOutCubic),
          ),
        );

    _bottomFade = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.45, 0.80, curve: Curves.easeOut),
    );

    _bottomSlide = Tween<Offset>(begin: const Offset(0, 0.12), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.45, 0.80, curve: Curves.easeOutCubic),
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

    return MouseRegion(
      cursor: SystemMouseCursors.basic,
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
      child: AspectRatio(
        aspectRatio: isMobile ? 1.25 : 1.08,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: Stack(
            fit: StackFit.expand,
            children: [
              AnimatedScale(
                scale: _hovering ? 1.035 : 1.0,
                duration: const Duration(milliseconds: 600),
                curve: Curves.easeOutCubic,
                child: ScaleTransition(
                  scale: _imageScale,
                  child: Image.asset(
                    'assets/images/how-it-works/water-delivery.png',
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
                            size: 90,
                            color: HowItWorksSection.primary,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),

              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.02),
                      Colors.black.withValues(alpha: 0.08),
                      Colors.black.withValues(alpha: 0.58),
                    ],
                  ),
                ),
              ),

              Positioned(
                top: 20,
                left: 20,
                child: FadeTransition(
                  opacity: _badgeFade,
                  child: SlideTransition(
                    position: _badgeSlide,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 9,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.94),
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
                            Icons.water_drop_rounded,
                            size: 16,
                            color: HowItWorksSection.primary,
                          ),
                          SizedBox(width: 7),
                          Text(
                            'Fresh Water Delivery',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                              color: HowItWorksSection.darkText,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              Positioned(
                left: 24,
                right: 24,
                bottom: 24,
                child: FadeTransition(
                  opacity: _bottomFade,
                  child: SlideTransition(
                    position: _bottomSlide,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Delivered Across Dubai',
                                style: TextStyle(
                                  fontSize: 21,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'Professional tanker service,'
                                ' right when you need it.',
                                style: TextStyle(
                                  fontSize: 13,
                                  height: 1.45,
                                  color: Colors.white.withValues(alpha: 0.88),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 15),
                        Transform.translate(
                          offset: Offset(0, _hovering ? -5 : 0),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 350),
                            curve: Curves.easeOutCubic,
                            width: 52,
                            height: 52,
                            decoration: BoxDecoration(
                              color: HowItWorksSection.primary,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: HowItWorksSection.primary.withValues(
                                    alpha: _hovering ? 0.35 : 0.18,
                                  ),
                                  blurRadius: _hovering ? 20 : 12,
                                  offset: const Offset(0, 7),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.local_shipping_rounded,
                              color: Colors.white,
                              size: 25,
                            ),
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

// ============================================================
// DESKTOP STEPS
// ============================================================

class _DesktopSteps extends StatelessWidget {
  final bool isTablet;

  const _DesktopSteps({required this.isTablet});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const _AnimatedStepCard(
          number: '01',
          icon: Icons.edit_note_rounded,
          title: 'Request Your Water',
          description: 'Tell us your location, water requirement and preferred delivery time.',
          delay: 0,
        ),

        const _AnimatedVerticalConnector(delay: 150),

        const _AnimatedStepCard(
          number: '02',
          icon: Icons.local_shipping_rounded,
          title: 'We Dispatch a Tanker',
          description: 'Our team confirms your request and arranges the right tanker for your needs.',
          delay: 300,
        ),

        const _AnimatedVerticalConnector(delay: 450),

        const _AnimatedStepCard(
          number: '03',
          icon: Icons.water_drop_rounded,
          title: 'Water Delivered',
          description: 'Our tanker arrives at your location and delivers your water safely and efficiently.',
          delay: 600,
        ),
      ],
    );
  }
}

// ============================================================
// MOBILE STEPS
// ============================================================

class _MobileSteps extends StatelessWidget {
  const _MobileSteps();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        _AnimatedStepCard(
          number: '01',
          icon: Icons.edit_note_rounded,
          title: 'Request Your Water',
          description: 'Tell us your location, water requirement and preferred delivery time.',
          delay: 0,
        ),
        _AnimatedMobileConnector(delay: 150),
        _AnimatedStepCard(
          number: '02',
          icon: Icons.local_shipping_rounded,
          title: 'We Dispatch a Tanker',
          description: 'Our team confirms your request and arranges the right tanker for your needs.',
          delay: 300,
        ),
        _AnimatedMobileConnector(delay: 450),
        _AnimatedStepCard(
          number: '03',
          icon: Icons.water_drop_rounded,
          title: 'Water Delivered',
          description: 'Our tanker arrives at your location and delivers your water safely and efficiently.',
          delay: 600,
        ),
      ],
    );
  }
}

// ============================================================
// ANIMATED STEP CARD
// ============================================================

class _AnimatedStepCard extends StatefulWidget {
  final String number;
  final IconData icon;
  final String title;
  final String description;
  final int delay;

  const _AnimatedStepCard({
    required this.number,
    required this.icon,
    required this.title,
    required this.description,
    required this.delay,
  });

  @override
  State<_AnimatedStepCard> createState() => _AnimatedStepCardState();
}

class _AnimatedStepCardState extends State<_AnimatedStepCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  bool _hovering = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
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
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 800;

    return MouseRegion(
      cursor: SystemMouseCursors.basic,
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
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final curved = Curves.easeOutCubic.transform(_controller.value);

          return Opacity(
            opacity: curved,
            child: Transform.translate(
              offset: Offset(0, 25 * (1 - curved)),
              child: child,
            ),
          );
        },
        child: Transform.translate(
          offset: Offset(0, _hovering ? -6 : 0),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutCubic,
            padding: const EdgeInsets.fromLTRB(24, 22, 24, 24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(
                color: _hovering
                    ? HowItWorksSection.primary.withValues(alpha: 0.35)
                    : const Color(0xFFE1EEF2),
              ),
              boxShadow: [
                BoxShadow(
                  color: _hovering
                      ? HowItWorksSection.primary.withValues(alpha: 0.12)
                      : Colors.black.withValues(alpha: 0.035),
                  blurRadius: _hovering ? 28 : 20,
                  offset: Offset(0, _hovering ? 14 : 10),
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AnimatedScale(
                  scale: _hovering ? 1.06 : 1.0,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOutBack,
                  child: Container(
                    width: 58,
                    height: 58,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFF18A6C8), Color(0xFF087EA4)],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: HowItWorksSection.primary.withValues(
                            alpha: _hovering ? 0.30 : 0.18,
                          ),
                          blurRadius: _hovering ? 22 : 15,
                          offset: const Offset(0, 7),
                        ),
                      ],
                    ),
                    child: Icon(widget.icon, color: Colors.white, size: 27),
                  ),
                ),

                const SizedBox(width: 18),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              widget.title,
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w800,
                                color: HowItWorksSection.darkText,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            widget.number,
                            style: const TextStyle(
                              fontSize: 27,
                              height: 1,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFFE2F2F6),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 8),

                      Text(
                        widget.description,
                        style: const TextStyle(
                          fontSize: 13,
                          height: 1.6,
                          color: HowItWorksSection.bodyText,
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
// ANIMATED VERTICAL CONNECTOR
// ============================================================

class _AnimatedVerticalConnector extends StatefulWidget {
  final int delay;

  const _AnimatedVerticalConnector({required this.delay});

  @override
  State<_AnimatedVerticalConnector> createState() =>
      _AnimatedVerticalConnectorState();
}

class _AnimatedVerticalConnectorState extends State<_AnimatedVerticalConnector>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
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
    return SizedBox(
      height: 28,
      child: Row(
        children: [
          const SizedBox(width: 28),
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Align(
                alignment: Alignment.topCenter,
                child: Container(
                  width: 2,
                  height: 28 * _controller.value,
                  color: const Color(0xFFB9E8F1),
                ),
              );
            },
          ),
          const SizedBox(width: 28),
          FadeTransition(
            opacity: _controller,
            child: const Icon(
              Icons.keyboard_arrow_down_rounded,
              color: HowItWorksSection.primary,
              size: 19,
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// ANIMATED MOBILE CONNECTOR
// ============================================================

class _AnimatedMobileConnector extends StatefulWidget {
  final int delay;

  const _AnimatedMobileConnector({required this.delay});

  @override
  State<_AnimatedMobileConnector> createState() =>
      _AnimatedMobileConnectorState();
}

class _AnimatedMobileConnectorState extends State<_AnimatedMobileConnector>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

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
    return SizedBox(
      height: 40,
      child: Column(
        children: [
          Expanded(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    width: 2,
                    height: 20 * _controller.value,
                    color: const Color(0xFFB9E8F1),
                  ),
                );
              },
            ),
          ),
          FadeTransition(
            opacity: _controller,
            child: const Icon(
              Icons.keyboard_arrow_down_rounded,
              color: HowItWorksSection.primary,
              size: 21,
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// BOTTOM NOTE
// ============================================================

class _BottomNote extends StatefulWidget {
  final bool isMobile;

  const _BottomNote({required this.isMobile});

  // Contact number.
  // Replace with the client's final WhatsApp number before launch.
  static const String whatsappNumber = '971551027786';

  @override
  State<_BottomNote> createState() => _BottomNoteState();
}

class _BottomNoteState extends State<_BottomNote> {
  bool _hovering = false;

  Future<void> _openWhatsApp() async {
    final message = Uri.encodeComponent(
      'Hello Sweet Water Tankers, I need help choosing the right water supply.',
    );

    final uri = Uri.parse(
      'https://wa.me/${_BottomNote.whatsappNumber}?text=$message',
    );

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    // Extra protection for very narrow phones.
    final isVerySmall = width < 380;

    return MouseRegion(
      cursor: SystemMouseCursors.basic,
      onEnter: (_) {
        if (!widget.isMobile) {
          setState(() => _hovering = true);
        }
      },
      onExit: (_) {
        if (!widget.isMobile) {
          setState(() => _hovering = false);
        }
      },
      child: Transform.translate(
        offset: Offset(0, _hovering ? -4 : 0),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
          width: double.infinity,
          constraints: const BoxConstraints(maxWidth: 900),
          padding: EdgeInsets.symmetric(
            horizontal: isVerySmall
                ? 14
                : widget.isMobile
                ? 20
                : 30,
            vertical: 20,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: _hovering
                  ? HowItWorksSection.primary.withValues(alpha: 0.25)
                  : const Color(0xFFE1EEF2),
            ),
            boxShadow: [
              BoxShadow(
                color: _hovering
                    ? HowItWorksSection.primary.withValues(alpha: 0.08)
                    : Colors.black.withValues(alpha: 0.025),
                blurRadius: _hovering ? 25 : 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: isVerySmall ? 38 : 42,
                height: isVerySmall ? 38 : 42,
                decoration: BoxDecoration(
                  color: const Color(0xFFEAF8FB),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.support_agent_rounded,
                  color: HowItWorksSection.primary,
                  size: 21,
                ),
              ),

              SizedBox(width: isVerySmall ? 10 : 14),

              Expanded(
                child: Text(
                  'Need help choosing the right water supply?',
                  maxLines: widget.isMobile ? 3 : 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: isVerySmall ? 13 : 14,
                    height: 1.45,
                    fontWeight: FontWeight.w700,
                    color: HowItWorksSection.darkText,
                  ),
                ),
              ),

              if (!widget.isMobile) ...[
                const SizedBox(width: 10),
                TextButton(
                  onPressed: _openWhatsApp,
                  child: AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 200),
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: _hovering
                          ? const Color(0xFF065F7C)
                          : HowItWorksSection.primary,
                    ),
                    child: const Text('Talk to Us'),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
