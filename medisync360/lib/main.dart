import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medisync360/Data/Repositories/chatbot_repository.dart';
import 'package:medisync360/Data/Repositories/doctor_repository.dart';
import 'package:medisync360/Data/Repositories/patient_repositories.dart';
import 'package:medisync360/UI/Hospital%20Screens/Hospital%20Widgets/Patients/patients_bloc.dart';
import 'package:medisync360/UI/Hospital%20Screens/Hospital%20Widgets/Patients/patients_event.dart';
import 'package:medisync360/UI/Login/login_page.dart';
import 'package:medisync360/UI/User%20Screens/Chatbot/chatbot_bloc.dart';
import 'utils/theme/app_theme.dart';


void main() {
  runApp(
    // Provide repository & bloc globally
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider<ChatbotRepository>(
          create: (_) => ChatbotRepository(),
        ),
        
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<ChatbotBloc>(
            create: (context) =>
                ChatbotBloc(context.read<ChatbotRepository>()),
          ),

          BlocProvider<PatientBloc>(
            create: (context) => PatientBloc(
              PatientRepository(),
              DoctorRepository()
            )..add(LoadPatients()),
          ),

        ],
        child: const MediSyncApp(),
      ),
    ),
  );
}

class MediSyncApp extends StatelessWidget {
  const MediSyncApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MediSync 360',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      // You can change this to any initial screen you want
      home: const EnterpriseSplashScreen(),
    );
  }
}


/// Enterprise-level Splash Screen with Advanced Animations
class EnterpriseSplashScreen extends StatefulWidget {
  const EnterpriseSplashScreen({super.key});

  @override
  State<EnterpriseSplashScreen> createState() => _EnterpriseSplashScreenState();
}

class _EnterpriseSplashScreenState extends State<EnterpriseSplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _masterController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();
    
    // Master animation controller
    _masterController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    );

    // Scale animation for the main icon
    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _masterController,
      curve: const Interval(0.0, 0.6, curve: Curves.elasticOut),
    ));

    // Fade animation for text
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _masterController,
      curve: const Interval(0.4, 0.8, curve: Curves.easeInCubic),
    ));

    // Slide animation for subtitle
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _masterController,
      curve: const Interval(0.6, 1.0, curve: Curves.easeOutBack),
    ));

    // Color animation for background gradient
    _colorAnimation = ColorTween(
      begin: Colors.white,
      end: Colors.blue.shade50,
    ).animate(CurvedAnimation(
      parent: _masterController,
      curve: Curves.easeInOut,
    ));

    // Start the animation sequence
    _startAnimations();
  }

  void _startAnimations() {
    // Start master animation
    _masterController.forward();

    // Navigate after animations complete
    Future.delayed(const Duration(milliseconds: 3200), () {
      _navigateToLogin();
    });
  }

  void _navigateToLogin() {
    if (mounted) {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 1000),
          pageBuilder: (_, __, ___) => const LoginScreen(),
          transitionsBuilder: (_, animation, __, child) {
            return FadeTransition(
              opacity: CurvedAnimation(
                parent: animation,
                curve: Curves.easeInOutQuart,
              ),
              child: child,
            );
          },
        ),
      );
    }
  }

  @override
  void dispose() {
    _masterController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _masterController,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.center,
                radius: 1.5,
                colors: [
                  _colorAnimation.value!,
                  _colorAnimation.value!.withOpacity(0.7),
                ],
              ),
            ),
            child: Stack(
              children: [
                // Animated Particle Background
                _ParticleBackground(animationValue: _masterController.value),
                
                // Main Content
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Animated Icon with multiple effects
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          // Pulsating background circles
                          ...List.generate(3, (index) {
                            return ScaleTransition(
                              scale: Tween<double>(
                                begin: 0.0,
                                end: 1.5,
                              ).animate(CurvedAnimation(
                                parent: _masterController,
                                curve: Interval(
                                  0.3 + (index * 0.1),
                                  1.0,
                                  curve: Curves.easeOut,
                                ),
                              )),
                              child: Container(
                                width: 120 + (index * 40),
                                height: 120 + (index * 40),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.blueAccent.withOpacity(0.3 - (index * 0.1)),
                                    width: 1.5,
                                  ),
                                ),
                              ),
                            );
                          }),
                          
                          // Main icon container with scale and shadow
                          ScaleTransition(
                            scale: _scaleAnimation,
                            child: Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: const LinearGradient(
                                  colors: [Colors.blueAccent, Colors.lightBlueAccent],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.blueAccent.withOpacity(0.4),
                                    blurRadius: 20,
                                    spreadRadius: 5,
                                    offset: const Offset(0, 10),
                                  ),
                                ],
                              ),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  // Rotating medical icon
                                  RotationTransition(
                                    turns: Tween<double>(
                                      begin: -0.1,
                                      end: 0.0,
                                    ).animate(CurvedAnimation(
                                      parent: _masterController,
                                      curve: const Interval(0.0, 0.8, curve: Curves.elasticOut),
                                    )),
                                    child: const Icon(
                                      Icons.medical_services,
                                      size: 45,
                                      color: Colors.white,
                                    ),
                                  ),
                                  
                                  // Custom wave animation
                                  CustomPaint(
                                    painter: _WavePainter(_masterController.value),
                                    size: const Size(100, 100),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 40),
                      
                      // Main title with fade animation
                      FadeTransition(
                        opacity: _fadeAnimation,
                        child: Text(
                          "MediSync 360",
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.w800,
                            foreground: Paint()
                              ..shader = const LinearGradient(
                                colors: [Colors.blueAccent, Colors.lightBlue],
                              ).createShader(const Rect.fromLTWH(0, 0, 200, 70)),
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Subtitle with slide animation
                      SlideTransition(
                        position: _slideAnimation,
                        child: FadeTransition(
                          opacity: _fadeAnimation,
                          child: Text(
                            "Enterprise Healthcare Solutions",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w300,
                              color: Colors.blueGrey.shade600,
                              letterSpacing: 0.8,
                            ),
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 60),
                      
                      // Loading indicator
                      ScaleTransition(
                        scale: Tween<double>(
                          begin: 0.0,
                          end: 1.0,
                        ).animate(CurvedAnimation(
                          parent: _masterController,
                          curve: const Interval(0.7, 1.0, curve: Curves.elasticOut),
                        )),
                        child: SizedBox(
                          width: 40,
                          height: 40,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.blueAccent.withOpacity(0.7),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Version info at bottom
                Positioned(
                  bottom: 30,
                  left: 0,
                  right: 0,
                  child: FadeTransition(
                    opacity: Tween<double>(
                      begin: 0.0,
                      end: 1.0,
                    ).animate(CurvedAnimation(
                      parent: _masterController,
                      curve: const Interval(0.8, 1.0),
                    )),
                    child: Text(
                      "v1.0.0 • Enterprise Edition",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.blueGrey.shade400,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

/// Simplified Particle Background using main animation controller
class _ParticleBackground extends StatelessWidget {
  final double animationValue;

  const _ParticleBackground({required this.animationValue});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _ParticlePainter(animationValue),
      size: Size.infinite,
    );
  }
}

class _ParticlePainter extends CustomPainter {
  final double animationValue;

  _ParticlePainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final random = math.Random(42); // Fixed seed for consistent particles
    
    // Draw particles based on animation value
    for (int i = 0; i < 15; i++) {
      final progress = (animationValue + i * 0.05) % 1.0;
      final x = 0.3 + random.nextDouble() * 0.4;
      final y = 0.3 + random.nextDouble() * 0.4;
      final particleSize = 1.0 + random.nextDouble() * 3.0;
      final opacity = (0.3 * (1.0 - progress)).clamp(0.0, 0.3);
      
      final paint = Paint()
        ..color = Colors.blue.withOpacity(opacity)
        ..style = PaintingStyle.fill
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2);
      
      canvas.drawCircle(
        Offset(x * size.width, y * size.height),
        particleSize,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _ParticlePainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}

/// Custom Wave Painter for sophisticated animation
class _WavePainter extends CustomPainter {
  final double animationValue;

  _WavePainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = size.width / 2;
    
    // Draw multiple concentric waves
    for (int i = 0; i < 3; i++) {
      final waveProgress = (animationValue + i * 0.2) % 1.0;
      final radius = maxRadius * (0.5 + waveProgress * 0.5);
      final opacity = (1.0 - waveProgress).clamp(0.0, 0.6);
      
      final paint = Paint()
        ..color = Colors.white.withOpacity(opacity)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2);
      
      if (radius > 0 && radius < maxRadius * 1.5) {
        canvas.drawCircle(center, radius, paint);
      }
    }
    
    // Draw rotating arcs
    final sweepAngle = math.pi * 1.5;
    final startAngle = -math.pi / 2 + animationValue * math.pi * 2;
    
    final arcPaint = Paint()
      ..color = Colors.white.withOpacity(0.8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round;
    
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: maxRadius - 10),
      startAngle,
      sweepAngle,
      false,
      arcPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _WavePainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}