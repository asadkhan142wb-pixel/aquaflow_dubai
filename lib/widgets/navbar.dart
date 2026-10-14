import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../screens/about_page.dart';
import '../screens/services_page.dart';
import '../screens/gallery_page.dart';
import '../screens/contact_page.dart';

class Navbar extends StatelessWidget {
  const Navbar({super.key, this.onAreas});

  final VoidCallback? onAreas;

  static const Color primary = Color(0xFF087EA4);
  static const Color darkText = Color(0xFF102A43);
  static const Color bodyText = Color(0xFF334E68);

  static const String whatsappNumber = '971551027786';
  static const String phoneNumber = '+971551027786';

  // ============================================================
  // LOGO / FAVICON
  // ============================================================

  static const String logoAsset = 'assets/images/favicon.png';

  // ============================================================
  // WHATSAPP URL
  // ============================================================

  static Uri get whatsappUrl {
    const message =
        'Hello Sweet Water Tankers, I would like to request a water delivery quote.';

    return Uri.https('wa.me', '/$whatsappNumber', {'text': message});
  }

  // ============================================================
  // NAVIGATION
  // ============================================================

  void _goHome(BuildContext context) {
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  void _goAbout(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => const AboutPage()));
  }

  void _goServices(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => const ServicesPage()));
  }

  void _goGallery(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => const GalleryPage()));
  }

  void _goContact(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => const ContactPage()));
  }

  // ============================================================
  // WHATSAPP
  // ============================================================

  Future<void> _openWhatsApp() async {
    try {
      await launchUrl(Navbar.whatsappUrl, mode: LaunchMode.platformDefault);
    } catch (_) {
      // Keep navigation safe on web.
    }
  }

  // ============================================================
  // PHONE
  // ============================================================

  Future<void> _callNow() async {
    final Uri phoneUrl = Uri.parse('tel:$phoneNumber');

    try {
      await launchUrl(phoneUrl, mode: LaunchMode.platformDefault);
    } catch (_) {
      // Keep navigation safe on web.
    }
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double width = constraints.maxWidth;

        final bool isMobile = width < 850;
        final bool isVerySmall = width < 360;

        return Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? (isVerySmall ? 10 : 14) : 50,
            vertical: isMobile ? 10 : 14,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              bottom: BorderSide(
                color: primary.withValues(alpha: 0.06),
                width: 1,
              ),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.055),
                blurRadius: 18,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: isMobile
              ? _mobileNavbar(context, isVerySmall: isVerySmall)
              : _desktopNavbar(context),
        );
      },
    );
  }

  // ============================================================
  // DESKTOP NAVBAR
  // ============================================================

  Widget _desktopNavbar(BuildContext context) {
    return SizedBox(
      height: 52,
      child: Row(
        children: [
          // LOGO
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () => _goHome(context),
              child: _logo(),
            ),
          ),

          const Spacer(),

          // NAVIGATION
          _navItem('Home', () => _goHome(context)),

          _navItem('About', () => _goAbout(context)),

          _navItem('Services', () => _goServices(context)),

          _navItem('Areas', () {
            if (onAreas != null) {
              onAreas!();
            }
          }),

          _navItem('Gallery', () => _goGallery(context)),

          _navItem('Contact', () => _goContact(context)),

          const SizedBox(width: 18),

          // GET A QUOTE
          _QuoteButton(onPressed: _openWhatsApp),
        ],
      ),
    );
  }

  // ============================================================
  // MOBILE NAVBAR
  // ============================================================

  Widget _mobileNavbar(BuildContext context, {required bool isVerySmall}) {
    return SizedBox(
      height: isVerySmall ? 42 : 46,
      child: Row(
        children: [
          // LOGO
          Expanded(
            child: GestureDetector(
              onTap: () => _goHome(context),
              child: _mobileLogo(isVerySmall: isVerySmall),
            ),
          ),

          SizedBox(width: isVerySmall ? 4 : 8),

          // MENU BUTTON
          _MobileMenuButton(
            isVerySmall: isVerySmall,
            onPressed: () {
              _showMobileMenu(context);
            },
          ),
        ],
      ),
    );
  }

  // ============================================================
  // MOBILE LOGO
  // ============================================================

  Widget _mobileLogo({required bool isVerySmall}) {
    final double iconSize = isVerySmall ? 36 : 40;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: iconSize,
          height: iconSize,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(isVerySmall ? 9 : 11),
            boxShadow: [
              BoxShadow(
                color: primary.withValues(alpha: 0.14),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: Padding(
            padding: const EdgeInsets.all(2),
            child: Image.asset(
              logoAsset,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return Icon(
                  Icons.water_drop_rounded,
                  color: primary,
                  size: isVerySmall ? 21 : 23,
                );
              },
            ),
          ),
        ),

        SizedBox(width: isVerySmall ? 7 : 9),

        Flexible(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Sweet Water',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: darkText,
                  fontSize: isVerySmall ? 16 : 18,
                  fontWeight: FontWeight.w800,
                  height: 1.0,
                ),
              ),

              const SizedBox(height: 2),

              Text(
                'TANKERS',
                maxLines: 1,
                overflow: TextOverflow.clip,
                style: TextStyle(
                  color: primary,
                  fontSize: isVerySmall ? 7 : 8,
                  fontWeight: FontWeight.w800,
                  letterSpacing: isVerySmall ? 1.5 : 1.8,
                  height: 1.0,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ============================================================
  // DESKTOP / GENERAL LOGO
  // ============================================================

  Widget _logo() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 43,
          height: 43,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: primary.withValues(alpha: 0.14),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: Padding(
            padding: const EdgeInsets.all(2),
            child: Image.asset(
              logoAsset,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(
                  Icons.water_drop_rounded,
                  color: primary,
                  size: 25,
                );
              },
            ),
          ),
        ),

        const SizedBox(width: 10),

        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Sweet Water',
              style: TextStyle(
                color: darkText,
                fontSize: 19,
                fontWeight: FontWeight.w800,
                height: 1.0,
              ),
            ),
            SizedBox(height: 3),
            Text(
              'TANKERS',
              style: TextStyle(
                color: primary,
                fontSize: 9,
                fontWeight: FontWeight.w800,
                letterSpacing: 2,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ============================================================
  // NAV ITEM
  // ============================================================

  Widget _navItem(String title, VoidCallback onTap) {
    return _AnimatedNavItem(title: title, onTap: onTap);
  }

  // ============================================================
  // MOBILE MENU
  // ============================================================

  void _showMobileMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      useSafeArea: true,
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.90,
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
      ),
      builder: (sheetContext) {
        final double screenHeight = MediaQuery.of(sheetContext).size.height;

        final bool isSmallHeight = screenHeight < 650;

        return SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.fromLTRB(20, 14, 20, isSmallHeight ? 16 : 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // HANDLE
                  Container(
                    width: 45,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),

                  SizedBox(height: isSmallHeight ? 14 : 20),

                  // LOGO
                  Align(alignment: Alignment.centerLeft, child: _logo()),

                  SizedBox(height: isSmallHeight ? 10 : 16),

                  // HOME
                  _mobileItem(
                    sheetContext,
                    'Home',
                    Icons.home_outlined,
                    () => _goHome(context),
                    compact: isSmallHeight,
                  ),

                  // ABOUT
                  _mobileItem(
                    sheetContext,
                    'About',
                    Icons.info_outline_rounded,
                    () => _goAbout(context),
                    compact: isSmallHeight,
                  ),

                  // SERVICES
                  _mobileItem(
                    sheetContext,
                    'Services',
                    Icons.water_drop_outlined,
                    () => _goServices(context),
                    compact: isSmallHeight,
                  ),

                  // AREAS
                  _mobileItem(
                    sheetContext,
                    'Areas',
                    Icons.location_on_outlined,
                    () {
                      if (onAreas != null) {
                        onAreas!();
                      }
                    },
                    compact: isSmallHeight,
                  ),

                  // GALLERY
                  _mobileItem(
                    sheetContext,
                    'Gallery',
                    Icons.photo_library_outlined,
                    () => _goGallery(context),
                    compact: isSmallHeight,
                  ),

                  // CONTACT
                  _mobileItem(
                    sheetContext,
                    'Contact',
                    Icons.phone_outlined,
                    () => _goContact(context),
                    compact: isSmallHeight,
                  ),

                  SizedBox(height: isSmallHeight ? 6 : 10),

                  // GET A QUOTE
                  _MobileQuoteButton(
                    compact: isSmallHeight,
                    onPressed: () {
                      Navigator.of(sheetContext).pop();

                      _openWhatsApp();
                    },
                  ),

                  SizedBox(height: isSmallHeight ? 2 : 6),

                  // PHONE
                  TextButton.icon(
                    onPressed: () {
                      Navigator.of(sheetContext).pop();
                      _callNow();
                    },
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: isSmallHeight ? 6 : 8,
                      ),
                    ),
                    icon: const Icon(Icons.phone, color: primary, size: 20),
                    label: const Text(
                      phoneNumber,
                      style: TextStyle(
                        color: darkText,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
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

  // ============================================================
  // MOBILE MENU ITEM
  // ============================================================

  Widget _mobileItem(
    BuildContext sheetContext,
    String title,
    IconData icon,
    VoidCallback onTap, {
    bool compact = false,
  }) {
    return _MobileNavItem(
      title: title,
      icon: icon,
      compact: compact,
      onTap: () {
        Navigator.of(sheetContext).pop();
        onTap();
      },
    );
  }
}

// ================================================================
// DESKTOP NAV ITEM
// ================================================================

class _AnimatedNavItem extends StatefulWidget {
  const _AnimatedNavItem({required this.title, required this.onTap});

  final String title;
  final VoidCallback onTap;

  @override
  State<_AnimatedNavItem> createState() => _AnimatedNavItemState();
}

class _AnimatedNavItemState extends State<_AnimatedNavItem> {
  bool _hovered = false;

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
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 3),
        child: TextButton(
          onPressed: widget.onTap,
          style: TextButton.styleFrom(
            foregroundColor: Navbar.darkText,
            padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            backgroundColor: _hovered
                ? Navbar.primary.withValues(alpha: 0.07)
                : Colors.transparent,
          ),
          child: AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOut,
            style: TextStyle(
              color: _hovered ? Navbar.primary : Navbar.bodyText,
              fontSize: 14,
              fontWeight: _hovered ? FontWeight.w700 : FontWeight.w600,
            ),
            child: Text(widget.title),
          ),
        ),
      ),
    );
  }
}

// ================================================================
// DESKTOP QUOTE BUTTON
// ================================================================

class _QuoteButton extends StatefulWidget {
  const _QuoteButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  State<_QuoteButton> createState() => _QuoteButtonState();
}

class _QuoteButtonState extends State<_QuoteButton> {
  bool _hovered = false;
  bool _pressed = false;

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
        onTap: widget.onPressed,
        child: AnimatedScale(
          scale: _pressed ? 0.96 : (_hovered ? 1.02 : 1.0),
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeOut,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOut,
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 13),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Navbar.primary,
                  Navbar.primary.withValues(alpha: _hovered ? 0.82 : 0.92),
                ],
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Navbar.primary.withValues(
                    alpha: _hovered ? 0.25 : 0.12,
                  ),
                  blurRadius: _hovered ? 16 : 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.chat_bubble_outline_rounded,
                  color: Colors.white,
                  size: 17,
                ),
                SizedBox(width: 8),
                Text(
                  'Get a Quote',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
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

// ================================================================
// MOBILE MENU BUTTON
// ================================================================

class _MobileMenuButton extends StatefulWidget {
  const _MobileMenuButton({required this.isVerySmall, required this.onPressed});

  final bool isVerySmall;
  final VoidCallback onPressed;

  @override
  State<_MobileMenuButton> createState() => _MobileMenuButtonState();
}

class _MobileMenuButtonState extends State<_MobileMenuButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final double size = widget.isVerySmall ? 40 : 44;

    return GestureDetector(
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
      onTap: widget.onPressed,
      child: AnimatedScale(
        scale: _pressed ? 0.92 : 1.0,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: Navbar.primary.withValues(alpha: 0.07),
            borderRadius: BorderRadius.circular(widget.isVerySmall ? 11 : 13),
            border: Border.all(color: Navbar.primary.withValues(alpha: 0.10)),
          ),
          child: Icon(
            Icons.menu_rounded,
            size: widget.isVerySmall ? 25 : 28,
            color: Navbar.darkText,
          ),
        ),
      ),
    );
  }
}

// ================================================================
// MOBILE NAV ITEM
// ================================================================

class _MobileNavItem extends StatefulWidget {
  const _MobileNavItem({
    required this.title,
    required this.icon,
    required this.onTap,
    required this.compact,
  });

  final String title;
  final IconData icon;
  final VoidCallback onTap;
  final bool compact;

  @override
  State<_MobileNavItem> createState() => _MobileNavItemState();
}

class _MobileNavItemState extends State<_MobileNavItem> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final double height = widget.compact ? 48 : 54;
    final double iconBox = widget.compact ? 36 : 40;

    return SizedBox(
      height: height,
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
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeOut,
          padding: EdgeInsets.symmetric(horizontal: widget.compact ? 6 : 8),
          decoration: BoxDecoration(
            color: _pressed
                ? Navbar.primary.withValues(alpha: 0.06)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Container(
                width: iconBox,
                height: iconBox,
                decoration: BoxDecoration(
                  color: Navbar.primary.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(11),
                ),
                child: Icon(
                  widget.icon,
                  color: Navbar.primary,
                  size: widget.compact ? 19 : 21,
                ),
              ),

              const SizedBox(width: 13),

              Expanded(
                child: Text(
                  widget.title,
                  style: TextStyle(
                    color: Navbar.darkText,
                    fontSize: widget.compact ? 14 : 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 14,
                color: Colors.grey,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ================================================================
// MOBILE QUOTE BUTTON
// ================================================================

class _MobileQuoteButton extends StatefulWidget {
  const _MobileQuoteButton({required this.compact, required this.onPressed});

  final bool compact;
  final VoidCallback onPressed;

  @override
  State<_MobileQuoteButton> createState() => _MobileQuoteButtonState();
}

class _MobileQuoteButtonState extends State<_MobileQuoteButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
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
      onTap: widget.onPressed,
      child: AnimatedScale(
        scale: _pressed ? 0.98 : 1.0,
        duration: const Duration(milliseconds: 130),
        curve: Curves.easeOut,
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: widget.compact ? 12 : 15),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Navbar.primary, Navbar.primary.withValues(alpha: 0.88)],
            ),
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: Navbar.primary.withValues(alpha: 0.18),
                blurRadius: 14,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.chat_outlined, color: Colors.white, size: 20),
              SizedBox(width: 8),
              Text(
                'Get a Quote',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
