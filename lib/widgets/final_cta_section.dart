import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class FinalCtaSection extends StatelessWidget {
  const FinalCtaSection({super.key});

  static const Color primary = Color(0xFF087EA4);
  static const Color dark = Color(0xFF08263A);
  static const Color bodyText = Color(0xFF52667A);

  // ============================================================
  // CONTACT NUMBER
  // ============================================================

  static const String whatsappNumber = '971551027786';
  static const String phoneNumber = '+971551027786';

  // ============================================================
  // WHATSAPP URL
  // ============================================================

  static Uri get whatsappUrl {
    const message =
        'Hello Sweet Water Tankers, I would like to get information '
        'about your water delivery service.';

    return Uri.https('wa.me', '/$whatsappNumber', {'text': message});
  }

  // ============================================================
  // MAKE PHONE CALL
  // ============================================================

  static Future<void> makeCall() async {
    final Uri phoneUrl = Uri.parse('tel:$phoneNumber');

    try {
      await launchUrl(phoneUrl, mode: LaunchMode.platformDefault);
    } catch (_) {
      // Ignore if the device/browser cannot handle tel:
    }
  }

  // ============================================================
  // OPEN WHATSAPP
  // ============================================================

  static Future<void> openWhatsApp() async {
    try {
      await launchUrl(whatsappUrl, mode: LaunchMode.platformDefault);
    } catch (_) {
      // Ignore if the browser cannot open WhatsApp.
    }
  }

  // ============================================================
  // REQUEST QUOTE
  // ============================================================

  static Future<void> requestQuote() async {
    const message =
        'Hello Sweet Water Tankers,\n\n'
        'I would like to request a free water delivery quote.\n\n'
        'Please provide your available water tanker options, '
        'pricing, and delivery availability.\n\n'
        'Thank you.';

    final Uri quoteUrl = Uri.https('wa.me', '/$whatsappNumber', {
      'text': message,
    });

    try {
      await launchUrl(quoteUrl, mode: LaunchMode.platformDefault);
    } catch (_) {
      // Ignore if the browser cannot open WhatsApp.
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 800;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 24 : 70,
        vertical: isMobile ? 65 : 90,
      ),
      color: Colors.white,
      child: Container(
        width: double.infinity,
        constraints: const BoxConstraints(maxWidth: 1300),
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 28 : 65,
          vertical: isMobile ? 40 : 55,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF08263A), Color(0xFF087EA4)],
          ),
          boxShadow: [
            BoxShadow(
              color: primary.withValues(alpha: 0.20),
              blurRadius: 35,
              offset: const Offset(0, 18),
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              right: -70,
              top: -100,
              child: Container(
                width: 260,
                height: 260,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.06),
                ),
              ),
            ),
            Positioned(
              right: 120,
              bottom: -150,
              child: Container(
                width: 280,
                height: 280,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.05),
                ),
              ),
            ),
            isMobile ? const _MobileContent() : const _DesktopContent(),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// DESKTOP CONTENT
// ============================================================

class _DesktopContent extends StatelessWidget {
  const _DesktopContent();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(child: _TextContent()),
        SizedBox(width: 50),
        SizedBox(width: 320, child: _ActionButtons()),
      ],
    );
  }
}

// ============================================================
// MOBILE CONTENT
// ============================================================

class _MobileContent extends StatelessWidget {
  const _MobileContent();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [_TextContent(), SizedBox(height: 30), _ActionButtons()],
    );
  }
}

// ============================================================
// TEXT CONTENT
// ============================================================

class _TextContent extends StatelessWidget {
  const _TextContent();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 800;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: Colors.white.withValues(alpha: 0.16)),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.access_time_filled_rounded,
                size: 15,
                color: Colors.white,
              ),
              SizedBox(width: 7),
              Text(
                'AVAILABLE 24/7',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.5,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Text(
          'Need Water Delivered?\nWe’re Ready to Help.',
          style: TextStyle(
            fontSize: isMobile ? 31 : 44,
            height: 1.12,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.8,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'From residential deliveries to commercial and bulk '
          'requirements, get dependable water tanker service '
          'across Dubai.',
          style: TextStyle(fontSize: 15, height: 1.7, color: Colors.white70),
        ),
      ],
    );
  }
}

// ============================================================
// ACTION BUTTONS
// ============================================================

class _ActionButtons extends StatelessWidget {
  const _ActionButtons();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // ======================================================
        // CALL NOW
        // ======================================================

        SizedBox(
          width: double.infinity,
          height: 54,
          child: ElevatedButton.icon(
            onPressed: FinalCtaSection.makeCall,
            icon: const Icon(Icons.phone_rounded, size: 19),
            label: const Text(
              'Call Now',
              style: TextStyle(fontWeight: FontWeight.w800),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: FinalCtaSection.dark,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),
        ),

        const SizedBox(height: 12),

        // ======================================================
        // WHATSAPP
        // ======================================================
        SizedBox(
          width: double.infinity,
          height: 54,
          child: OutlinedButton.icon(
            onPressed: FinalCtaSection.openWhatsApp,
            icon: const Icon(Icons.chat_rounded, size: 19),
            label: const Text(
              'WhatsApp Us',
              style: TextStyle(fontWeight: FontWeight.w800),
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.white,
              side: BorderSide(color: Colors.white.withValues(alpha: 0.55)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),
        ),

        const SizedBox(height: 12),

        // ======================================================
        // FREE QUOTE
        // ======================================================
        SizedBox(
          width: double.infinity,
          height: 54,
          child: TextButton(
            onPressed: FinalCtaSection.requestQuote,
            style: TextButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.white.withValues(alpha: 0.10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            child: const Text(
              'Get a Free Quote',
              style: TextStyle(fontWeight: FontWeight.w800),
            ),
          ),
        ),
      ],
    );
  }
}
