import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({super.key});

  static const Color primary = Color(0xFF087EA4);
  static const Color darkText = Color(0xFF102A43);
  static const Color bodyText = Color(0xFF52667A);
  static const Color lightBg = Color(0xFFF6FBFD);

  // Temporary development contact
  static const String whatsappNumber = '923104939138';
  static const String phoneNumber = '+923104939138';

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage>
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
    final Uri url = Uri.parse(
      'https://wa.me/${ContactPage.whatsappNumber}'
      '?text=${Uri.encodeComponent('Hello AquaFlow Dubai, I would like to get information about your water delivery service.')}',
    );

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _makeCall() async {
    final Uri url = Uri.parse('tel:${ContactPage.phoneNumber}');

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Column(
          children: [
            const _TopBar(),
            _Hero(fade: _heroFade, slide: _heroSlide),
            _ContactContent(onWhatsApp: _openWhatsApp, onCall: _makeCall),
            const _ServiceInfo(),
            _BottomCta(onWhatsApp: _openWhatsApp),
            const _Footer(),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// ANIMATION HELPERS
// ============================================================

class _AnimatedReveal extends StatelessWidget {
  final Widget child;
  final int delay;

  const _AnimatedReveal({required this.child, this.delay = 0});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 700 + delay),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        final progress = value.clamp(0.0, 1.0);

        return Opacity(
          opacity: progress,
          child: Transform.translate(
            offset: Offset(0, 24 * (1 - progress)),
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}

// ============================================================
// TOP BAR
// ============================================================

class _TopBar extends StatefulWidget {
  const _TopBar();

  @override
  State<_TopBar> createState() => _TopBarState();
}

class _TopBarState extends State<_TopBar> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;

    final verySmall = width < 360;
    final mobile = width < 600;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: verySmall
            ? 10
            : mobile
            ? 14
            : 24,
        vertical: mobile ? 14 : 18,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: ContactPage.primary.withValues(alpha: 0.08),
          ),
        ),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1180),
          child: Row(
            children: [
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.75, end: 1.0),
                duration: const Duration(milliseconds: 700),
                curve: Curves.easeOutBack,
                builder: (context, value, child) {
                  return Transform.scale(scale: value, child: child);
                },
                child: Container(
                  width: mobile ? 40 : 44,
                  height: mobile ? 40 : 44,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [ContactPage.primary, Color(0xFF0AA8D0)],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: ContactPage.primary.withValues(alpha: 0.18),
                        blurRadius: 18,
                        offset: const Offset(0, 7),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.water_drop_rounded,
                    color: Colors.white,
                    size: mobile ? 22 : 25,
                  ),
                ),
              ),

              SizedBox(width: mobile ? 8 : 12),

              Expanded(
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
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'AquaFlow',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: mobile ? 17 : 19,
                          fontWeight: FontWeight.w800,
                          color: ContactPage.darkText,
                        ),
                      ),
                      const Text(
                        'DUBAI',
                        style: TextStyle(
                          fontSize: 8,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 2,
                          color: ContactPage.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(width: 8),

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
                            ? 9
                            : mobile
                            ? 11
                            : 18,
                        vertical: mobile ? 10 : 13,
                      ),
                      decoration: BoxDecoration(
                        color: _hovered
                            ? ContactPage.primary.withValues(alpha: 0.07)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: _hovered
                              ? ContactPage.primary.withValues(alpha: 0.38)
                              : ContactPage.primary.withValues(alpha: 0.25),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.arrow_back_rounded,
                            size: 17,
                            color: ContactPage.primary,
                          ),

                          if (!mobile) ...[
                            const SizedBox(width: 7),
                            const Text(
                              'Back Home',
                              style: TextStyle(
                                color: ContactPage.primary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ],
                      ),
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
// HERO
// ============================================================

class _Hero extends StatelessWidget {
  final Animation<double> fade;
  final Animation<Offset> slide;

  const _Hero({required this.fade, required this.slide});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;

    final mobile = width < 600;
    final verySmall = width < 380;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: mobile ? 18 : 24,
        vertical: mobile ? 55 : 78,
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
                      final progress = value.clamp(0.0, 1.0);

                      return Transform.scale(
                        scale: 0.88 + (progress * 0.12),
                        child: child,
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: ContactPage.primary.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: const Text(
                        'CONTACT AQUAFLOW',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: ContactPage.primary,
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.8,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  Text(
                    'Let’s Get Your Water\nDelivered.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: ContactPage.darkText,
                      fontSize: verySmall
                          ? 32
                          : mobile
                          ? 36
                          : 48,
                      height: 1.12,
                      fontWeight: FontWeight.w900,
                    ),
                  ),

                  const SizedBox(height: 18),

                  Text(
                    'Need water delivery in Dubai? Contact our team '
                    'and we’ll help you arrange the right solution '
                    'for your needs.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: ContactPage.bodyText,
                      fontSize: mobile ? 15 : 17,
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
  }
}

// ============================================================
// CONTACT CONTENT
// ============================================================

class _ContactContent extends StatelessWidget {
  final Future<void> Function() onWhatsApp;
  final Future<void> Function() onCall;

  const _ContactContent({required this.onWhatsApp, required this.onCall});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;

    final mobile = width < 600;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: mobile ? 16 : 24,
        vertical: mobile ? 50 : 85,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1180),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isMobile = constraints.maxWidth < 850;

              final info = _ContactInfo(onWhatsApp: onWhatsApp, onCall: onCall);

              const form = _ContactForm();

              if (isMobile) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [info, const SizedBox(height: 35), form],
                );
              }

              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: info),
                  const SizedBox(width: 55),
                  const Expanded(child: form),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

// ============================================================
// CONTACT INFO
// ============================================================

class _ContactInfo extends StatelessWidget {
  final Future<void> Function() onWhatsApp;
  final Future<void> Function() onCall;

  const _ContactInfo({required this.onWhatsApp, required this.onCall});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final mobile = width < 600;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _AnimatedReveal(
          child: Text(
            'GET IN TOUCH',
            style: TextStyle(
              color: ContactPage.primary,
              fontSize: 12,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.8,
            ),
          ),
        ),

        const SizedBox(height: 14),

        _AnimatedReveal(
          delay: 80,
          child: Text(
            'We’re Ready to Help',
            style: TextStyle(
              color: ContactPage.darkText,
              fontSize: mobile ? 28 : 35,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),

        const SizedBox(height: 15),

        const _AnimatedReveal(
          delay: 140,
          child: Text(
            'Whether you need a single delivery or regular '
            'water supply, our team is ready to assist you.',
            style: TextStyle(
              color: ContactPage.bodyText,
              fontSize: 15,
              height: 1.7,
            ),
          ),
        ),

        const SizedBox(height: 32),

        _ContactItem(
          icon: Icons.phone_rounded,
          title: 'Call Us',
          value: '+92 310 4939138',
          onTap: onCall,
          index: 0,
        ),

        const SizedBox(height: 14),

        _ContactItem(
          icon: Icons.chat_rounded,
          title: 'WhatsApp',
          value: 'Chat with our team',
          onTap: onWhatsApp,
          index: 1,
        ),

        const SizedBox(height: 14),

        const _ContactItem(
          icon: Icons.location_on_rounded,
          title: 'Service Area',
          value: 'Dubai, United Arab Emirates',
          index: 2,
        ),

        const SizedBox(height: 14),

        const _ContactItem(
          icon: Icons.access_time_rounded,
          title: 'Availability',
          value: '24/7 Water Delivery Support',
          index: 3,
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
  final String title;
  final String value;
  final Future<void> Function()? onTap;
  final int index;

  const _ContactItem({
    required this.icon,
    required this.title,
    required this.value,
    this.onTap,
    required this.index,
  });

  @override
  State<_ContactItem> createState() => _ContactItemState();
}

class _ContactItemState extends State<_ContactItem> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final mobile = width < 600;

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 550 + (widget.index * 100)),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        final progress = value.clamp(0.0, 1.0);

        return Opacity(
          opacity: progress,
          child: Transform.translate(
            offset: Offset(18 * (1 - progress), 0),
            child: child,
          ),
        );
      },
      child: MouseRegion(
        cursor: widget.onTap != null
            ? SystemMouseCursors.click
            : SystemMouseCursors.basic,
        onEnter: widget.onTap != null
            ? (_) {
                setState(() {
                  _hovered = true;
                });
              }
            : null,
        onExit: widget.onTap != null
            ? (_) {
                setState(() {
                  _hovered = false;
                });
              }
            : null,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: widget.onTap,
          child: AnimatedScale(
            scale: _hovered ? 1.015 : 1.0,
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOutCubic,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: double.infinity,
              padding: EdgeInsets.all(mobile ? 13 : 16),
              decoration: BoxDecoration(
                color: _hovered
                    ? ContactPage.primary.withValues(alpha: 0.055)
                    : ContactPage.lightBg,
                borderRadius: BorderRadius.circular(17),
                border: Border.all(
                  color: _hovered
                      ? ContactPage.primary.withValues(alpha: 0.18)
                      : ContactPage.primary.withValues(alpha: 0.07),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  AnimatedScale(
                    scale: _hovered ? 1.08 : 1.0,
                    duration: const Duration(milliseconds: 180),
                    curve: Curves.easeOutBack,
                    child: Container(
                      width: mobile ? 42 : 46,
                      height: mobile ? 42 : 46,
                      decoration: BoxDecoration(
                        color: ContactPage.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(13),
                      ),
                      child: Icon(
                        widget.icon,
                        color: ContactPage.primary,
                        size: mobile ? 20 : 22,
                      ),
                    ),
                  ),

                  SizedBox(width: mobile ? 11 : 14),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: ContactPage.darkText,
                            fontSize: mobile ? 13 : 14,
                            fontWeight: FontWeight.w800,
                          ),
                        ),

                        const SizedBox(height: 4),

                        Text(
                          widget.value,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: ContactPage.bodyText,
                            fontSize: mobile ? 12 : 13,
                            height: 1.35,
                          ),
                        ),
                      ],
                    ),
                  ),

                  if (widget.onTap != null) ...[
                    const SizedBox(width: 5),
                    AnimatedSlide(
                      offset: _hovered ? const Offset(0.12, 0) : Offset.zero,
                      duration: const Duration(milliseconds: 180),
                      child: const Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: ContactPage.primary,
                        size: 13,
                      ),
                    ),
                  ],
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
// CONTACT FORM
// ============================================================

class _ContactForm extends StatefulWidget {
  const _ContactForm();

  @override
  State<_ContactForm> createState() => _ContactFormState();
}

class _ContactFormState extends State<_ContactForm> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();

  final _phoneController = TextEditingController();

  final _messageController = TextEditingController();

  String _service = 'Sweet Water Supply';

  bool _sending = false;
  bool _buttonHovered = false;

  static const List<String> services = [
    'Sweet Water Supply',
    'Swimming Pool Water',
    'Residential Supply',
    'Commercial Supply',
    'Construction Water',
    'Garden & Nursery',
    'Wastewater Removal',
    'Emergency Delivery',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _sendMessage() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _sending = true;
    });

    final message =
        '''
Hello AquaFlow Dubai,

Name: ${_nameController.text.trim()}
Phone: ${_phoneController.text.trim()}
Service: $_service

Message:
${_messageController.text.trim()}
''';

    final Uri url = Uri.parse(
      'https://wa.me/${ContactPage.whatsappNumber}'
      '?text=${Uri.encodeComponent(message)}',
    );

    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      }
    } finally {
      if (mounted) {
        setState(() {
          _sending = false;
        });
      }
    }
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: ContactPage.primary, size: 20),
      filled: true,
      fillColor: ContactPage.lightBg,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(
          color: ContactPage.primary.withValues(alpha: 0.07),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: ContactPage.primary, width: 1.5),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;

    final mobile = width < 600;

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 850),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        final progress = value.clamp(0.0, 1.0);

        return Opacity(
          opacity: progress,
          child: Transform.translate(
            offset: Offset(0, 30 * (1 - progress)),
            child: child,
          ),
        );
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(mobile ? 18 : 28),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(26),
          border: Border.all(color: ContactPage.primary.withValues(alpha: 0.1)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 30,
              offset: const Offset(0, 15),
            ),
          ],
        ),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'SEND US A MESSAGE',
                style: TextStyle(
                  color: ContactPage.primary,
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.5,
                ),
              ),

              const SizedBox(height: 10),

              Text(
                'Request Information',
                style: TextStyle(
                  color: ContactPage.darkText,
                  fontSize: mobile ? 22 : 25,
                  fontWeight: FontWeight.w900,
                ),
              ),

              const SizedBox(height: 25),

              TextFormField(
                controller: _nameController,
                decoration: _inputDecoration(
                  'Your Name',
                  Icons.person_outline_rounded,
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 14),

              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: _inputDecoration(
                  'Phone Number',
                  Icons.phone_outlined,
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter your phone number';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 14),

              DropdownButtonFormField<String>(
                initialValue: _service,
                isExpanded: true,
                decoration: _inputDecoration(
                  'Service Required',
                  Icons.water_drop_outlined,
                ),
                items: services
                    .map(
                      (service) => DropdownMenuItem<String>(
                        value: service,
                        child: Text(
                          service,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _service = value;
                    });
                  }
                },
              ),

              const SizedBox(height: 14),

              TextFormField(
                controller: _messageController,
                maxLines: 5,
                decoration: _inputDecoration(
                  'Your Message',
                  Icons.message_outlined,
                ).copyWith(alignLabelWithHint: true),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter your message';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 20),

              MouseRegion(
                cursor: SystemMouseCursors.click,
                onEnter: (_) {
                  setState(() {
                    _buttonHovered = true;
                  });
                },
                onExit: (_) {
                  setState(() {
                    _buttonHovered = false;
                  });
                },
                child: GestureDetector(
                  onTap: _sending ? null : _sendMessage,
                  child: AnimatedScale(
                    scale: _buttonHovered && !_sending ? 1.015 : 1.0,
                    duration: const Duration(milliseconds: 180),
                    curve: Curves.easeOutCubic,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      width: double.infinity,
                      height: 52,
                      decoration: BoxDecoration(
                        color: _buttonHovered
                            ? const Color(0xFF096F90)
                            : ContactPage.primary,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Center(
                        child: _sending
                            ? const SizedBox(
                                width: 21,
                                height: 21,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              )
                            : FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.chat_rounded,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 8),
                                    const Text(
                                      'Send on WhatsApp',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                    const SizedBox(width: 7),
                                    AnimatedSlide(
                                      offset: _buttonHovered
                                          ? const Offset(0.12, 0)
                                          : Offset.zero,
                                      duration: const Duration(
                                        milliseconds: 180,
                                      ),
                                      child: const Icon(
                                        Icons.arrow_forward_rounded,
                                        color: Colors.white,
                                        size: 17,
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
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================
// SERVICE INFO
// ============================================================

class _ServiceInfo extends StatelessWidget {
  const _ServiceInfo();

  @override
  Widget build(BuildContext context) {
    const items = [
      (
        Icons.water_drop_rounded,
        'Fresh Water Supply',
        'Reliable tanker water for homes and businesses.',
      ),
      (
        Icons.pool_rounded,
        'Pool Water',
        'Water delivery solutions for swimming pools.',
      ),
      (
        Icons.construction_rounded,
        'Project Supply',
        'Water support for construction and site requirements.',
      ),
    ];

    final width = MediaQuery.sizeOf(context).width;
    final mobile = width < 600;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: mobile ? 16 : 24,
        vertical: mobile ? 55 : 75,
      ),
      color: ContactPage.lightBg,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final contentWidth = constraints.maxWidth;

              if (contentWidth < 700) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: List.generate(items.length, (index) {
                    final item = items[index];

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 14),
                      child: _InfoCard(
                        icon: item.$1,
                        title: item.$2,
                        text: item.$3,
                        index: index,
                      ),
                    );
                  }),
                );
              }

              if (contentWidth < 950) {
                final cardWidth = (contentWidth - 14) / 2;

                return Wrap(
                  spacing: 14,
                  runSpacing: 14,
                  children: List.generate(items.length, (index) {
                    final item = items[index];

                    return SizedBox(
                      width: cardWidth,
                      child: _InfoCard(
                        icon: item.$1,
                        title: item.$2,
                        text: item.$3,
                        index: index,
                      ),
                    );
                  }),
                );
              }

              final cardWidth = (contentWidth - 28) / 3;

              return Wrap(
                spacing: 14,
                runSpacing: 14,
                children: List.generate(items.length, (index) {
                  final item = items[index];

                  return SizedBox(
                    width: cardWidth,
                    child: _InfoCard(
                      icon: item.$1,
                      title: item.$2,
                      text: item.$3,
                      index: index,
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
// INFO CARD
// ============================================================

class _InfoCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final String text;
  final int index;

  const _InfoCard({
    required this.icon,
    required this.title,
    required this.text,
    required this.index,
  });

  @override
  State<_InfoCard> createState() => _InfoCardState();
}

class _InfoCardState extends State<_InfoCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final mobile = width < 600;

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 550 + (widget.index * 120)),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        final progress = value.clamp(0.0, 1.0);

        return Opacity(
          opacity: progress,
          child: Transform.translate(
            offset: Offset(0, 22 * (1 - progress)),
            child: child,
          ),
        );
      },
      child: MouseRegion(
        cursor: SystemMouseCursors.basic,
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
        child: AnimatedScale(
          scale: _hovered ? 1.02 : 1.0,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutCubic,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: double.infinity,
            padding: EdgeInsets.all(mobile ? 18 : 24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: _hovered
                    ? ContactPage.primary.withValues(alpha: 0.2)
                    : ContactPage.primary.withValues(alpha: 0.08),
              ),
              boxShadow: _hovered
                  ? [
                      BoxShadow(
                        color: ContactPage.primary.withValues(alpha: 0.10),
                        blurRadius: 22,
                        offset: const Offset(0, 10),
                      ),
                    ]
                  : null,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AnimatedScale(
                  scale: _hovered ? 1.08 : 1.0,
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeOutBack,
                  child: Container(
                    width: mobile ? 44 : 48,
                    height: mobile ? 44 : 48,
                    decoration: BoxDecoration(
                      color: ContactPage.primary.withValues(alpha: 0.09),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(
                      widget.icon,
                      color: ContactPage.primary,
                      size: mobile ? 21 : 23,
                    ),
                  ),
                ),

                SizedBox(width: mobile ? 11 : 14),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: ContactPage.darkText,
                          fontSize: mobile ? 14 : 15,
                          fontWeight: FontWeight.w800,
                        ),
                      ),

                      const SizedBox(height: 5),

                      Text(
                        widget.text,
                        style: TextStyle(
                          color: ContactPage.bodyText,
                          fontSize: mobile ? 12 : 12,
                          height: 1.45,
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
// BOTTOM CTA
// ============================================================

class _BottomCta extends StatefulWidget {
  final Future<void> Function() onWhatsApp;

  const _BottomCta({required this.onWhatsApp});

  @override
  State<_BottomCta> createState() => _BottomCtaState();
}

class _BottomCtaState extends State<_BottomCta> {
  bool _hovered = false;
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;

    final mobile = width < 600;
    final verySmall = width < 380;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: mobile ? 16 : 24,
        vertical: mobile ? 55 : 80,
      ),
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
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                horizontal: mobile ? 18 : 30,
                vertical: mobile ? 32 : 42,
              ),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF075B78), ContactPage.primary],
                ),
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: ContactPage.primary.withValues(alpha: 0.18),
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
                      fontSize: verySmall
                          ? 23
                          : mobile
                          ? 25
                          : 30,
                      fontWeight: FontWeight.w900,
                    ),
                  ),

                  const SizedBox(height: 12),

                  Text(
                    'Talk to AquaFlow Dubai today.',
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
                      onTap: widget.onWhatsApp,
                      child: AnimatedScale(
                        scale: _pressed
                            ? 0.96
                            : _hovered
                            ? 1.04
                            : 1.0,
                        duration: const Duration(milliseconds: 180),
                        curve: Curves.easeOutCubic,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 180),
                          padding: EdgeInsets.symmetric(
                            horizontal: verySmall
                                ? 15
                                : mobile
                                ? 18
                                : 24,
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
                                Icons.chat_rounded,
                                color: ContactPage.primary,
                                size: 20,
                              ),

                              const SizedBox(width: 8),

                              Flexible(
                                child: Text(
                                  'Chat on WhatsApp',
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: ContactPage.primary,
                                    fontSize: mobile ? 13 : 14,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),

                              const SizedBox(width: 7),

                              AnimatedSlide(
                                offset: _hovered
                                    ? const Offset(0.15, 0)
                                    : Offset.zero,
                                duration: const Duration(milliseconds: 180),
                                child: const Icon(
                                  Icons.arrow_forward_rounded,
                                  color: ContactPage.primary,
                                  size: 17,
                                ),
                              ),
                            ],
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
    final width = MediaQuery.sizeOf(context).width;
    final mobile = width < 600;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: mobile ? 18 : 24, vertical: 32),
      color: const Color(0xFF071D2B),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1180),
          child: Column(
            children: [
              TweenAnimationBuilder<double>(
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
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: ContactPage.primary,
                        borderRadius: BorderRadius.circular(11),
                      ),
                      child: const Icon(
                        Icons.water_drop_rounded,
                        color: Colors.white,
                        size: 22,
                      ),
                    ),

                    const SizedBox(width: 12),

                    Flexible(
                      child: Text(
                        'AquaFlow Dubai',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: mobile ? 16 : 17,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              Divider(color: Colors.white.withValues(alpha: 0.08)),

              const SizedBox(height: 18),

              Text(
                '© 2026 AquaFlow Dubai. '
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
    );
  }
}
