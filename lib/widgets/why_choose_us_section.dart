import 'package:flutter/material.dart';

class WhyChooseUsSection extends StatelessWidget {
  const WhyChooseUsSection({super.key});

  static const Color primary = Color(0xFF087EA4);
  static const Color darkText = Color(0xFF102A43);
  static const Color bodyText = Color(0xFF52667A);
  static const Color lightBg = Color(0xFFF6FBFD);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 800;

    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 24 : 70,
        vertical: isMobile ? 70 : 105,
      ),
      child: Column(
        children: [
          _SectionHeading(isMobile: isMobile),

          const SizedBox(height: 55),

          isMobile
              ? const Column(
                  children: [_MainVisual(), SizedBox(height: 45), _Benefits()],
                )
              : const Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(flex: 5, child: _MainVisual()),
                    SizedBox(width: 65),
                    Expanded(flex: 5, child: _Benefits()),
                  ],
                ),
        ],
      ),
    );
  }
}

class _SectionHeading extends StatelessWidget {
  final bool isMobile;

  const _SectionHeading({required this.isMobile});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0xFFEAF8FB),
            borderRadius: BorderRadius.circular(30),
          ),
          child: const Text(
            'WHY CHOOSE US',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.8,
              color: WhyChooseUsSection.primary,
            ),
          ),
        ),

        const SizedBox(height: 18),

        Text(
          'Reliable Water. Professional Service.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: isMobile ? 31 : 44,
            height: 1.15,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.8,
            color: WhyChooseUsSection.darkText,
          ),
        ),

        const SizedBox(height: 15),

        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 670),
          child: const Text(
            'We make water delivery simple, dependable and stress-free '
            'with fast response times and professional service across Dubai.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              height: 1.7,
              color: WhyChooseUsSection.bodyText,
            ),
          ),
        ),
      ],
    );
  }
}

class _MainVisual extends StatelessWidget {
  const _MainVisual();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFE8F9FC), Color(0xFFD4F1F6)],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -80,
            right: -70,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.65),
              ),
            ),
          ),

          Positioned(
            bottom: -100,
            left: -80,
            child: Container(
              width: 270,
              height: 270,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: WhyChooseUsSection.primary.withValues(alpha: 0.08),
              ),
            ),
          ),

          Center(
            child: Container(
              width: 235,
              height: 235,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.85),
                boxShadow: [
                  BoxShadow(
                    color: WhyChooseUsSection.primary.withValues(alpha: 0.12),
                    blurRadius: 35,
                    offset: const Offset(0, 15),
                  ),
                ],
              ),
              child: const Icon(
                Icons.local_shipping_rounded,
                size: 115,
                color: WhyChooseUsSection.primary,
              ),
            ),
          ),

          Positioned(
            top: 28,
            left: 28,
            child: _FloatingBadge(
              icon: Icons.verified_rounded,
              text: 'Trusted Service',
            ),
          ),

          Positioned(
            bottom: 28,
            right: 28,
            child: _FloatingBadge(
              icon: Icons.location_on_rounded,
              text: 'Dubai Wide',
            ),
          ),

          Positioned(
            bottom: 28,
            left: 28,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 18,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.access_time_filled_rounded,
                    size: 17,
                    color: Color(0xFF16A085),
                  ),
                  SizedBox(width: 7),
                  Text(
                    'Available 24/7',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: WhyChooseUsSection.darkText,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FloatingBadge extends StatelessWidget {
  final IconData icon;
  final String text;

  const _FloatingBadge({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 17, color: WhyChooseUsSection.primary),
          const SizedBox(width: 7),
          Text(
            text,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              color: WhyChooseUsSection.darkText,
            ),
          ),
        ],
      ),
    );
  }
}

class _Benefits extends StatelessWidget {
  const _Benefits();

  @override
  Widget build(BuildContext context) {
    final benefits = [
      _BenefitData(
        icon: Icons.schedule_rounded,
        title: '24/7 Availability',
        description: 'Water delivery when you need it, including urgent and after-hours requirements.',
      ),
      _BenefitData(
        icon: Icons.speed_rounded,
        title: 'Fast Response',
        description: 'Quick dispatch and dependable delivery to help keep your property or project running.',
      ),
      _BenefitData(
        icon: Icons.verified_user_rounded,
        title: 'Quality & Reliability',
        description: 'Professional water tanker service focused on consistent quality and dependable supply.',
      ),
      _BenefitData(
        icon: Icons.local_shipping_rounded,
        title: 'Modern Fleet',
        description: 'A capable tanker fleet designed to handle residential, commercial and bulk requirements.',
      ),
      _BenefitData(
        icon: Icons.location_on_rounded,
        title: 'Dubai Wide Coverage',
        description: 'Serving customers across Dubai with flexible delivery options for different locations.',
      ),
      _BenefitData(
        icon: Icons.support_agent_rounded,
        title: 'Professional Support',
        description: 'Clear communication and helpful support from enquiry through successful delivery.',
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Everything You Need From a Water Delivery Partner',
          style: TextStyle(
            fontSize: 28,
            height: 1.2,
            fontWeight: FontWeight.w800,
            color: WhyChooseUsSection.darkText,
          ),
        ),

        const SizedBox(height: 14),

        const Text(
          'Whether you need one tanker or regular bulk supply, '
          'our service is built around speed, reliability and convenience.',
          style: TextStyle(
            fontSize: 15,
            height: 1.7,
            color: WhyChooseUsSection.bodyText,
          ),
        ),

        const SizedBox(height: 30),

        ...benefits.map(
          (benefit) => Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: _BenefitItem(benefit: benefit),
          ),
        ),
      ],
    );
  }
}

class _BenefitItem extends StatelessWidget {
  final _BenefitData benefit;

  const _BenefitItem({required this.benefit});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: const Color(0xFFEAF8FB),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(
            benefit.icon,
            color: WhyChooseUsSection.primary,
            size: 22,
          ),
        ),

        const SizedBox(width: 15),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                benefit.title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: WhyChooseUsSection.darkText,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                benefit.description,
                style: const TextStyle(
                  fontSize: 13.5,
                  height: 1.55,
                  color: WhyChooseUsSection.bodyText,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _BenefitData {
  final IconData icon;
  final String title;
  final String description;

  const _BenefitData({
    required this.icon,
    required this.title,
    required this.description,
  });
}
