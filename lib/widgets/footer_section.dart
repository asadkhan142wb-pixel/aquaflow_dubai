import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../screens/about_page.dart';
import '../screens/services_page.dart';
import '../screens/gallery_page.dart';
import '../screens/contact_page.dart';

class FooterSection extends StatefulWidget {
  const FooterSection({super.key, this.onHome});

  final VoidCallback? onHome;

  static const Color dark = Color(0xFF071D2B);
  static const Color primary = Color(0xFF087EA4);
  static const Color muted = Color(0xFF9CB2C0);

  static const String whatsappNumber = '971551027786';
  static const String phoneNumber = '+971551027786';

  // ============================================================
  // LOGO
  // ============================================================

  static const String logoAsset = 'assets/images/favicon.png';

  // ============================================================
  // FACEBOOK URL
  // ============================================================

  static final Uri facebookUrl = Uri.parse(
    'https://www.facebook.com/share/19d8TtjvGb/',
  );

  // ============================================================
  // INSTAGRAM URL
  // ============================================================

  static final Uri instagramUrl = Uri.parse(
    'https://www.instagram.com/sweet_water_tankers_889/',
  );

  // ============================================================
  // WHATSAPP URL
  // ============================================================

  static Uri get whatsappUrl {
    const message =
        'Hello Sweet Water Tankers, I would like to get information about '
        'your water delivery service.';

    return Uri.https('wa.me', '/$whatsappNumber', {'text': message});
  }

  @override
  State<FooterSection> createState() => _FooterSectionState();
}

class _FooterSectionState extends State<FooterSection>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    _fade = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.75, curve: Curves.easeOut),
    );

    _slide = Tween<Offset>(begin: const Offset(0, 0.08), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.0, 0.75, curve: Curves.easeOutCubic),
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

  // ============================================================
  // WHATSAPP
  // ============================================================

  Future<void> _openWhatsApp() async {
    final Uri url = FooterSection.whatsappUrl;

    try {
      final bool launched = await launchUrl(
        url,
        mode: LaunchMode.platformDefault,
      );

      if (!launched) {
        _showMessage('Unable to open WhatsApp. Please try again.');
      }
    } catch (e) {
      debugPrint('WhatsApp launch error: $e');

      _showMessage('Unable to open WhatsApp. Please try again.');
    }
  }

  // ============================================================
  // CALL
  // ============================================================

  Future<void> _makeCall() async {
    final Uri url = Uri(scheme: 'tel', path: FooterSection.phoneNumber);

    try {
      final bool launched = await launchUrl(
        url,
        mode: LaunchMode.platformDefault,
      );

      if (!launched) {
        _showMessage('Unable to open the phone dialer.');
      }
    } catch (e) {
      debugPrint('Phone launch error: $e');

      _showMessage('Unable to open the phone dialer.');
    }
  }

  // ============================================================
  // MESSAGE
  // ============================================================

  void _showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 3),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;

    final bool isMobile = width < 800;
    final bool isTablet = width >= 800 && width < 1100;

    return Container(
      width: double.infinity,
      color: FooterSection.dark,
      padding: EdgeInsets.only(
        left: isMobile
            ? 24
            : isTablet
            ? 40
            : 70,
        right: isMobile
            ? 24
            : isTablet
            ? 40
            : 70,
        top: isMobile
            ? 65
            : isTablet
            ? 70
            : 80,
        bottom: 25,
      ),
      child: FadeTransition(
        opacity: _fade,
        child: SlideTransition(
          position: _slide,
          child: Column(
            children: [
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1300),
                child: _buildResponsiveContent(
                  isMobile: isMobile,
                  isTablet: isTablet,
                ),
              ),
              const SizedBox(height: 55),
              const _AnimatedDivider(),
              const SizedBox(height: 22),
              _buildBottomSection(isMobile: isMobile, isTablet: isTablet),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // RESPONSIVE MAIN CONTENT
  // ============================================================

  Widget _buildResponsiveContent({
    required bool isMobile,
    required bool isTablet,
  }) {
    if (isMobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _Brand(),

          const SizedBox(height: 45),

          _AnimatedFooterColumn(
            delay: 150,
            title: 'QUICK LINKS',
            items: const ['Home', 'About Us', 'Services', 'Gallery', 'Contact'],
            onHome: widget.onHome,
          ),

          const SizedBox(height: 35),

          const _AnimatedFooterColumn(
            delay: 280,
            title: 'OUR SERVICES',
            items: [
              'Sweet Water Supply',
              'Swimming Pool Water',
              'Residential Supply',
              'Commercial Supply',
              'Construction Water',
              'Garden & Nursery',
              'Wastewater Removal',
              'Emergency Delivery',
            ],
          ),

          const SizedBox(height: 35),

          _AnimatedContactColumn(
            delay: 400,
            onWhatsApp: _openWhatsApp,
            onCall: _makeCall,
          ),
        ],
      );
    }

    if (isTablet) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _Brand(),

          const SizedBox(height: 50),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: _AnimatedFooterColumn(
                    delay: 150,
                    title: 'QUICK LINKS',
                    items: const [
                      'Home',
                      'About Us',
                      'Services',
                      'Gallery',
                      'Contact',
                    ],
                    onHome: widget.onHome,
                  ),
                ),
              ),

              const Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: _AnimatedFooterColumn(
                    delay: 280,
                    title: 'OUR SERVICES',
                    items: [
                      'Sweet Water Supply',
                      'Swimming Pool Water',
                      'Residential Supply',
                      'Commercial Supply',
                      'Construction Water',
                      'Garden & Nursery',
                      'Wastewater Removal',
                      'Emergency Delivery',
                    ],
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 45),

          _AnimatedContactColumn(
            delay: 400,
            onWhatsApp: _openWhatsApp,
            onCall: _makeCall,
          ),
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Expanded(flex: 2, child: _Brand()),

        const SizedBox(width: 55),

        Expanded(
          flex: 1,
          child: _AnimatedFooterColumn(
            delay: 150,
            title: 'QUICK LINKS',
            items: const ['Home', 'About Us', 'Services', 'Gallery', 'Contact'],
            onHome: widget.onHome,
          ),
        ),

        const SizedBox(width: 25),

        const Expanded(
          flex: 1,
          child: _AnimatedFooterColumn(
            delay: 280,
            title: 'OUR SERVICES',
            items: [
              'Sweet Water Supply',
              'Swimming Pool Water',
              'Residential Supply',
              'Commercial Supply',
              'Construction Water',
              'Garden & Nursery',
              'Wastewater Removal',
              'Emergency Delivery',
            ],
          ),
        ),

        const SizedBox(width: 25),

        Expanded(
          flex: 1,
          child: _AnimatedContactColumn(
            delay: 400,
            onWhatsApp: _openWhatsApp,
            onCall: _makeCall,
          ),
        ),
      ],
    );
  }

  // ============================================================
  // BOTTOM SECTION
  // ============================================================

  Widget _buildBottomSection({required bool isMobile, required bool isTablet}) {
    if (isMobile) {
      return const Column(
        children: [
          _AnimatedCopyright(),
          SizedBox(height: 18),
          _DeveloperCredit(),
          SizedBox(height: 18),
          _BottomLinks(),
        ],
      );
    }

    if (isTablet) {
      return const Column(
        children: [
          _AnimatedCopyright(),
          SizedBox(height: 16),
          _DeveloperCredit(),
          SizedBox(height: 16),
          _BottomLinks(),
        ],
      );
    }

    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Align(
            alignment: Alignment.centerLeft,
            child: _AnimatedCopyright(),
          ),
        ),
        Expanded(child: Center(child: _DeveloperCredit())),
        Expanded(
          child: Align(alignment: Alignment.centerRight, child: _BottomLinks()),
        ),
      ],
    );
  }
}

// ============================================================
// BRAND
// ============================================================

class _Brand extends StatefulWidget {
  const _Brand();

  @override
  State<_Brand> createState() => _BrandState();
}

class _BrandState extends State<_Brand> {
  bool _hoveredWhatsApp = false;

  // ============================================================
  // FACEBOOK
  // ============================================================

  Future<void> _openFacebook() async {
    try {
      final bool launched = await launchUrl(
        FooterSection.facebookUrl,
        mode: LaunchMode.platformDefault,
      );

      if (!launched && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Unable to open Facebook. Please try again.'),
          ),
        );
      }
    } catch (e) {
      debugPrint('Facebook launch error: $e');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Unable to open Facebook. Please try again.'),
          ),
        );
      }
    }
  }

  // ============================================================
  // INSTAGRAM
  // ============================================================

  Future<void> _openInstagram() async {
    try {
      final bool launched = await launchUrl(
        FooterSection.instagramUrl,
        mode: LaunchMode.platformDefault,
      );

      if (!launched && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Unable to open Instagram. Please try again.'),
          ),
        );
      }
    } catch (e) {
      debugPrint('Instagram launch error: $e');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Unable to open Instagram. Please try again.'),
          ),
        );
      }
    }
  }

  // ============================================================
  // WHATSAPP
  // ============================================================

  Future<void> _openWhatsApp() async {
    try {
      final bool launched = await launchUrl(
        FooterSection.whatsappUrl,
        mode: LaunchMode.platformDefault,
      );

      if (!launched && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Unable to open WhatsApp. Please try again.'),
          ),
        );
      }
    } catch (e) {
      debugPrint('WhatsApp launch error: $e');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Unable to open WhatsApp. Please try again.'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.0, end: 1.0),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ========================================================
          // LOGO + BRAND NAME
          // ========================================================

          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TweenAnimationBuilder<double>(
                tween: Tween<double>(begin: 0.0, end: 1.0),
                duration: const Duration(milliseconds: 900),
                curve: Curves.easeOutBack,
                builder: (context, value, child) {
                  return Transform.scale(
                    scale: 0.82 + (value * 0.18),
                    child: child,
                  );
                },
                child: Container(
                  width: 48,
                  height: 48,
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.18),
                        blurRadius: 16,
                        offset: const Offset(0, 7),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(9),
                    child: Image.asset(
                      FooterSection.logoAsset,
                      width: 36,
                      height: 36,
                      fit: BoxFit.contain,
                      alignment: Alignment.center,
                      filterQuality: FilterQuality.high,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: FooterSection.primary,
                            borderRadius: BorderRadius.circular(9),
                          ),
                          alignment: Alignment.center,
                          child: const Icon(
                            Icons.water_drop_rounded,
                            color: Colors.white,
                            size: 23,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 12),

              const Flexible(
                child: Text(
                  'Sweet Water',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    letterSpacing: -0.3,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 3),

          const Padding(
            padding: EdgeInsets.only(left: 60),
            child: Text(
              'TANKERS',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w800,
                letterSpacing: 2.4,
                color: FooterSection.primary,
              ),
            ),
          ),

          const SizedBox(height: 20),

          const Text(
            'Reliable water tanker delivery across Dubai. '
            'Professional service for residential, commercial, '
            'construction and water supply requirements.',
            style: TextStyle(
              fontSize: 13.5,
              height: 1.7,
              color: FooterSection.muted,
            ),
          ),

          const SizedBox(height: 22),

          // ========================================================
          // SOCIAL BUTTONS
          // ========================================================
          Row(
            children: [
              // FACEBOOK
              _SocialButton(icon: Icons.facebook_rounded, onTap: _openFacebook),

              const SizedBox(width: 9),

              // INSTAGRAM
              _SocialButton(
                icon: Icons.camera_alt_rounded,
                onTap: _openInstagram,
              ),

              const SizedBox(width: 9),

              // WHATSAPP
              MouseRegion(
                cursor: SystemMouseCursors.click,
                onEnter: (_) {
                  if (mounted) {
                    setState(() {
                      _hoveredWhatsApp = true;
                    });
                  }
                },
                onExit: (_) {
                  if (mounted) {
                    setState(() {
                      _hoveredWhatsApp = false;
                    });
                  }
                },
                child: AnimatedScale(
                  scale: _hoveredWhatsApp ? 1.08 : 1.0,
                  duration: const Duration(milliseconds: 220),
                  curve: Curves.easeOutBack,
                  child: _SocialButton(
                    icon: Icons.chat_rounded,
                    onTap: _openWhatsApp,
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
// ANIMATED FOOTER COLUMN
// ============================================================

class _AnimatedFooterColumn extends StatefulWidget {
  final int delay;
  final String title;
  final List<String> items;
  final VoidCallback? onHome;

  const _AnimatedFooterColumn({
    required this.delay,
    required this.title,
    required this.items,
    this.onHome,
  });

  @override
  State<_AnimatedFooterColumn> createState() => _AnimatedFooterColumnState();
}

class _AnimatedFooterColumnState extends State<_AnimatedFooterColumn> {
  bool _visible = false;

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(milliseconds: widget.delay), () {
      if (mounted) {
        setState(() {
          _visible = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: _visible ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOut,
      child: AnimatedSlide(
        offset: _visible ? Offset.zero : const Offset(0, 0.08),
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeOutCubic,
        child: _FooterColumn(
          title: widget.title,
          items: widget.items,
          onHome: widget.onHome,
        ),
      ),
    );
  }
}

// ============================================================
// FOOTER COLUMN
// ============================================================

class _FooterColumn extends StatelessWidget {
  final String title;
  final List<String> items;
  final VoidCallback? onHome;

  const _FooterColumn({required this.title, required this.items, this.onHome});

  void _openPage(BuildContext context, String item) {
    if (item == 'Home') {
      Navigator.of(context).popUntil((route) => route.isFirst);

      onHome?.call();
      return;
    }

    Widget? page;

    switch (item) {
      case 'About Us':
        page = const AboutPage();
        break;

      case 'Services':
        page = const ServicesPage();
        break;

      case 'Gallery':
        page = const GalleryPage();
        break;

      case 'Contact':
        page = const ContactPage();
        break;
    }

    if (page == null) {
      return;
    }

    Navigator.of(context).push(MaterialPageRoute(builder: (_) => page!));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.5,
            color: Colors.white,
          ),
        ),

        const SizedBox(height: 20),

        ...items.asMap().entries.map((entry) {
          final int index = entry.key;
          final String item = entry.value;

          return _AnimatedFooterLink(
            key: ValueKey('$title-$item'),
            item: item,
            index: index,
            onTap: () {
              _openPage(context, item);
            },
          );
        }),
      ],
    );
  }
}

// ============================================================
// FOOTER LINK
// ============================================================

class _AnimatedFooterLink extends StatefulWidget {
  final String item;
  final int index;
  final VoidCallback onTap;

  const _AnimatedFooterLink({
    super.key,
    required this.item,
    required this.index,
    required this.onTap,
  });

  @override
  State<_AnimatedFooterLink> createState() => _AnimatedFooterLinkState();
}

class _AnimatedFooterLinkState extends State<_AnimatedFooterLink> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 13),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) {
          if (mounted) {
            setState(() {
              _hovered = true;
            });
          }
        },
        onExit: (_) {
          if (mounted) {
            setState(() {
              _hovered = false;
            });
          }
        },
        child: InkWell(
          onTap: widget.onTap,
          borderRadius: BorderRadius.circular(5),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 2),
            child: Transform.translate(
              offset: Offset(_hovered ? 5.0 : 0.0, 0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: _hovered ? 5 : 0,
                    height: 5,
                    margin: EdgeInsets.only(right: _hovered ? 7 : 0),
                    decoration: const BoxDecoration(
                      color: FooterSection.primary,
                      shape: BoxShape.circle,
                    ),
                  ),

                  Flexible(
                    child: AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 200),
                      style: TextStyle(
                        fontSize: 13.5,
                        color: _hovered ? Colors.white : FooterSection.muted,
                        fontWeight: _hovered
                            ? FontWeight.w600
                            : FontWeight.w400,
                      ),
                      child: Text(widget.item, overflow: TextOverflow.ellipsis),
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
// ANIMATED CONTACT COLUMN
// ============================================================

class _AnimatedContactColumn extends StatefulWidget {
  final int delay;
  final Future<void> Function() onWhatsApp;
  final Future<void> Function() onCall;

  const _AnimatedContactColumn({
    required this.delay,
    required this.onWhatsApp,
    required this.onCall,
  });

  @override
  State<_AnimatedContactColumn> createState() => _AnimatedContactColumnState();
}

class _AnimatedContactColumnState extends State<_AnimatedContactColumn> {
  bool _visible = false;

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(milliseconds: widget.delay), () {
      if (mounted) {
        setState(() {
          _visible = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: _visible ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 650),
      child: AnimatedSlide(
        offset: _visible ? Offset.zero : const Offset(0, 0.08),
        duration: const Duration(milliseconds: 650),
        curve: Curves.easeOutCubic,
        child: _ContactColumn(
          onWhatsApp: widget.onWhatsApp,
          onCall: widget.onCall,
        ),
      ),
    );
  }
}

// ============================================================
// CONTACT
// ============================================================

class _ContactColumn extends StatelessWidget {
  final Future<void> Function() onWhatsApp;
  final Future<void> Function() onCall;

  const _ContactColumn({required this.onWhatsApp, required this.onCall});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'CONTACT US',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.5,
            color: Colors.white,
          ),
        ),

        const SizedBox(height: 20),

        _ContactItem(
          icon: Icons.phone_rounded,
          text: '+971551027786',
          onTap: onCall,
        ),

        const SizedBox(height: 20),

        _ContactItem(
          icon: Icons.phone_rounded,
          text: '+971508385964',
          onTap: onCall,
        ),

        const SizedBox(height: 15),

        _ContactItem(
          icon: Icons.chat_rounded,
          text: 'WhatsApp Available',
          onTap: onWhatsApp,
        ),

        const SizedBox(height: 15),

        const _ContactItem(
          icon: Icons.email_rounded,
          text: 'Javedrasheed78@gmail.com',
        ),

        const SizedBox(height: 15),

        const _ContactItem(
          icon: Icons.location_on_rounded,
          text: 'Dubai, Ajman, Sharjah',
        ),
      ],
    );
  }
}

// ============================================================
// CONTACT ITEM
// ============================================================

class _ContactItem extends StatefulWidget {
  final IconData icon;
  final String text;
  final Future<void> Function()? onTap;

  const _ContactItem({required this.icon, required this.text, this.onTap});

  @override
  State<_ContactItem> createState() => _ContactItemState();
}

class _ContactItemState extends State<_ContactItem> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final Widget content = Transform.translate(
      offset: Offset(_hovered ? 4.0 : 0.0, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AnimatedScale(
            scale: _hovered ? 1.12 : 1.0,
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOutBack,
            child: Icon(widget.icon, size: 17, color: FooterSection.primary),
          ),

          const SizedBox(width: 10),

          Expanded(
            child: AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: TextStyle(
                fontSize: 13.5,
                height: 1.4,
                color: _hovered ? Colors.white : FooterSection.muted,
              ),
              child: Text(widget.text, softWrap: true),
            ),
          ),

          if (widget.onTap != null)
            AnimatedSlide(
              offset: _hovered ? const Offset(0.15, 0) : Offset.zero,
              duration: const Duration(milliseconds: 200),
              child: const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 11,
                color: FooterSection.primary,
              ),
            ),
        ],
      ),
    );

    if (widget.onTap == null) {
      return content;
    }

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) {
        if (mounted) {
          setState(() {
            _hovered = true;
          });
        }
      },
      onExit: (_) {
        if (mounted) {
          setState(() {
            _hovered = false;
          });
        }
      },
      child: InkWell(
        onTap: widget.onTap,
        borderRadius: BorderRadius.circular(6),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 3),
          child: content,
        ),
      ),
    );
  }
}

// ============================================================
// SOCIAL BUTTON
// ============================================================

class _SocialButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _SocialButton({required this.icon, required this.onTap});

  @override
  State<_SocialButton> createState() => _SocialButtonState();
}

class _SocialButtonState extends State<_SocialButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) {
        if (mounted) {
          setState(() {
            _hovered = true;
          });
        }
      },
      onExit: (_) {
        if (mounted) {
          setState(() {
            _hovered = false;
          });
        }
      },
      child: GestureDetector(
        onTap: widget.onTap,
        child: Transform.translate(
          offset: Offset(0, _hovered ? -4.0 : 0.0),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 230),
            curve: Curves.easeOutCubic,
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: _hovered
                  ? FooterSection.primary
                  : Colors.white.withValues(alpha: 0.07),
              borderRadius: BorderRadius.circular(11),
              boxShadow: _hovered
                  ? [
                      BoxShadow(
                        color: FooterSection.primary.withValues(alpha: 0.28),
                        blurRadius: 15,
                        offset: const Offset(0, 7),
                      ),
                    ]
                  : [],
            ),
            child: AnimatedRotation(
              turns: _hovered ? 0.03 : 0.0,
              duration: const Duration(milliseconds: 220),
              child: Icon(
                widget.icon,
                size: 18,
                color: _hovered ? Colors.white : Colors.white70,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ============================================================
// DIVIDER
// ============================================================

class _AnimatedDivider extends StatefulWidget {
  const _AnimatedDivider();

  @override
  State<_AnimatedDivider> createState() => _AnimatedDividerState();
}

class _AnimatedDividerState extends State<_AnimatedDivider>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _width;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _width = CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic);

    Future.delayed(const Duration(milliseconds: 550), () {
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
    return AnimatedBuilder(
      animation: _width,
      builder: (context, child) {
        return FractionallySizedBox(widthFactor: _width.value, child: child);
      },
      child: Container(height: 1, color: Colors.white.withValues(alpha: 0.10)),
    );
  }
}

// ============================================================
// COPYRIGHT
// ============================================================

class _AnimatedCopyright extends StatelessWidget {
  const _AnimatedCopyright();

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 850),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        return Opacity(
          opacity: value.clamp(0.0, 1.0),
          child: Transform.translate(
            offset: Offset(0, 8 * (1 - value)),
            child: child,
          ),
        );
      },
      child: const Text(
        '© 2026 Sweet Water Tankers. All rights reserved.',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 12, color: FooterSection.muted),
      ),
    );
  }
}

// ============================================================
// DEVELOPER CREDIT
// ============================================================

class _DeveloperCredit extends StatefulWidget {
  const _DeveloperCredit();

  @override
  State<_DeveloperCredit> createState() => _DeveloperCreditState();
}

class _DeveloperCreditState extends State<_DeveloperCredit> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.basic,
      onEnter: (_) {
        if (mounted) {
          setState(() {
            _hovered = true;
          });
        }
      },
      onExit: (_) {
        if (mounted) {
          setState(() {
            _hovered = false;
          });
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: _hovered
              ? Colors.white.withValues(alpha: 0.055)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: _hovered
                ? FooterSection.primary.withValues(alpha: 0.20)
                : Colors.transparent,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 220),
              style: TextStyle(
                fontSize: 9.5,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.4,
                color: _hovered ? Colors.white : FooterSection.muted,
              ),
              child: const Text('DESIGNED & DEVELOPED BY'),
            ),

            const SizedBox(height: 7),

            AnimatedScale(
              scale: _hovered ? 1.03 : 1.0,
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeOutBack,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(9),
                child: Image.asset(
                  'assets/images/3.png',
                  width: 112,
                  height: 62,
                  fit: BoxFit.cover,
                  filterQuality: FilterQuality.high,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 112,
                      height: 62,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(9),
                      ),
                      child: const Text(
                        'Codistan',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                    );
                  },
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
// BOTTOM LINKS
// ============================================================

class _BottomLinks extends StatefulWidget {
  const _BottomLinks();

  @override
  State<_BottomLinks> createState() => _BottomLinksState();
}

class _BottomLinksState extends State<_BottomLinks> {
  String? _hovered;

  void _showLegalDialog(BuildContext context, String title) {
    final bool isPrivacy = title == 'Privacy Policy';

    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 620, maxHeight: 600),
            child: Padding(
              padding: const EdgeInsets.all(28),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: FooterSection.primary.withValues(alpha: 0.10),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          isPrivacy
                              ? Icons.privacy_tip_rounded
                              : Icons.description_rounded,
                          color: FooterSection.primary,
                          size: 22,
                        ),
                      ),

                      const SizedBox(width: 14),

                      Expanded(
                        child: Text(
                          title,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF102A43),
                          ),
                        ),
                      ),

                      IconButton(
                        tooltip: 'Close',
                        onPressed: () {
                          Navigator.of(dialogContext).pop();
                        },
                        icon: const Icon(Icons.close_rounded),
                      ),
                    ],
                  ),

                  const SizedBox(height: 22),

                  Flexible(
                    child: SingleChildScrollView(
                      child: Text(
                        isPrivacy ? _privacyText : _termsText,
                        style: const TextStyle(
                          fontSize: 14,
                          height: 1.7,
                          color: Color(0xFF52667A),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 22),

                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(dialogContext).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: FooterSection.primary,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 22,
                          vertical: 13,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Close',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
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

  static const String _privacyText =
      'Sweet Water Tankers respects your privacy. Information '
      'submitted through this website may be used to respond '
      'to your water delivery requests, quotations, enquiries '
      'and customer service communications.\n\n'
      'We aim to use customer information only for legitimate '
      'business and service purposes. Contact information '
      'provided for a quotation may be used to communicate '
      'with you regarding your request.\n\n'
      'This website is currently under development. The final '
      'privacy policy should be reviewed and updated by the '
      'business owner before the website is published.';

  static const String _termsText =
      'By using the Sweet Water Tankers website, you acknowledge '
      'that the information presented is provided for general '
      'service and enquiry purposes.\n\n'
      'Water delivery requests, pricing, availability, delivery '
      'times and service conditions may depend on location, '
      'quantity, water requirements and operational availability.\n\n'
      'This website is currently under development. The final '
      'terms and conditions should be reviewed and approved '
      'by the business owner before the website is published.';

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 20,
      runSpacing: 8,
      children: [
        _BottomLink(
          title: 'Privacy Policy',
          hovered: _hovered == 'privacy',
          onEnter: () {
            if (mounted) {
              setState(() {
                _hovered = 'privacy';
              });
            }
          },
          onExit: () {
            if (mounted) {
              setState(() {
                _hovered = null;
              });
            }
          },
          onTap: () {
            _showLegalDialog(context, 'Privacy Policy');
          },
        ),

        _BottomLink(
          title: 'Terms & Conditions',
          hovered: _hovered == 'terms',
          onEnter: () {
            if (mounted) {
              setState(() {
                _hovered = 'terms';
              });
            }
          },
          onExit: () {
            if (mounted) {
              setState(() {
                _hovered = null;
              });
            }
          },
          onTap: () {
            _showLegalDialog(context, 'Terms & Conditions');
          },
        ),
      ],
    );
  }
}

// ============================================================
// BOTTOM LINK
// ============================================================

class _BottomLink extends StatelessWidget {
  final String title;
  final bool hovered;
  final VoidCallback onEnter;
  final VoidCallback onExit;
  final VoidCallback onTap;

  const _BottomLink({
    required this.title,
    required this.hovered,
    required this.onEnter,
    required this.onExit,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => onEnter(),
      onExit: (_) => onExit(),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(5),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 3),
          child: AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 200),
            style: TextStyle(
              fontSize: 12,
              color: hovered ? Colors.white : FooterSection.muted,
              fontWeight: hovered ? FontWeight.w600 : FontWeight.w400,
            ),
            child: Text(title),
          ),
        ),
      ),
    );
  }
}
