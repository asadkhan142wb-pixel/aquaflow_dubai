import 'package:flutter/material.dart';

import '../screens/gallery_page.dart';

class GallerySection extends StatefulWidget {
  const GallerySection({super.key});

  static const Color primary = Color(0xFF087EA4);
  static const Color darkText = Color(0xFF102A43);
  static const Color bodyText = Color(0xFF52667A);
  static const Color lightBg = Color(0xFFF6FBFD);

  @override
  State<GallerySection> createState() => _GallerySectionState();
}

class _GallerySectionState extends State<GallerySection>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  late final Animation<double> _headingFade;
  late final Animation<Offset> _headingSlide;

  late final Animation<double> _buttonFade;
  late final Animation<Offset> _buttonSlide;

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
        Tween<Offset>(begin: const Offset(0, 0.12), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.0, 0.30, curve: Curves.easeOutCubic),
          ),
        );

    _buttonFade = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.75, 1.0, curve: Curves.easeOut),
    );

    _buttonSlide = Tween<Offset>(begin: const Offset(0, 0.12), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.75, 1.0, curve: Curves.easeOutCubic),
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
        final isMobile = width < 800;
        final isTablet = width >= 800 && width < 1100;

        return Container(
          width: double.infinity,
          color: Colors.white,
          padding: EdgeInsets.symmetric(
            horizontal: isMobile
                ? 20
                : isTablet
                ? 35
                : 70,
            vertical: isMobile ? 65 : 105,
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

              SizedBox(height: isMobile ? 38 : 55),

              _GalleryGrid(isMobile: isMobile, isTablet: isTablet),

              SizedBox(height: isMobile ? 35 : 45),

              FadeTransition(
                opacity: _buttonFade,
                child: SlideTransition(
                  position: _buttonSlide,
                  child: const _GalleryButton(),
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
          tween: Tween(begin: 0.85, end: 1.0),
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeOutBack,
          builder: (context, scale, child) {
            return Transform.scale(scale: scale, child: child);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFEAF8FB),
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: GallerySection.primary.withValues(alpha: 0.06),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: const Text(
              'OUR GALLERY',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.8,
                color: GallerySection.primary,
              ),
            ),
          ),
        ),

        const SizedBox(height: 18),

        Text(
          'Our Work in Action',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: isMobile ? 31 : 44,
            height: 1.15,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.8,
            color: GallerySection.darkText,
          ),
        ),

        const SizedBox(height: 15),

        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 650),
          child: const Text(
            'A look at our water delivery operations, tanker fleet '
            'and professional service across Dubai.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              height: 1.7,
              color: GallerySection.bodyText,
            ),
          ),
        ),
      ],
    );
  }
}

// ============================================================
// GALLERY GRID
// ============================================================

class _GalleryGrid extends StatelessWidget {
  final bool isMobile;
  final bool isTablet;

  const _GalleryGrid({required this.isMobile, required this.isTablet});

  @override
  Widget build(BuildContext context) {
    final items = [
      const _GalleryItem(
        image: 'assets/images/gallery/tanker-delivery.jpg',
        title: 'Water Tanker Delivery',
        subtitle: 'Reliable delivery across Dubai',
      ),
      const _GalleryItem(
        image: 'assets/images/gallery/pool-water.jpg',
        title: 'Swimming Pool Water',
        subtitle: 'Convenient pool filling service',
      ),
      const _GalleryItem(
        image: 'assets/images/gallery/construction-water.jpg',
        title: 'Construction Supply',
        subtitle: 'Water for ongoing projects',
      ),
      const _GalleryItem(
        image: 'assets/images/gallery/residential-delivery.jpg',
        title: 'Residential Delivery',
        subtitle: 'Water for homes and villas',
      ),
      const _GalleryItem(
        image: 'assets/images/gallery/commercial-water.jpg',
        title: 'Commercial Supply',
        subtitle: 'Serving businesses and facilities',
      ),
      const _GalleryItem(
        image: 'assets/images/gallery/water-supply.jpg',
        title: 'Fresh Water Supply',
        subtitle: 'Professional water delivery',
      ),
    ];

    if (isMobile) {
      return Column(
        children: [
          for (int index = 0; index < items.length; index++)
            Padding(
              padding: EdgeInsets.only(
                bottom: index == items.length - 1 ? 0 : 16,
              ),
              child: _GalleryCard(
                item: items[index],
                height: 260,
                delay: index * 100,
              ),
            ),
        ],
      );
    }

    final int columns = isTablet ? 2 : 3;

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 1180),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: items.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: columns,
          crossAxisSpacing: 18,
          mainAxisSpacing: 18,
          mainAxisExtent: 270,
        ),
        itemBuilder: (context, index) {
          return _GalleryCard(
            item: items[index],
            height: 270,
            delay: index * 100,
          );
        },
      ),
    );
  }
}

// ============================================================
// GALLERY CARD
// ============================================================

class _GalleryCard extends StatefulWidget {
  final _GalleryItem item;
  final double height;
  final int delay;

  const _GalleryCard({
    required this.item,
    required this.height,
    required this.delay,
  });

  @override
  State<_GalleryCard> createState() => _GalleryCardState();
}

class _GalleryCardState extends State<_GalleryCard>
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

  void _openGallery() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => const GalleryPage()));
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 800;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
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
          final value = Curves.easeOutCubic.transform(_controller.value);

          return Opacity(
            opacity: value,
            child: Transform.translate(
              offset: Offset(0, 30 * (1 - value)),
              child: child,
            ),
          );
        },
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: _openGallery,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 350),
            curve: Curves.easeOutCubic,
            transform: Matrix4.translationValues(0, _hovering ? -8 : 0, 0),
            height: widget.height,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: _hovering
                      ? GallerySection.primary.withValues(alpha: 0.14)
                      : Colors.black.withValues(alpha: 0.055),
                  blurRadius: _hovering ? 30 : 20,
                  offset: Offset(0, _hovering ? 16 : 8),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // ==================================================
                  // IMAGE
                  // ==================================================

                  AnimatedScale(
                    scale: _hovering ? 1.07 : 1.0,
                    duration: const Duration(milliseconds: 650),
                    curve: Curves.easeOutCubic,
                    child: Image.asset(
                      widget.item.image,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: GallerySection.lightBg,
                          child: const Center(
                            child: Icon(
                              Icons.image_not_supported_outlined,
                              color: GallerySection.primary,
                              size: 45,
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  // ==================================================
                  // DARK GRADIENT
                  // ==================================================
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 450),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withValues(
                            alpha: _hovering ? 0.14 : 0.10,
                          ),
                          Colors.black.withValues(
                            alpha: _hovering ? 0.76 : 0.68,
                          ),
                        ],
                      ),
                    ),
                  ),

                  // ==================================================
                  // CATEGORY
                  // ==================================================
                  Positioned(
                    top: 15,
                    left: 15,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      transform: Matrix4.translationValues(
                        _hovering ? 3 : 0,
                        _hovering ? 2 : 0,
                        0,
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 11,
                        vertical: 7,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.94),
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(
                              alpha: _hovering ? 0.12 : 0.06,
                            ),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Text(
                        widget.item.category.isEmpty
                            ? 'AQUAFLOW DUBAI'
                            : widget.item.category,
                        style: const TextStyle(
                          color: GallerySection.primary,
                          fontSize: 9,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ),

                  // ==================================================
                  // BOTTOM INFORMATION
                  // ==================================================
                  Positioned(
                    left: 16,
                    right: 16,
                    bottom: 16,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.item.title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                widget.item.subtitle,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 10.5,
                                  color: Colors.white.withValues(alpha: 0.82),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(width: 12),

                        AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeOutBack,
                          transform: Matrix4.translationValues(
                            _hovering ? 3 : 0,
                            _hovering ? -3 : 0,
                            0,
                          ),
                          width: _hovering ? 42 : 38,
                          height: _hovering ? 42 : 38,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.92),
                            shape: BoxShape.circle,
                          ),
                          child: AnimatedRotation(
                            turns: _hovering ? -0.08 : 0,
                            duration: const Duration(milliseconds: 300),
                            child: const Icon(
                              Icons.arrow_outward_rounded,
                              size: 17,
                              color: GallerySection.primary,
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
      ),
    );
  }
}

// ============================================================
// VIEW FULL GALLERY BUTTON
// ============================================================

class _GalleryButton extends StatefulWidget {
  const _GalleryButton();

  @override
  State<_GalleryButton> createState() => _GalleryButtonState();
}

class _GalleryButtonState extends State<_GalleryButton> {
  bool _hovering = false;

  void _openGallery() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => const GalleryPage()));
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) {
        setState(() => _hovering = true);
      },
      onExit: (_) {
        setState(() => _hovering = false);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
        transform: Matrix4.translationValues(0, _hovering ? -4 : 0, 0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: GallerySection.primary.withValues(
                alpha: _hovering ? 0.20 : 0.0,
              ),
              blurRadius: 22,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: ElevatedButton.icon(
          onPressed: _openGallery,
          icon: AnimatedRotation(
            turns: _hovering ? 0.03 : 0,
            duration: const Duration(milliseconds: 250),
            child: const Icon(Icons.photo_library_outlined, size: 19),
          ),
          label: const Text(
            'View Full Gallery',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: GallerySection.primary,
            foregroundColor: Colors.white,
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        ),
      ),
    );
  }
}

// ============================================================
// GALLERY DATA
// ============================================================

class _GalleryItem {
  final String image;
  final String title;
  final String subtitle;
  final String category;

  const _GalleryItem({
    required this.image,
    required this.title,
    required this.subtitle,
  }) : category = '';
}
