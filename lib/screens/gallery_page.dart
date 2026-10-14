import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class GalleryPage extends StatefulWidget {
  const GalleryPage({super.key});

  static const Color primary = Color(0xFF087EA4);
  static const Color darkText = Color(0xFF102A43);
  static const Color bodyText = Color(0xFF52667A);
  static const Color lightBg = Color(0xFFF6FBFD);

  static const String whatsappNumber = '971551027786';

  static const List<GalleryItem> items = [
    GalleryItem(
      image: 'assets/images/gallery/tanker-delivery.jpg',
      title: 'Water Tanker Delivery',
      category: 'TANKER DELIVERY',
    ),
    GalleryItem(
      image: 'assets/images/gallery/pool-water.jpg',
      title: 'Swimming Pool Water',
      category: 'POOL WATER',
    ),
    GalleryItem(
      image: 'assets/images/gallery/construction-water.jpg',
      title: 'Construction Water',
      category: 'CONSTRUCTION',
    ),
    GalleryItem(
      image: 'assets/images/gallery/residential-delivery.jpg',
      title: 'Residential Delivery',
      category: 'RESIDENTIAL',
    ),
    GalleryItem(
      image: 'assets/images/gallery/commercial-water.jpg',
      title: 'Commercial Water Supply',
      category: 'COMMERCIAL',
    ),
    GalleryItem(
      image: 'assets/images/gallery/water-supply.jpg',
      title: 'Fresh Water Supply',
      category: 'WATER SUPPLY',
    ),
  ];

  @override
  State<GalleryPage> createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage>
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
      curve: const Interval(0.0, 0.45, curve: Curves.easeOutCubic),
    );

    _heroSlide = Tween<Offset>(begin: const Offset(0, 0.08), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.0, 0.45, curve: Curves.easeOutCubic),
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

  Future<void> _openWhatsApp() async {
    final message = Uri.encodeComponent(
      'Hello Sweet Water Tankers,\n\n'
      'I would like to request a quote for water delivery.\n\n'
      'Please share the details and pricing.',
    );

    final uri = Uri.parse(
      'https://wa.me/${GalleryPage.whatsappNumber}?text=$message',
    );

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  void _openImageViewer(BuildContext context, GalleryItem item) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Gallery Image',
      barrierColor: Colors.black.withValues(alpha: 0.78),
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) {
        return _ImageViewer(item: item);
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final curved = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
        );

        return FadeTransition(
          opacity: curved,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.92, end: 1.0).animate(curved),
            child: child,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            _TopBar(animation: _heroFade),
            _Hero(fade: _heroFade, slide: _heroSlide),
            _GalleryGrid(onOpenImage: _openImageViewer),
            _BottomCta(onRequestQuote: _openWhatsApp),
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
  final Animation<double> animation;

  const _TopBar({required this.animation});

  @override
  State<_TopBar> createState() => _TopBarState();
}

class _TopBarState extends State<_TopBar> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: widget.animation,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, -0.04),
          end: Offset.zero,
        ).animate(widget.animation),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;

            final verySmall = width < 360;
            final mobile = width < 600;
            final tablet = width >= 600 && width < 1000;

            final horizontalPadding = verySmall
                ? 12.0
                : mobile
                ? 16.0
                : tablet
                ? 28.0
                : 40.0;

            final logoSize = verySmall
                ? 40.0
                : tablet
                ? 43.0
                : 44.0;

            return Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: tablet
                    ? 15
                    : mobile
                    ? 14
                    : 18,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                  bottom: BorderSide(
                    color: GalleryPage.primary.withValues(alpha: 0.08),
                  ),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // ==================================================
                  // LEFT SIDE
                  // LOGO + BRAND
                  // ==================================================

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
                                colors: [
                                  GalleryPage.primary,
                                  Color(0xFF0AA8D0),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(
                                verySmall ? 11 : 13,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: GalleryPage.primary.withValues(
                                    alpha: 0.18,
                                  ),
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
                                  'Sweet Water Tankers',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: verySmall
                                        ? 16
                                        : tablet
                                        ? 18
                                        : 19,
                                    fontWeight: FontWeight.w800,
                                    color: GalleryPage.darkText,
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
                                    color: GalleryPage.primary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // ==================================================
                  // SPACE BEFORE RIGHT BUTTON
                  // ==================================================
                  SizedBox(width: tablet ? 18 : 12),

                  // ==================================================
                  // RIGHT SIDE
                  // BACK HOME BUTTON
                  // ==================================================
                  Align(
                    alignment: Alignment.centerRight,
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
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: AnimatedScale(
                          scale: _hovered ? 1.04 : 1.0,
                          duration: const Duration(milliseconds: 180),
                          curve: Curves.easeOutCubic,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 180),
                            padding: EdgeInsets.symmetric(
                              horizontal: verySmall
                                  ? 10
                                  : tablet
                                  ? 14
                                  : mobile
                                  ? 13
                                  : 18,
                              vertical: verySmall
                                  ? 9
                                  : tablet
                                  ? 11
                                  : mobile
                                  ? 11
                                  : 13,
                            ),
                            decoration: BoxDecoration(
                              color: _hovered
                                  ? GalleryPage.primary.withValues(alpha: 0.07)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(
                                verySmall ? 9 : 12,
                              ),
                              border: Border.all(
                                color: _hovered
                                    ? GalleryPage.primary.withValues(
                                        alpha: 0.38,
                                      )
                                    : GalleryPage.primary.withValues(
                                        alpha: 0.25,
                                      ),
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
                                        ? 15
                                        : tablet
                                        ? 17
                                        : 18,
                                    color: GalleryPage.primary,
                                  ),
                                ),
                                SizedBox(width: verySmall ? 4 : 7),
                                Text(
                                  verySmall ? 'Home' : 'Back Home',
                                  style: TextStyle(
                                    color: GalleryPage.primary,
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
                  ),
                ],
              ),
            );
          },
        ),
      ),
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
        final mobile = width < 600;
        final verySmall = width < 380;

        return Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(
            horizontal: verySmall ? 18 : 24,
            vertical: mobile ? 55 : 75,
          ),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFFF4FCFE), Colors.white],
            ),
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 850),
              child: FadeTransition(
                opacity: fade,
                child: SlideTransition(
                  position: slide,
                  child: Column(
                    children: [
                      TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0.0, end: 1.0),
                        duration: const Duration(milliseconds: 750),
                        curve: Curves.easeOutBack,
                        builder: (context, value, child) {
                          return Transform.scale(
                            scale: 0.88 + (value.clamp(0.0, 1.0) * 0.12),
                            child: child,
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: GalleryPage.primary.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: const Text(
                            'OUR GALLERY',
                            style: TextStyle(
                              color: GalleryPage.primary,
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1.8,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Our Work in Action',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: GalleryPage.darkText,
                          fontSize: verySmall
                              ? 38
                              : mobile
                              ? 42
                              : 48,
                          height: 1.15,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 18),
                      Text(
                        'Explore our water tanker delivery '
                        'solutions across residential, commercial, '
                        'pool and construction requirements.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: GalleryPage.bodyText,
                          fontSize: mobile ? 15 : 16,
                          height: 1.7,
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
// GALLERY GRID
// ============================================================

class _GalleryGrid extends StatelessWidget {
  final void Function(BuildContext context, GalleryItem item) onOpenImage;

  const _GalleryGrid({required this.onOpenImage});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 85),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1180),
          child: LayoutBuilder(
            builder: (context, constraints) {
              int columns;

              if (constraints.maxWidth >= 1050) {
                columns = 3;
              } else if (constraints.maxWidth >= 650) {
                columns = 2;
              } else {
                columns = 1;
              }

              final cardWidth =
                  (constraints.maxWidth - ((columns - 1) * 18)) / columns;

              return Wrap(
                spacing: 18,
                runSpacing: 18,
                children: List.generate(GalleryPage.items.length, (index) {
                  final item = GalleryPage.items[index];

                  return SizedBox(
                    width: cardWidth,
                    child: _GalleryCard(
                      item: item,
                      index: index,
                      onTap: () {
                        onOpenImage(context, item);
                      },
                    ),
                  );
                }),
              );
            },
          ),
        ),
      ),
    );
  }
}

// ============================================================
// GALLERY CARD
// ============================================================

class _GalleryCard extends StatefulWidget {
  final GalleryItem item;
  final int index;
  final VoidCallback onTap;

  const _GalleryCard({
    required this.item,
    required this.index,
    required this.onTap,
  });

  @override
  State<_GalleryCard> createState() => _GalleryCardState();
}

class _GalleryCardState extends State<_GalleryCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 550 + (widget.index * 110)),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        final progress = value.clamp(0.0, 1.0);

        return Opacity(
          opacity: progress,
          child: Transform.translate(
            offset: Offset(0, 28 * (1 - progress)),
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
          behavior: HitTestBehavior.opaque,
          onTap: widget.onTap,
          child: AnimatedScale(
            scale: _hovered ? 1.015 : 1.0,
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOutCubic,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: _hovered
                      ? GalleryPage.primary.withValues(alpha: 0.18)
                      : GalleryPage.primary.withValues(alpha: 0.07),
                ),
              ),
              clipBehavior: Clip.antiAlias,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AspectRatio(
                    aspectRatio: 1.35,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        ClipRect(
                          child: AnimatedScale(
                            scale: _hovered ? 1.06 : 1.0,
                            duration: const Duration(milliseconds: 450),
                            curve: Curves.easeOutCubic,
                            child: Image.asset(
                              widget.item.image,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: GalleryPage.lightBg,
                                  child: const Center(
                                    child: Icon(
                                      Icons.image_not_supported_outlined,
                                      color: GalleryPage.primary,
                                      size: 45,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          color: Colors.black.withValues(
                            alpha: _hovered ? 0.16 : 0.05,
                          ),
                        ),
                        Center(
                          child: AnimatedScale(
                            scale: _hovered ? 1.08 : 1.0,
                            duration: const Duration(milliseconds: 220),
                            curve: Curves.easeOutBack,
                            child: Container(
                              width: 55,
                              height: 55,
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(
                                  alpha: _hovered ? 1.0 : 0.92,
                                ),
                                shape: BoxShape.circle,
                                boxShadow: _hovered
                                    ? [
                                        BoxShadow(
                                          color: GalleryPage.primary.withValues(
                                            alpha: 0.22,
                                          ),
                                          blurRadius: 18,
                                          offset: const Offset(0, 7),
                                        ),
                                      ]
                                    : null,
                              ),
                              child: const Icon(
                                Icons.zoom_in_rounded,
                                color: GalleryPage.primary,
                                size: 27,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          left: 14,
                          top: 14,
                          child: AnimatedSlide(
                            offset: _hovered
                                ? const Offset(0, -0.04)
                                : Offset.zero,
                            duration: const Duration(milliseconds: 220),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 11,
                                vertical: 7,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.92),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Text(
                                widget.item.category,
                                style: const TextStyle(
                                  color: GalleryPage.primary,
                                  fontSize: 9,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 1,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            widget.item.title,
                            style: const TextStyle(
                              color: GalleryPage.darkText,
                              fontSize: 17,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        AnimatedScale(
                          scale: _hovered ? 1.08 : 1.0,
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.easeOutBack,
                          child: AnimatedRotation(
                            turns: _hovered ? 0.04 : 0.0,
                            duration: const Duration(milliseconds: 220),
                            curve: Curves.easeOutCubic,
                            child: Container(
                              width: 35,
                              height: 35,
                              decoration: BoxDecoration(
                                color: GalleryPage.primary.withValues(
                                  alpha: _hovered ? 0.14 : 0.08,
                                ),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.arrow_outward_rounded,
                                color: GalleryPage.primary,
                                size: 17,
                              ),
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
// IMAGE VIEWER
// ============================================================

class _ImageViewer extends StatelessWidget {
  final GalleryItem item;

  const _ImageViewer({required this.item});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: SafeArea(
        child: Stack(
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.all(25),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(22),
                  child: Image.asset(item.image, fit: BoxFit.contain),
                ),
              ),
            ),
            Positioned(
              top: 20,
              right: 20,
              child: Material(
                color: Colors.black.withValues(alpha: 0.65),
                shape: const CircleBorder(),
                child: IconButton(
                  tooltip: 'Close',
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(Icons.close_rounded, color: Colors.white),
                ),
              ),
            ),
            Positioned(
              left: 25,
              bottom: 25,
              right: 25,
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 300),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 9,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.58),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Text(
                    item.title,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
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
// BOTTOM CTA
// ============================================================

class _BottomCta extends StatefulWidget {
  final VoidCallback onRequestQuote;

  const _BottomCta({required this.onRequestQuote});

  @override
  State<_BottomCta> createState() => _BottomCtaState();
}

class _BottomCtaState extends State<_BottomCta> {
  bool _hovered = false;
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final mobile = constraints.maxWidth < 600;

        return Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(
            horizontal: mobile ? 18 : 24,
            vertical: mobile ? 55 : 75,
          ),
          color: GalleryPage.lightBg,
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 900),
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.0, end: 1.0),
                duration: const Duration(milliseconds: 850),
                curve: Curves.easeOutCubic,
                builder: (context, value, child) {
                  final progress = value.clamp(0.0, 1.0);

                  return Opacity(
                    opacity: progress,
                    child: Transform.translate(
                      offset: Offset(0, 28 * (1 - progress)),
                      child: child,
                    ),
                  );
                },
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: mobile ? 20 : 30,
                    vertical: mobile ? 32 : 42,
                  ),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF075B78), GalleryPage.primary],
                    ),
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: [
                      BoxShadow(
                        color: GalleryPage.primary.withValues(alpha: 0.18),
                        blurRadius: 30,
                        offset: const Offset(0, 15),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Need Water Delivered?',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: mobile ? 25 : 30,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Contact Sweet Water Tankers for your next delivery.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.75),
                          fontSize: mobile ? 14 : 15,
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
                          onTap: widget.onRequestQuote,
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
                                          color: GalleryPage.primary.withValues(
                                            alpha: 0.25,
                                          ),
                                          blurRadius: 22,
                                          offset: const Offset(0, 9),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 24,
                                    vertical: 15,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(
                                        Icons.request_quote_rounded,
                                        color: GalleryPage.primary,
                                      ),
                                      const SizedBox(width: 8),
                                      const Text(
                                        'Request a Quote',
                                        style: TextStyle(
                                          color: GalleryPage.primary,
                                          fontWeight: FontWeight.w800,
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
                                          color: GalleryPage.primary,
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
      builder: (context, constraints) {
        final mobile = constraints.maxWidth < 600;

        return Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(
            horizontal: mobile ? 18 : 24,
            vertical: 32,
          ),
          color: const Color(0xFF071D2B),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1180),
              child: TweenAnimationBuilder<double>(
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
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: GalleryPage.primary,
                            borderRadius: BorderRadius.circular(11),
                          ),
                          child: const Icon(
                            Icons.water_drop_rounded,
                            color: Colors.white,
                            size: 22,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'Sweet Water Tankers',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 25),
                    Divider(color: Colors.white.withValues(alpha: 0.08)),
                    const SizedBox(height: 18),
                    Text(
                      '© 2026 Sweet Water Tankers. '
                      'Water Delivery Solutions.',
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
          ),
        );
      },
    );
  }
}

// ============================================================
// MODEL
// ============================================================

class GalleryItem {
  final String image;
  final String title;
  final String category;

  const GalleryItem({
    required this.image,
    required this.title,
    required this.category,
  });
}
