import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class FaqSection extends StatefulWidget {
  const FaqSection({super.key});

  static const Color primary = Color(0xFF087EA4);
  static const Color darkText = Color(0xFF102A43);
  static const Color bodyText = Color(0xFF52667A);
  static const Color lightBg = Color(0xFFF6FBFD);

  // ============================================================
  // WHATSAPP NUMBER
  // ============================================================

  static const String whatsappNumber = '971551027786';

  // ============================================================
  // WHATSAPP URL
  // ============================================================

  static Uri get whatsappUrl {
    const message =
        'Hello Sweet Water Tankers, I would like to get information '
        'about your water delivery service.';

    return Uri.https('wa.me', '/$whatsappNumber', {'text': message});
  }

  @override
  State<FaqSection> createState() => _FaqSectionState();
}

class _FaqSectionState extends State<FaqSection>
    with SingleTickerProviderStateMixin {
  int? expandedIndex;

  late final AnimationController _animationController;

  late final Animation<double> _headingFade;
  late final Animation<Offset> _headingSlide;
  late final Animation<double> _faqFade;
  late final Animation<Offset> _faqSlide;

  final List<_FaqItem> faqs = const [
    _FaqItem(
      question: 'What type of water do you supply?',
      answer:
          'We provide sweet water and other water delivery solutions '
          'for residential, commercial, construction and bulk requirements.',
    ),
    _FaqItem(
      question: 'Do you deliver water across Dubai?',
      answer:
          'Yes. Our service is designed to cover locations throughout '
          'Dubai. Contact our team with your delivery location and '
          'requirement so we can confirm availability.',
    ),
    _FaqItem(
      question: 'How quickly can I get a water tanker?',
      answer:
          'Delivery time depends on your location, tanker availability '
          'and the size of your order. For urgent requirements, contact '
          'our team directly for the fastest available option.',
    ),
    _FaqItem(
      question: 'Do you supply water for swimming pools?',
      answer:
          'Yes. We provide water delivery for swimming pool filling '
          'and maintenance requirements.',
    ),
    _FaqItem(
      question: 'Can you supply water for construction sites?',
      answer:
          'Yes. We can arrange water tanker delivery for construction '
          'sites and larger project requirements.',
    ),
    _FaqItem(
      question: 'How do I request a water delivery?',
      answer:
          'Simply contact us with your location, required quantity '
          'and preferred delivery time. Our team will confirm the '
          'available tanker and delivery details.',
    ),
    _FaqItem(
      question: 'Do you provide emergency water delivery?',
      answer:
          'We can assist with urgent water requirements depending on '
          'tanker availability and location. Contact our team directly '
          'for urgent requests.',
    ),
  ];

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1300),
    );

    _headingFade = CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.28, curve: Curves.easeOut),
    );

    _headingSlide =
        Tween<Offset>(begin: const Offset(0, 0.12), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: const Interval(0.0, 0.28, curve: Curves.easeOutCubic),
          ),
        );

    _faqFade = CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.18, 1.0, curve: Curves.easeOut),
    );

    _faqSlide = Tween<Offset>(begin: const Offset(0, 0.08), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _animationController,
            curve: const Interval(0.18, 1.0, curve: Curves.easeOutCubic),
          ),
        );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _animationController.forward();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleFaq(int index) {
    setState(() {
      expandedIndex = expandedIndex == index ? null : index;
    });
  }

  Future<void> _openWhatsApp() async {
    try {
      final uri = FaqSection.whatsappUrl;

      await launchUrl(uri, mode: LaunchMode.platformDefault);
    } catch (_) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Unable to open WhatsApp. Please try again.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 800;

    return Container(
      width: double.infinity,
      color: FaqSection.lightBg,
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
            opacity: _faqFade,
            child: SlideTransition(
              position: _faqSlide,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 900),
                child: Column(
                  children: [
                    ...List.generate(faqs.length, (index) {
                      final isExpanded = expandedIndex == index;

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _FaqCard(
                          item: faqs[index],
                          index: index,
                          isExpanded: isExpanded,
                          onTap: () => _toggleFaq(index),
                        ),
                      );
                    }),

                    const SizedBox(height: 35),

                    // ==================================================
                    // WHATSAPP CTA
                    // ==================================================
                    _WhatsAppButton(isMobile: isMobile, onTap: _openWhatsApp),
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
              'FAQ',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.8,
                color: FaqSection.primary,
              ),
            ),
          ),
        ),

        const SizedBox(height: 18),

        Text(
          'Frequently Asked Questions',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: isMobile ? 31 : 44,
            height: 1.15,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.8,
            color: FaqSection.darkText,
          ),
        ),

        const SizedBox(height: 15),

        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 650),
          child: const Text(
            'Everything you need to know about our water tanker '
            'delivery service.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              height: 1.7,
              color: FaqSection.bodyText,
            ),
          ),
        ),
      ],
    );
  }
}

// ============================================================
// FAQ CARD
// ============================================================

class _FaqCard extends StatefulWidget {
  final _FaqItem item;
  final int index;
  final bool isExpanded;
  final VoidCallback onTap;

  const _FaqCard({
    required this.item,
    required this.index,
    required this.isExpanded,
    required this.onTap,
  });

  @override
  State<_FaqCard> createState() => _FaqCardState();
}

class _FaqCardState extends State<_FaqCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  bool _isHovered = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 650 + (widget.index * 90)),
    );

    Future.delayed(Duration(milliseconds: 100 + (widget.index * 90)), () {
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
    final active = widget.isExpanded || _isHovered;

    return FadeTransition(
      opacity: CurvedAnimation(parent: _controller, curve: Curves.easeOut),
      child: SlideTransition(
        position: Tween<Offset>(begin: const Offset(0, 0.10), end: Offset.zero)
            .animate(
              CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
            ),
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          onEnter: (_) => _setHover(true),
          onExit: (_) => _setHover(false),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 260),
            curve: Curves.easeOutCubic,
            transform: Matrix4.translationValues(
              0,
              _isHovered && !widget.isExpanded ? -3 : 0,
              0,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: widget.isExpanded
                    ? const Color(0xFFB9E8F1)
                    : _isHovered
                    ? const Color(0xFFCDEDF3)
                    : const Color(0xFFE1EEF2),
                width: widget.isExpanded ? 1.3 : 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(
                    alpha: widget.isExpanded
                        ? 0.065
                        : _isHovered
                        ? 0.045
                        : 0.025,
                  ),
                  blurRadius: widget.isExpanded
                      ? 24
                      : _isHovered
                      ? 20
                      : 15,
                  offset: Offset(
                    0,
                    widget.isExpanded
                        ? 9
                        : _isHovered
                        ? 8
                        : 7,
                  ),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: widget.onTap,
                borderRadius: BorderRadius.circular(18),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 22,
                    vertical: 20,
                  ),
                  child: Column(
                    children: [
                      // ==================================================
                      // QUESTION ROW
                      // ==================================================

                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 260),
                            width: 38,
                            height: 38,
                            decoration: BoxDecoration(
                              color: widget.isExpanded
                                  ? FaqSection.primary
                                  : _isHovered
                                  ? const Color(0xFFDFF5F8)
                                  : const Color(0xFFEAF8FB),
                              borderRadius: BorderRadius.circular(11),
                            ),
                            child: AnimatedScale(
                              scale: active ? 1.08 : 1.0,
                              duration: const Duration(milliseconds: 220),
                              curve: Curves.easeOutBack,
                              child: Icon(
                                widget.isExpanded
                                    ? Icons.help_rounded
                                    : Icons.help_outline_rounded,
                                size: 19,
                                color: widget.isExpanded
                                    ? Colors.white
                                    : FaqSection.primary,
                              ),
                            ),
                          ),

                          const SizedBox(width: 14),

                          Expanded(
                            child: Text(
                              widget.item.question,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                                color: FaqSection.darkText,
                              ),
                            ),
                          ),

                          const SizedBox(width: 12),

                          AnimatedRotation(
                            duration: const Duration(milliseconds: 280),
                            curve: Curves.easeOutCubic,
                            turns: widget.isExpanded ? 0.5 : 0,
                            child: AnimatedScale(
                              scale: _isHovered ? 1.12 : 1.0,
                              duration: const Duration(milliseconds: 200),
                              child: const Icon(
                                Icons.keyboard_arrow_down_rounded,
                                color: FaqSection.primary,
                                size: 25,
                              ),
                            ),
                          ),
                        ],
                      ),

                      // ==================================================
                      // ANSWER
                      // ==================================================
                      AnimatedCrossFade(
                        duration: const Duration(milliseconds: 300),
                        firstCurve: Curves.easeOut,
                        secondCurve: Curves.easeOutCubic,
                        sizeCurve: Curves.easeInOutCubic,
                        crossFadeState: widget.isExpanded
                            ? CrossFadeState.showSecond
                            : CrossFadeState.showFirst,
                        firstChild: const SizedBox.shrink(),
                        secondChild: Padding(
                          padding: const EdgeInsets.only(
                            left: 52,
                            right: 35,
                            top: 14,
                          ),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: AnimatedOpacity(
                              opacity: widget.isExpanded ? 1.0 : 0.0,
                              duration: const Duration(milliseconds: 220),
                              child: Text(
                                widget.item.answer,
                                style: const TextStyle(
                                  fontSize: 13.5,
                                  height: 1.65,
                                  color: FaqSection.bodyText,
                                ),
                              ),
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
        ),
      ),
    );
  }
}

// ============================================================
// WHATSAPP BUTTON
// ============================================================

class _WhatsAppButton extends StatefulWidget {
  final bool isMobile;
  final VoidCallback onTap;

  const _WhatsAppButton({required this.isMobile, required this.onTap});

  @override
  State<_WhatsAppButton> createState() => _WhatsAppButtonState();
}

class _WhatsAppButtonState extends State<_WhatsAppButton> {
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
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        transform: Matrix4.translationValues(0, _hovered ? -3 : 0, 0),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: widget.onTap,
            borderRadius: BorderRadius.circular(16),
            child: Ink(
              padding: EdgeInsets.symmetric(
                horizontal: widget.isMobile ? 22 : 30,
                vertical: 16,
              ),
              decoration: BoxDecoration(
                color: FaqSection.primary,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: FaqSection.primary.withValues(alpha: 0.22),
                    blurRadius: _hovered ? 24 : 18,
                    offset: Offset(0, _hovered ? 10 : 7),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.16),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.chat_rounded,
                      color: Colors.white,
                      size: 21,
                    ),
                  ),

                  const SizedBox(width: 13),

                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Have More Questions?',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Chat with us on WhatsApp',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(width: 18),

                  const Icon(
                    Icons.arrow_forward_rounded,
                    color: Colors.white,
                    size: 20,
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
// DATA
// ============================================================

class _FaqItem {
  final String question;
  final String answer;

  const _FaqItem({required this.question, required this.answer});
}
