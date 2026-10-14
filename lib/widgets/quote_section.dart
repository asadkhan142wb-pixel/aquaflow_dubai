import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class QuoteSection extends StatefulWidget {
  const QuoteSection({super.key});

  static const Color primary = Color(0xFF087EA4);
  static const Color dark = Color(0xFF08263A);
  static const Color bodyText = Color(0xFF52667A);

  // WhatsApp number.
  // Change this later when the client's real number is available.
  static const String whatsappNumber = '971551027786';

  // ============================================================
  // STANDARD SERVICE LIST
  // ============================================================

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

  static const List<String> deliveryTimes = [
    'As Soon As Possible',
    'Morning',
    'Afternoon',
    'Evening',
    'Night',
    'Flexible',
  ];

  @override
  State<QuoteSection> createState() => _QuoteSectionState();
}

class _QuoteSectionState extends State<QuoteSection>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _locationController = TextEditingController();
  final _quantityController = TextEditingController();
  final _detailsController = TextEditingController();

  String? _selectedService;
  String? _selectedTime;

  // ============================================================
  // ANIMATION
  // ============================================================

  late final AnimationController _animationController;

  late final Animation<double> _headingFade;
  late final Animation<Offset> _headingSlide;

  late final Animation<double> _contentFade;

  // ============================================================
  // LOCAL STORAGE KEYS
  // ============================================================

  static const String _nameKey = 'aquaflow_quote_name';
  static const String _phoneKey = 'aquaflow_quote_phone';
  static const String _locationKey = 'aquaflow_quote_location';
  static const String _quantityKey = 'aquaflow_quote_quantity';
  static const String _detailsKey = 'aquaflow_quote_details';
  static const String _serviceKey = 'aquaflow_quote_service';
  static const String _timeKey = 'aquaflow_quote_time';

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _headingFade = CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.30, curve: Curves.easeOut),
    );

    _headingSlide =
        Tween<Offset>(begin: const Offset(0, 0.12), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: const Interval(0.0, 0.30, curve: Curves.easeOutCubic),
          ),
        );

    _contentFade = CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.20, 1.0, curve: Curves.easeOut),
    );

    _loadSavedData();

    _nameController.addListener(_saveFormData);
    _phoneController.addListener(_saveFormData);
    _locationController.addListener(_saveFormData);
    _quantityController.addListener(_saveFormData);
    _detailsController.addListener(_saveFormData);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _animationController.forward();
      }
    });
  }

  // ============================================================
  // LOAD SAVED DATA
  // ============================================================

  Future<void> _loadSavedData() async {
    final prefs = await SharedPreferences.getInstance();

    if (!mounted) {
      return;
    }

    _nameController.text = prefs.getString(_nameKey) ?? '';
    _phoneController.text = prefs.getString(_phoneKey) ?? '';
    _locationController.text = prefs.getString(_locationKey) ?? '';
    _quantityController.text = prefs.getString(_quantityKey) ?? '';
    _detailsController.text = prefs.getString(_detailsKey) ?? '';

    final savedService = prefs.getString(_serviceKey);
    final savedTime = prefs.getString(_timeKey);

    setState(() {
      if (savedService != null &&
          QuoteSection.services.contains(savedService)) {
        _selectedService = savedService;
      }

      if (savedTime != null && QuoteSection.deliveryTimes.contains(savedTime)) {
        _selectedTime = savedTime;
      }
    });
  }

  // ============================================================
  // SAVE FORM DATA
  // ============================================================

  Future<void> _saveFormData() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(_nameKey, _nameController.text);
    await prefs.setString(_phoneKey, _phoneController.text);
    await prefs.setString(_locationKey, _locationController.text);
    await prefs.setString(_quantityKey, _quantityController.text);
    await prefs.setString(_detailsKey, _detailsController.text);

    if (_selectedService != null) {
      await prefs.setString(_serviceKey, _selectedService!);
    }

    if (_selectedTime != null) {
      await prefs.setString(_timeKey, _selectedTime!);
    }
  }

  // ============================================================
  // SAVE DROPDOWN DATA
  // ============================================================

  void _setService(String? value) {
    setState(() {
      _selectedService = value;
    });

    if (value != null) {
      _saveService(value);
    }
  }

  Future<void> _saveService(String value) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(_serviceKey, value);
  }

  void _setDeliveryTime(String? value) {
    setState(() {
      _selectedTime = value;
    });

    if (value != null) {
      _saveDeliveryTime(value);
    }
  }

  Future<void> _saveDeliveryTime(String value) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(_timeKey, value);
  }

  // ============================================================
  // CLEAR FORM + SAVED DATA
  // ============================================================

  Future<void> _clearQuoteForm() async {
    // Remove listeners temporarily so clearing the controllers
    // does not save the empty values again unnecessarily.
    _nameController.removeListener(_saveFormData);
    _phoneController.removeListener(_saveFormData);
    _locationController.removeListener(_saveFormData);
    _quantityController.removeListener(_saveFormData);
    _detailsController.removeListener(_saveFormData);

    // Clear the visible form fields.
    _nameController.clear();
    _phoneController.clear();
    _locationController.clear();
    _quantityController.clear();
    _detailsController.clear();

    // Clear dropdown selections.
    if (mounted) {
      setState(() {
        _selectedService = null;
        _selectedTime = null;
      });
    }

    // Clear validation/error state.
    _formKey.currentState?.reset();

    // Remove all saved quote information from browser storage.
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove(_nameKey);
    await prefs.remove(_phoneKey);
    await prefs.remove(_locationKey);
    await prefs.remove(_quantityKey);
    await prefs.remove(_detailsKey);
    await prefs.remove(_serviceKey);
    await prefs.remove(_timeKey);

    // Add listeners back for the next quote.
    _nameController.addListener(_saveFormData);
    _phoneController.addListener(_saveFormData);
    _locationController.addListener(_saveFormData);
    _quantityController.addListener(_saveFormData);
    _detailsController.addListener(_saveFormData);
  }

  // ============================================================
  // SUBMIT FORM
  // ============================================================

  Future<void> submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Store all values BEFORE clearing the form.
    final name = _nameController.text.trim();
    final phone = _phoneController.text.trim();
    final location = _locationController.text.trim();
    final quantity = _quantityController.text.trim();
    final service = _selectedService ?? '';
    final deliveryTime = _selectedTime ?? '';
    final details = _detailsController.text.trim();

    final message =
        '''
Hello Sweet Water Tankers,

I would like to request a water delivery quote.

Customer Details
------------------------------
Name: $name
Phone: $phone
Delivery Location: $location

Delivery Details
------------------------------
Service: $service
Quantity: $quantity
Preferred Delivery: $deliveryTime

Additional Details
------------------------------
${details.isEmpty ? 'No additional details provided.' : details}

Please provide the quotation and availability.

Thank you.
''';

    final whatsappUrl = Uri.https('wa.me', '/${QuoteSection.whatsappNumber}', {
      'text': message,
    });

    // ============================================================
    // IMPORTANT:
    // Clear the quote form BEFORE opening WhatsApp.
    //
    // This means when the customer comes back to the website,
    // the form is already empty.
    // ============================================================

    await _clearQuoteForm();

    if (!mounted) {
      return;
    }

    try {
      final launched = await launchUrl(
        whatsappUrl,
        mode: LaunchMode.platformDefault,
      );

      if (!mounted) {
        return;
      }

      if (launched) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            behavior: SnackBarBehavior.floating,
            content: Text('Opening WhatsApp...'),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            behavior: SnackBarBehavior.floating,
            content: Text('Unable to open WhatsApp.'),
          ),
        );
      }
    } catch (_) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text('Unable to open WhatsApp.'),
        ),
      );
    }
  }

  @override
  void dispose() {
    _animationController.dispose();

    _nameController.removeListener(_saveFormData);
    _phoneController.removeListener(_saveFormData);
    _locationController.removeListener(_saveFormData);
    _quantityController.removeListener(_saveFormData);
    _detailsController.removeListener(_saveFormData);

    _nameController.dispose();
    _phoneController.dispose();
    _locationController.dispose();
    _quantityController.dispose();
    _detailsController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: const Color(0xFFF4FAFC),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 70),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1180),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isMobile = constraints.maxWidth < 850;

              final heading = FadeTransition(
                opacity: _headingFade,
                child: SlideTransition(
                  position: _headingSlide,
                  child: const _SectionHeading(),
                ),
              );

              if (isMobile) {
                return Column(
                  children: [
                    heading,
                    const SizedBox(height: 36),
                    FadeTransition(
                      opacity: _contentFade,
                      child: const _InfoPanel(),
                    ),
                    const SizedBox(height: 24),
                    FadeTransition(
                      opacity: _contentFade,
                      child: _QuoteForm(
                        formKey: _formKey,
                        nameController: _nameController,
                        phoneController: _phoneController,
                        locationController: _locationController,
                        quantityController: _quantityController,
                        detailsController: _detailsController,
                        selectedService: _selectedService,
                        selectedTime: _selectedTime,
                        onServiceChanged: _setService,
                        onTimeChanged: _setDeliveryTime,
                        onSubmit: submitForm,
                      ),
                    ),
                  ],
                );
              }

              return Column(
                children: [
                  heading,
                  const SizedBox(height: 48),
                  FadeTransition(
                    opacity: _contentFade,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Expanded(flex: 4, child: _InfoPanel()),
                        const SizedBox(width: 28),
                        Expanded(
                          flex: 6,
                          child: _QuoteForm(
                            formKey: _formKey,
                            nameController: _nameController,
                            phoneController: _phoneController,
                            locationController: _locationController,
                            quantityController: _quantityController,
                            detailsController: _detailsController,
                            selectedService: _selectedService,
                            selectedTime: _selectedTime,
                            onServiceChanged: _setService,
                            onTimeChanged: _setDeliveryTime,
                            onSubmit: submitForm,
                          ),
                        ),
                      ],
                    ),
                  ),
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
// HEADING
// ============================================================

class _SectionHeading extends StatelessWidget {
  const _SectionHeading();

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
              color: QuoteSection.primary.withValues(alpha: 0.09),
              borderRadius: BorderRadius.circular(50),
            ),
            child: const Text(
              'GET A QUOTE',
              style: TextStyle(
                color: QuoteSection.primary,
                fontSize: 12,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.5,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Request Your Water Delivery',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: QuoteSection.dark,
            fontSize: 34,
            fontWeight: FontWeight.w800,
            height: 1.15,
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          'Tell us what you need and we will get back to you with the right water supply solution.',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: QuoteSection.bodyText,
            fontSize: 16,
            height: 1.6,
          ),
        ),
      ],
    );
  }
}

// ============================================================
// INFO PANEL
// ============================================================

class _InfoPanel extends StatefulWidget {
  const _InfoPanel();

  @override
  State<_InfoPanel> createState() => _InfoPanelState();
}

class _InfoPanelState extends State<_InfoPanel>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  bool _isHovered = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
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
    return MouseRegion(
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
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeOutCubic,
        transform: Matrix4.translationValues(0, _isHovered ? -6 : 0, 0),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF08263A), Color(0xFF0A4C65)],
          ),
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: _isHovered ? 0.13 : 0.08),
              blurRadius: _isHovered ? 38 : 30,
              offset: Offset(0, _isHovered ? 20 : 15),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                final pulse =
                    1.0 +
                    (0.06 *
                        Curves.easeInOut.transform(
                          (_controller.value * 2).clamp(0.0, 1.0),
                        ));

                return Transform.scale(
                  scale: _isHovered ? 1.08 : pulse,
                  child: child,
                );
              },
              child: Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.water_drop_rounded,
                  color: Colors.white,
                  size: 30,
                ),
              ),
            ),
            const SizedBox(height: 26),
            const Text(
              'Reliable Water,\nDelivered When You Need It.',
              style: TextStyle(
                color: Colors.white,
                fontSize: 27,
                fontWeight: FontWeight.w800,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 14),
            Text(
              'Request a quote for residential, commercial, construction, swimming pool or bulk water delivery across Dubai.',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.72),
                fontSize: 14,
                height: 1.65,
              ),
            ),
            const SizedBox(height: 28),
            const _InfoFeature(
              icon: Icons.access_time_rounded,
              title: '24/7 Availability',
              description: 'Water delivery whenever you need it.',
              index: 0,
            ),
            const SizedBox(height: 20),
            const _InfoFeature(
              icon: Icons.local_shipping_outlined,
              title: 'Reliable Tanker Service',
              description:
                  'Professional delivery with dependable fleet support.',
              index: 1,
            ),
            const SizedBox(height: 20),
            const _InfoFeature(
              icon: Icons.location_on_outlined,
              title: 'Dubai Wide Coverage',
              description:
                  'Serving homes, businesses and projects across Dubai.',
              index: 2,
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// INFO FEATURE
// ============================================================

class _InfoFeature extends StatefulWidget {
  const _InfoFeature({
    required this.icon,
    required this.title,
    required this.description,
    required this.index,
  });

  final IconData icon;
  final String title;
  final String description;
  final int index;

  @override
  State<_InfoFeature> createState() => _InfoFeatureState();
}

class _InfoFeatureState extends State<_InfoFeature>
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

    Future.delayed(Duration(milliseconds: 250 + (widget.index * 130)), () {
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
    return FadeTransition(
      opacity: CurvedAnimation(parent: _controller, curve: Curves.easeOut),
      child: SlideTransition(
        position: Tween<Offset>(begin: const Offset(0, 0.15), end: Offset.zero)
            .animate(
              CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
            ),
        child: MouseRegion(
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
            duration: const Duration(milliseconds: 220),
            transform: Matrix4.translationValues(_isHovered ? 5 : 0, 0, 0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 220),
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(
                      alpha: _isHovered ? 0.18 : 0.1,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: AnimatedScale(
                    scale: _isHovered ? 1.12 : 1.0,
                    duration: const Duration(milliseconds: 220),
                    curve: Curves.easeOutBack,
                    child: Icon(widget.icon, color: Colors.white, size: 21),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.description,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.62),
                          fontSize: 12,
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
// FORM
// ============================================================

class _QuoteForm extends StatelessWidget {
  const _QuoteForm({
    required this.formKey,
    required this.nameController,
    required this.phoneController,
    required this.locationController,
    required this.quantityController,
    required this.detailsController,
    required this.selectedService,
    required this.selectedTime,
    required this.onServiceChanged,
    required this.onTimeChanged,
    required this.onSubmit,
  });

  final GlobalKey<FormState> formKey;

  final TextEditingController nameController;
  final TextEditingController phoneController;
  final TextEditingController locationController;
  final TextEditingController quantityController;
  final TextEditingController detailsController;

  final String? selectedService;
  final String? selectedTime;

  final ValueChanged<String?> onServiceChanged;
  final ValueChanged<String?> onTimeChanged;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: const Color(0xFFE3EEF2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.045),
            blurRadius: 28,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Delivery Details',
              style: TextStyle(
                color: QuoteSection.dark,
                fontSize: 21,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Fill in the details below and continue through WhatsApp.',
              style: TextStyle(color: QuoteSection.bodyText, fontSize: 13),
            ),
            const SizedBox(height: 26),

            _InputField(
              controller: nameController,
              label: 'Your Name',
              hint: 'Enter your full name',
              icon: Icons.person_outline_rounded,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter your name';
                }

                return null;
              },
            ),

            const SizedBox(height: 17),

            _InputField(
              controller: phoneController,
              label: 'Phone Number',
              hint: 'Enter your phone number',
              icon: Icons.phone_outlined,
              keyboardType: TextInputType.phone,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter your phone number';
                }

                return null;
              },
            ),

            const SizedBox(height: 17),

            _InputField(
              controller: locationController,
              label: 'Delivery Location',
              hint: 'Enter delivery address or area',
              icon: Icons.location_on_outlined,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter the delivery location';
                }

                return null;
              },
            ),

            const SizedBox(height: 17),

            _DropdownField(
              label: 'Service Required',
              value: selectedService,
              hint: 'Select a service',
              icon: Icons.water_drop_outlined,
              items: QuoteSection.services,
              onChanged: onServiceChanged,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select a service';
                }

                return null;
              },
            ),

            const SizedBox(height: 17),

            _InputField(
              controller: quantityController,
              label: 'Quantity',
              hint: 'e.g. 5,000 gallons / 20,000 litres',
              icon: Icons.local_shipping_outlined,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter the required quantity';
                }

                return null;
              },
            ),

            const SizedBox(height: 17),

            _DropdownField(
              label: 'Preferred Delivery',
              value: selectedTime,
              hint: 'Select preferred time',
              icon: Icons.schedule_outlined,
              items: QuoteSection.deliveryTimes,
              onChanged: onTimeChanged,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select a preferred time';
                }

                return null;
              },
            ),

            const SizedBox(height: 17),

            _InputField(
              controller: detailsController,
              label: 'Additional Details',
              hint: 'Tell us anything else we should know...',
              icon: Icons.notes_rounded,
              maxLines: 4,
              requiredField: false,
            ),

            const SizedBox(height: 25),

            _WhatsAppButton(onPressed: onSubmit),

            const SizedBox(height: 13),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.lock_outline_rounded,
                  size: 14,
                  color: Colors.grey.shade500,
                ),
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    'Your information is only used for your enquiry.',
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.grey.shade500, fontSize: 11),
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
// WHATSAPP BUTTON
// ============================================================

class _WhatsAppButton extends StatefulWidget {
  const _WhatsAppButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  State<_WhatsAppButton> createState() => _WhatsAppButtonState();
}

class _WhatsAppButtonState extends State<_WhatsAppButton> {
  bool _isHovered = false;
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final scale = _isPressed
        ? 0.98
        : _isHovered
        ? 1.015
        : 1.0;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
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
      child: GestureDetector(
        onTapDown: (_) {
          setState(() {
            _isPressed = true;
          });
        },
        onTapUp: (_) {
          setState(() {
            _isPressed = false;
          });
        },
        onTapCancel: () {
          setState(() {
            _isPressed = false;
          });
        },
        child: AnimatedScale(
          scale: scale,
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeOut,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            width: double.infinity,
            height: 56,
            decoration: BoxDecoration(
              color: const Color(0xFF25D366),
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF25D366)
                      .withValues(alpha: _isHovered ? 0.25 : 0.0),
                  blurRadius: _isHovered ? 20 : 0,
                  offset: const Offset(0, 7),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: widget.onPressed,
                borderRadius: BorderRadius.circular(15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AnimatedRotation(
                      turns: _isHovered ? 0.03 : 0,
                      duration: const Duration(milliseconds: 220),
                      child: const Icon(
                        Icons.chat_rounded,
                        color: Colors.white,
                        size: 21,
                      ),
                    ),
                    const SizedBox(width: 9),
                    Flexible(
                      child: Text(
                        'Request a Quote on WhatsApp',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
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
    );
  }
}

// ============================================================
// INPUT
// ============================================================

class _InputField extends StatefulWidget {
  const _InputField({
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
    this.keyboardType,
    this.validator,
    this.maxLines = 1,
    this.requiredField = true,
  });

  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final int maxLines;
  final bool requiredField;

  @override
  State<_InputField> createState() => _InputFieldState();
}

class _InputFieldState extends State<_InputField> {
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: const TextStyle(
            color: QuoteSection.dark,
            fontSize: 13,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8),
        Focus(
          onFocusChange: (value) {
            setState(() {
              _focused = value;
            });
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(13),
              boxShadow: _focused
                  ? [
                      BoxShadow(
                        color: QuoteSection.primary.withValues(alpha: 0.10),
                        blurRadius: 12,
                        spreadRadius: 1,
                      ),
                    ]
                  : null,
            ),
            child: TextFormField(
              controller: widget.controller,
              keyboardType: widget.keyboardType,
              maxLines: widget.maxLines,
              validator: widget.requiredField ? widget.validator : null,
              style: const TextStyle(
                color: QuoteSection.dark,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
              decoration: InputDecoration(
                hintText: widget.hint,
                hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13),
                prefixIcon: AnimatedScale(
                  scale: _focused ? 1.08 : 1.0,
                  duration: const Duration(milliseconds: 180),
                  child: Icon(
                    widget.icon,
                    color: QuoteSection.primary,
                    size: 20,
                  ),
                ),
                filled: true,
                fillColor: _focused
                    ? const Color(0xFFF4FAFC)
                    : const Color(0xFFF8FBFC),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 15,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(13),
                  borderSide: const BorderSide(color: Color(0xFFE2EDF1)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(13),
                  borderSide: const BorderSide(color: Color(0xFFE2EDF1)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(13),
                  borderSide: const BorderSide(
                    color: QuoteSection.primary,
                    width: 1.5,
                  ),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(13),
                  borderSide: const BorderSide(color: Colors.redAccent),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(13),
                  borderSide: const BorderSide(
                    color: Colors.redAccent,
                    width: 1.5,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ============================================================
// DROPDOWN
// ============================================================

class _DropdownField extends StatefulWidget {
  const _DropdownField({
    required this.label,
    required this.value,
    required this.hint,
    required this.icon,
    required this.items,
    required this.onChanged,
    required this.validator,
  });

  final String label;
  final String? value;
  final String hint;
  final IconData icon;
  final List<String> items;
  final ValueChanged<String?> onChanged;
  final String? Function(String?) validator;

  @override
  State<_DropdownField> createState() => _DropdownFieldState();
}

class _DropdownFieldState extends State<_DropdownField> {
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: const TextStyle(
            color: QuoteSection.dark,
            fontSize: 13,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8),
        Focus(
          onFocusChange: (value) {
            setState(() {
              _focused = value;
            });
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(13),
              boxShadow: _focused
                  ? [
                      BoxShadow(
                        color: QuoteSection.primary.withValues(alpha: 0.10),
                        blurRadius: 12,
                        spreadRadius: 1,
                      ),
                    ]
                  : null,
            ),
            child: DropdownButtonFormField<String>(
              initialValue: widget.value,
              isExpanded: true,
              icon: const Icon(
                Icons.keyboard_arrow_down_rounded,
                size: 21,
                color: QuoteSection.primary,
              ),
              validator: widget.validator,
              onChanged: widget.onChanged,
              style: const TextStyle(
                color: QuoteSection.dark,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
              decoration: InputDecoration(
                hintText: widget.hint,
                hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13),
                prefixIcon: AnimatedScale(
                  scale: _focused ? 1.08 : 1.0,
                  duration: const Duration(milliseconds: 180),
                  child: Icon(
                    widget.icon,
                    color: QuoteSection.primary,
                    size: 20,
                  ),
                ),
                filled: true,
                fillColor: _focused
                    ? const Color(0xFFF4FAFC)
                    : const Color(0xFFF8FBFC),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 3,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(13),
                  borderSide: const BorderSide(color: Color(0xFFE2EDF1)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(13),
                  borderSide: const BorderSide(color: Color(0xFFE2EDF1)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(13),
                  borderSide: const BorderSide(
                    color: QuoteSection.primary,
                    width: 1.5,
                  ),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(13),
                  borderSide: const BorderSide(color: Colors.redAccent),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(13),
                  borderSide: const BorderSide(
                    color: Colors.redAccent,
                    width: 1.5,
                  ),
                ),
              ),
              items: widget.items
                  .map(
                    (item) => DropdownMenuItem<String>(
                      value: item,
                      child: Text(
                        item,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }
}
