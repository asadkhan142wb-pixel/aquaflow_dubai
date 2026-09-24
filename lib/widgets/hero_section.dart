import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HeroSection extends StatefulWidget {
  final VoidCallback? onGetWaterNow;

  const HeroSection({super.key, this.onGetWaterNow});

  static const Color primary = Color(0xFF087EA4);
  static const Color darkText = Color(0xFF102A43);
  static const Color bodyText = Color(0xFF52667A);

  static const String phoneNumber = '+923104939138';

  @override
  State<HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends State<HeroSection>
    with TickerProviderStateMixin {
  // ============================================================
  // ANIMATION CONTROLLERS
  // ============================================================

  late final AnimationController _entranceController;
  late final AnimationController _floatingController;
  late final AnimationController _badgeController;
  late final AnimationController _backgroundController;

  // ============================================================
  // ENTRANCE ANIMATIONS
  // ============================================================

  late final Animation<double> _badgeFade;
  late final Animation<Offset> _badgeSlide;

  late final Animation<double> _headingFade;
  late final Animation<Offset> _headingSlide;

  late final Animation<double> _descriptionFade;
  late final Animation<Offset> _descriptionSlide;

  late final Animation<double> _buttonsFade;
  late final Animation<Offset> _buttonsSlide;

  late final Animation<double> _trustFade;
  late final Animation<Offset> _trustSlide;

  late final Animation<double> _imageFade;
  late final Animation<double> _imageScale;

  // ============================================================
  // CONTINUOUS ANIMATIONS
  // ============================================================

  late final Animation<double> _floatingAnimation;
  late final Animation<double> _badgePulse;
  late final Animation<double> _backgroundPulse;

  // ============================================================
  // HOVER STATES
  // ============================================================

  bool _waterButtonHover = false;
  bool _callButtonHover = false;
  bool _imageHover = false;

  @override
  void initState() {
    super.initState();

    // ==========================================================
    // MAIN ENTRANCE
    // ==========================================================

    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    // ==========================================================
    // AVAILABILITY BADGE
    // ==========================================================

    _badgeFade = CurvedAnimation(
      parent: _entranceController,
      curve: const Interval(0.00, 0.28, curve: Curves.easeOut),
    );

    _badgeSlide = Tween<Offset>(begin: const Offset(0, 0.35), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _entranceController,
            curve: const Interval(0.00, 0.28, curve: Curves.easeOutCubic),
          ),
        );

    // ==========================================================
    // HEADING
    // ==========================================================

    _headingFade = CurvedAnimation(
      parent: _entranceController,
      curve: const Interval(0.12, 0.48, curve: Curves.easeOut),
    );

    _headingSlide =
        Tween<Offset>(begin: const Offset(0, 0.30), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _entranceController,
            curve: const Interval(0.12, 0.48, curve: Curves.easeOutCubic),
          ),
        );

    // ==========================================================
    // DESCRIPTION
    // ==========================================================

    _descriptionFade = CurvedAnimation(
      parent: _entranceController,
      curve: const Interval(0.25, 0.58, curve: Curves.easeOut),
    );

    _descriptionSlide =
        Tween<Offset>(begin: const Offset(0, 0.25), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _entranceController,
            curve: const Interval(0.25, 0.58, curve: Curves.easeOutCubic),
          ),
        );

    // ==========================================================
    // BUTTONS
    // ==========================================================

    _buttonsFade = CurvedAnimation(
      parent: _entranceController,
      curve: const Interval(0.38, 0.70, curve: Curves.easeOut),
    );

    _buttonsSlide =
        Tween<Offset>(begin: const Offset(0, 0.22), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _entranceController,
            curve: const Interval(0.38, 0.70, curve: Curves.easeOutCubic),
          ),
        );

    // ==========================================================
    // TRUST POINTS
    // ==========================================================

    _trustFade = CurvedAnimation(
      parent: _entranceController,
      curve: const Interval(0.52, 0.82, curve: Curves.easeOut),
    );

    _trustSlide = Tween<Offset>(begin: const Offset(0, 0.20), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _entranceController,
            curve: const Interval(0.52, 0.82, curve: Curves.easeOutCubic),
          ),
        );

    // ==========================================================
    // IMAGE ENTRANCE
    // ==========================================================

    _imageFade = CurvedAnimation(
      parent: _entranceController,
      curve: const Interval(0.18, 0.75, curve: Curves.easeOut),
    );

    _imageScale = Tween<double>(begin: 0.92, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.12, 0.78, curve: Curves.easeOutBack),
      ),
    );

    // ==========================================================
    // IMAGE FLOATING
    // ==========================================================

    _floatingController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4200),
    )..repeat(reverse: true);

    _floatingAnimation = Tween<double>(begin: -5, end: 5).animate(
      CurvedAnimation(parent: _floatingController, curve: Curves.easeInOut),
    );

    // ==========================================================
    // BADGE PULSE
    // ==========================================================

    _badgeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);

    _badgePulse = Tween<double>(begin: 0.94, end: 1.0).animate(
      CurvedAnimation(parent: _badgeController, curve: Curves.easeInOut),
    );

    // ==========================================================
    // BACKGROUND PULSE
    // ==========================================================

    _backgroundController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 5000),
    )..repeat(reverse: true);

    _backgroundPulse = Tween<double>(begin: 0.85, end: 1.15).animate(
      CurvedAnimation(parent: _backgroundController, curve: Curves.easeInOut),
    );

    // ==========================================================
    // START
    // ==========================================================

    _entranceController.forward();
  }

  @override
  void dispose() {
    _entranceController.dispose();
    _floatingController.dispose();
    _badgeController.dispose();
    _backgroundController.dispose();
    super.dispose();
  }

  // ============================================================
  // PHONE
  // ============================================================

  Future<void> _makeCall() async {
    final uri = Uri.parse('tel:${HeroSection.phoneNumber}');

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    final bool isMobile = width < 850;
    final bool isSmallMobile = width < 600;
    final bool isTablet = width >= 850 && width < 1200;

    return Container(
      width: double.infinity,
      constraints: BoxConstraints(minHeight: isMobile ? 720 : 650),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFEFFBFF), Color(0xFFDDF5FA), Color(0xFFF8FCFD)],
        ),
      ),
      child: Stack(
        children: [
          // ======================================================
          // ANIMATED BACKGROUND GLOW 1
          // ======================================================

          AnimatedBuilder(
            animation: _backgroundPulse,
            builder: (context, child) {
              final double scale = _backgroundPulse.value;

              return Positioned(
                right: -120,
                top: -120,
                child: Transform.scale(
                  scale: scale,
                  child: Container(
                    width: 400,
                    height: 400,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: HeroSection.primary.withValues(alpha: 0.06),
                    ),
                  ),
                ),
              );
            },
          ),

          // ======================================================
          // ANIMATED BACKGROUND GLOW 2
          // ======================================================
          AnimatedBuilder(
            animation: _backgroundPulse,
            builder: (context, child) {
              final double scale = 1.10 - (_backgroundPulse.value - 0.85) * 0.5;

              return Positioned(
                left: -180,
                bottom: -180,
                child: Transform.scale(
                  scale: scale,
                  child: Container(
                    width: 450,
                    height: 450,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFF18A6C8).withValues(alpha: 0.05),
                    ),
                  ),
                ),
              );
            },
          ),

          // ======================================================
          // CONTENT
          // ======================================================
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isSmallMobile
                  ? 20
                  : isMobile
                  ? 28
                  : isTablet
                  ? 45
                  : 70,
              vertical: isMobile ? 50 : 75,
            ),
            child: isMobile
                ? _mobileContent(context)
                : _desktopContent(context),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // DESKTOP CONTENT
  // ============================================================

  Widget _desktopContent(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    final bool isLargeDesktop = width >= 1500;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(flex: isLargeDesktop ? 5 : 5, child: _textContent(context)),
        SizedBox(width: isLargeDesktop ? 70 : 50),
        Expanded(flex: isLargeDesktop ? 5 : 5, child: _animatedHeroImage()),
      ],
    );
  }

  // ============================================================
  // MOBILE CONTENT
  // ============================================================

  Widget _mobileContent(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _textContent(context),
        SizedBox(height: width < 600 ? 40 : 45),
        _animatedHeroImage(),
      ],
    );
  }

  // ============================================================
  // HERO TEXT
  // ============================================================

  Widget _textContent(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    final bool isSmallMobile = width < 400;
    final bool isMobile = width < 600;
    final bool isTablet = width >= 850 && width < 1200;
    final bool isLargeDesktop = width >= 1500;

    final double headingSize;

    if (isSmallMobile) {
      headingSize = 34;
    } else if (isMobile) {
      headingSize = 42;
    } else if (isTablet) {
      headingSize = 50;
    } else if (isLargeDesktop) {
      headingSize = 64;
    } else {
      headingSize = 58;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ======================================================
        // AVAILABILITY BADGE
        // ======================================================

        FadeTransition(
          opacity: _badgeFade,
          child: SlideTransition(
            position: _badgeSlide,
            child: _buildAvailabilityBadge(),
          ),
        ),

        const SizedBox(height: 25),

        // ======================================================
        // HEADING
        // ======================================================
        FadeTransition(
          opacity: _headingFade,
          child: SlideTransition(
            position: _headingSlide,
            child: Text.rich(
              TextSpan(
                children: [
                  const TextSpan(text: 'Reliable Water,\n'),
                  const TextSpan(text: 'Delivered '),
                  TextSpan(
                    text: 'When You Need It.',
                    style: const TextStyle(color: HeroSection.primary),
                  ),
                ],
              ),
              style: TextStyle(
                fontSize: headingSize,
                height: 1.05,
                fontWeight: FontWeight.w800,
                color: HeroSection.darkText,
                letterSpacing: -1.5,
              ),
            ),
          ),
        ),

        const SizedBox(height: 22),

        // ======================================================
        // DESCRIPTION
        // ======================================================
        FadeTransition(
          opacity: _descriptionFade,
          child: SlideTransition(
            position: _descriptionSlide,
            child: Text(
              'Fast, clean and dependable water tanker delivery '
              'for swimming pools, homes, businesses and '
              'construction sites across Dubai.',
              style: TextStyle(
                fontSize: isSmallMobile ? 15 : 17,
                height: 1.7,
                color: HeroSection.bodyText,
              ),
            ),
          ),
        ),

        const SizedBox(height: 32),

        // ======================================================
        // BUTTONS
        // ======================================================
        FadeTransition(
          opacity: _buttonsFade,
          child: SlideTransition(
            position: _buttonsSlide,
            child: Wrap(
              spacing: 14,
              runSpacing: 14,
              children: [_buildPrimaryButton(), _buildCallButton()],
            ),
          ),
        ),

        const SizedBox(height: 40),

        // ======================================================
        // TRUST POINTS
        // ======================================================
        FadeTransition(
          opacity: _trustFade,
          child: SlideTransition(
            position: _trustSlide,
            child: Wrap(
              spacing: 22,
              runSpacing: 12,
              children: const [
                _TrustPoint(
                  icon: Icons.verified_rounded,
                  text: 'Reliable Service',
                ),
                _TrustPoint(
                  icon: Icons.local_shipping_rounded,
                  text: 'Fast Delivery',
                ),
                _TrustPoint(
                  icon: Icons.location_on_rounded,
                  text: 'Dubai Wide',
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ============================================================
  // PRIMARY BUTTON
  // ============================================================

  Widget _buildPrimaryButton() {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) {
        setState(() {
          _waterButtonHover = true;
        });
      },
      onExit: (_) {
        setState(() {
          _waterButtonHover = false;
        });
      },
      child: AnimatedScale(
        scale: _waterButtonHover ? 1.04 : 1.0,
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        child: ElevatedButton.icon(
          onPressed: widget.onGetWaterNow,
          icon: const Icon(Icons.water_drop_rounded),
          label: const Text('Get Water Now'),
          style: ElevatedButton.styleFrom(
            backgroundColor: HeroSection.primary,
            foregroundColor: Colors.white,
            elevation: _waterButtonHover ? 8 : 0,
            shadowColor: HeroSection.primary.withValues(alpha: 0.30),
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 18),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // CALL BUTTON
  // ============================================================

  Widget _buildCallButton() {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) {
        setState(() {
          _callButtonHover = true;
        });
      },
      onExit: (_) {
        setState(() {
          _callButtonHover = false;
        });
      },
      child: AnimatedScale(
        scale: _callButtonHover ? 1.04 : 1.0,
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        child: OutlinedButton.icon(
          onPressed: _makeCall,
          icon: const Icon(Icons.phone_rounded),
          label: const Text('Call Us'),
          style: OutlinedButton.styleFrom(
            foregroundColor: HeroSection.primary,
            backgroundColor: _callButtonHover
                ? HeroSection.primary.withValues(alpha: 0.06)
                : Colors.transparent,
            side: const BorderSide(color: HeroSection.primary, width: 1.5),
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 18),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // AVAILABILITY BADGE
  // ============================================================

  Widget _buildAvailabilityBadge() {
    return AnimatedBuilder(
      animation: _badgePulse,
      builder: (context, child) {
        return Transform.scale(
          scale: _badgePulse.value,
          alignment: Alignment.centerLeft,
          child: child,
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: const Color(0xFFB9E8F1)),
          boxShadow: [
            BoxShadow(
              color: HeroSection.primary.withValues(alpha: 0.05),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.circle, size: 9, color: Color(0xFF16A085)),
            SizedBox(width: 8),
            Text(
              '24/7 Water Delivery in Dubai',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: Color(0xFF245B6A),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // ANIMATED HERO IMAGE
  // ============================================================

  Widget _animatedHeroImage() {
    return FadeTransition(
      opacity: _imageFade,
      child: AnimatedBuilder(
        animation: Listenable.merge([_imageScale, _floatingAnimation]),
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0, _floatingAnimation.value),
            child: AnimatedScale(
              scale: _imageHover ? 1.015 : 1.0,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
              child: Transform.scale(scale: _imageScale.value, child: child),
            ),
          );
        },
        child: MouseRegion(
          cursor: SystemMouseCursors.basic,
          onEnter: (_) {
            setState(() {
              _imageHover = true;
            });
          },
          onExit: (_) {
            setState(() {
              _imageHover = false;
            });
          },
          child: _heroImage(),
        ),
      ),
    );
  }

  // ============================================================
  // HERO IMAGE
  // ============================================================

  Widget _heroImage() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        final double imageHeight;

        if (width < 500) {
          imageHeight = 300;
        } else if (width < 700) {
          imageHeight = 360;
        } else if (width < 1000) {
          imageHeight = 420;
        } else {
          imageHeight = 470;
        }

        return Container(
          height: imageHeight,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: HeroSection.primary.withValues(
                  alpha: _imageHover ? 0.28 : 0.20,
                ),
                blurRadius: _imageHover ? 50 : 40,
                offset: const Offset(0, 20),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: Stack(
              fit: StackFit.expand,
              children: [
                // ==================================================
                // MAIN IMAGE
                // ==================================================

                Image.asset(
                  'assets/images/hero/tanker-hero.jpg',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: const Color(0xFFEFFBFF),
                      child: const Center(
                        child: Icon(
                          Icons.image_not_supported_outlined,
                          color: HeroSection.primary,
                          size: 50,
                        ),
                      ),
                    );
                  },
                ),

                // ==================================================
                // SOFT OVERLAY
                // ==================================================
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.08),
                        HeroSection.primary.withValues(alpha: 0.12),
                      ],
                    ),
                  ),
                ),

                // ==================================================
                // PREMIUM LABEL
                // ==================================================
                Positioned(
                  left: 24,
                  bottom: 24,
                  child: TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0.0, end: 1.0),
                    duration: const Duration(milliseconds: 900),
                    curve: Curves.easeOutBack,
                    builder: (context, value, child) {
                      return Opacity(
                        opacity: value.clamp(0.0, 1.0),
                        child: Transform.translate(
                          offset: Offset(0, 18 * (1 - value)),
                          child: child,
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.92),
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.10),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.water_drop_rounded,
                            color: HeroSection.primary,
                            size: 20,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Premium Water Delivery',
                            style: TextStyle(
                              color: HeroSection.darkText,
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // ==================================================
                // 24/7 BADGE
                // ==================================================
                Positioned(
                  right: 20,
                  top: 20,
                  child: TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0.0, end: 1.0),
                    duration: const Duration(milliseconds: 1000),
                    curve: Curves.easeOutBack,
                    builder: (context, value, child) {
                      return Opacity(
                        opacity: value.clamp(0.0, 1.0),
                        child: Transform.scale(
                          scale: 0.85 + (value * 0.15),
                          child: child,
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 13,
                        vertical: 9,
                      ),
                      decoration: BoxDecoration(
                        color: HeroSection.primary,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: HeroSection.primary.withValues(alpha: 0.25),
                            blurRadius: 18,
                            offset: const Offset(0, 7),
                          ),
                        ],
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.access_time_rounded,
                            color: Colors.white,
                            size: 16,
                          ),
                          SizedBox(width: 6),
                          Text(
                            '24/7',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
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
        );
      },
    );
  }
}

// ================================================================
// TRUST POINT
// ================================================================

class _TrustPoint extends StatefulWidget {
  final IconData icon;
  final String text;

  const _TrustPoint({required this.icon, required this.text});

  @override
  State<_TrustPoint> createState() => _TrustPointState();
}

class _TrustPointState extends State<_TrustPoint> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.basic,
      onEnter: (_) {
        setState(() {
          _hover = true;
        });
      },
      onExit: (_) {
        setState(() {
          _hover = false;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        padding: EdgeInsets.symmetric(horizontal: _hover ? 8 : 0, vertical: 5),
        decoration: BoxDecoration(
          color: _hover
              ? HeroSection.primary.withValues(alpha: 0.06)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedScale(
              scale: _hover ? 1.12 : 1.0,
              duration: const Duration(milliseconds: 180),
              child: Icon(widget.icon, size: 19, color: HeroSection.primary),
            ),
            const SizedBox(width: 7),
            Text(
              widget.text,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: HeroSection.bodyText,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
