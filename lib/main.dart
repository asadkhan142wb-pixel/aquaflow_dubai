import 'package:flutter/gestures.dart' show PointerDeviceKind;
import 'package:flutter/material.dart';

import 'widgets/navbar.dart';
import 'widgets/hero_section.dart';
import 'widgets/services_section.dart';
import 'widgets/how_it_works_section.dart';
import 'widgets/fleet_section.dart';
import 'widgets/service_areas_section.dart';
import 'widgets/gallery_section.dart';
import 'widgets/testimonials_section.dart';
import 'widgets/quote_section.dart';
import 'widgets/faq_section.dart';
import 'widgets/final_cta_section.dart';
import 'widgets/footer_section.dart';
import 'widgets/about_section.dart';

void main() {
  runApp(const SweetWaterTankersApp());
}

class SweetWaterTankersApp extends StatelessWidget {
  const SweetWaterTankersApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sweet Water Tankers',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'Arial',
        splashFactory: NoSplash.splashFactory,
        highlightColor: Colors.transparent,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();

  final GlobalKey areasKey = GlobalKey();
  final GlobalKey quoteKey = GlobalKey();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // ============================================================
  // SCROLL TO TOP
  // ============================================================

  void scrollToTop() {
    if (!_scrollController.hasClients) return;

    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 700),
      curve: Curves.easeInOutCubic,
    );
  }

  // ============================================================
  // SCROLL TO SECTION
  // ============================================================

  void scrollToSection(GlobalKey key) {
    final targetContext = key.currentContext;

    if (targetContext == null) return;

    Scrollable.ensureVisible(
      targetContext,
      duration: const Duration(milliseconds: 700),
      curve: Curves.easeInOutCubic,
      alignment: 0.05,
    );
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ScrollConfiguration(
        behavior: const SweetWaterTankersScrollBehavior(),
        child: SingleChildScrollView(
          controller: _scrollController,
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ==================================================
              // NAVBAR
              // ==================================================

              Navbar(onAreas: () => scrollToSection(areasKey)),

              // ==================================================
              // HERO
              // ==================================================
              HeroSection(onGetWaterNow: () => scrollToSection(quoteKey)),

              // ==================================================
              // SERVICES
              // ==================================================
              const ServicesSection(),

              // ==================================================
              // ABOUT
              // ==================================================
              const AboutSection(),

              // ==================================================
              // HOW IT WORKS
              // ==================================================
              const HowItWorksSection(),

              // ==================================================
              // FLEET
              // ==================================================
              const FleetSection(),

              // ==================================================
              // SERVICE AREAS
              // ==================================================
              Container(key: areasKey, child: const ServiceAreasSection()),

              // ==================================================
              // GALLERY
              // ==================================================
              const GallerySection(),

              // ==================================================
              // TESTIMONIALS
              // ==================================================
              const TestimonialsSection(),

              // ==================================================
              // QUOTE
              // ==================================================
              Container(key: quoteKey, child: const QuoteSection()),

              // ==================================================
              // FAQ
              // ==================================================
              const FaqSection(),

              // ==================================================
              // FINAL CTA
              // ==================================================
              const FinalCtaSection(),

              // ==================================================
              // FOOTER
              // ==================================================
              FooterSection(onHome: scrollToTop),

              // ==================================================
              // EXTRA BOTTOM SPACE
              // ==================================================
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}

// ================================================================
// CUSTOM SCROLL BEHAVIOR
// ================================================================

class SweetWaterTankersScrollBehavior extends MaterialScrollBehavior {
  const SweetWaterTankersScrollBehavior();

  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
    PointerDeviceKind.trackpad,
    PointerDeviceKind.stylus,
  };
}
