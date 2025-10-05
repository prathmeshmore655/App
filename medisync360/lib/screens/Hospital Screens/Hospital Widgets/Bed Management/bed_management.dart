import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medisync360/screens/Hospital%20Screens/Hospital%20Widgets/Bed%20Management/bed_management_bloc.dart';
import 'package:medisync360/screens/Hospital%20Screens/Hospital%20Widgets/Bed%20Management/bed_management_event.dart';
import 'package:medisync360/screens/Hospital%20Screens/Hospital%20Widgets/Bed%20Management/bed_management_state.dart';

class BedComponent extends StatelessWidget {
  const BedComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => BedManagementBloc()..add(LoadBeds()),
      child: BlocBuilder<BedManagementBloc, BedManagementState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state.beds.isEmpty) {
            return const _EmptyStateWidget();
          }

          return const _BedGrid();
        },
      ),
    );
  }
}

class _EmptyStateWidget extends StatelessWidget {
  const _EmptyStateWidget();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.king_bed_rounded,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 20),
          Text(
            'No Beds Available',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add beds to get started',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }
}

class _BedGrid extends StatelessWidget {
  const _BedGrid();

  @override
  Widget build(BuildContext context) {
    final beds = context.select((BedManagementBloc bloc) => bloc.state.beds);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final screenWidth = constraints.maxWidth;
          
          return GridView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: beds.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: _getCrossAxisCount(screenWidth),
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: _getChildAspectRatio(screenWidth),
            ),
            itemBuilder: (context, index) {
              return _ResponsiveBedCard(bed: beds[index]);
            },
          );
        },
      ),
    );
  }

  int _getCrossAxisCount(double screenWidth) {
    if (screenWidth > 1400) return 6;
    if (screenWidth > 1200) return 5;
    if (screenWidth > 900) return 4;
    if (screenWidth > 600) return 3;
    if (screenWidth > 400) return 2;
    return 1;
  }

  double _getChildAspectRatio(double screenWidth) {
    if (screenWidth > 900) return 0.9;
    if (screenWidth > 600) return 1.0;
    return 1.1;
  }
}

class _ResponsiveBedCard extends StatelessWidget {
  final dynamic bed;

  const _ResponsiveBedCard({required this.bed});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final cardWidth = constraints.maxWidth;
        final cardHeight = constraints.maxHeight;
        final isSmallCard = cardWidth < 150;

        return _BedCardContent(
          bed: bed,
          cardWidth: cardWidth,
          cardHeight: cardHeight,
          isSmallCard: isSmallCard,
        );
      },
    );
  }
}

class _BedCardContent extends StatelessWidget {
  final dynamic bed;
  final double cardWidth;
  final double cardHeight;
  final bool isSmallCard;

  const _BedCardContent({
    required this.bed,
    required this.cardWidth,
    required this.cardHeight,
    required this.isSmallCard,
  });

  @override
  Widget build(BuildContext context) {
    final statusConfig = _getStatusConfig(bed.status);
    
    return GestureDetector(
      onTap: () => _handleBedTap(context),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(
            color: statusConfig.color.withOpacity(0.3),
            width: 2,
          ),
        ),
        child: Stack(
          children: [
            // Background pattern
            _BedBackgroundPattern(color: statusConfig.color.withOpacity(0.05)),
            
            // Main content
            Padding(
              padding: isSmallCard 
                  ? const EdgeInsets.all(12.0)
                  : const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header with icon and status
                  _BedHeader(
                    bed: bed,
                    statusConfig: statusConfig,
                    isSmallCard: isSmallCard,
                  ),
                  
                  SizedBox(height: isSmallCard ? 8 : 12),
                  
                  // Bed information
                  _BedInfo(
                    bed: bed,
                    isSmallCard: isSmallCard,
                  ),
                  
                  const Spacer(),
                  
                  // Status indicator and next action
                  _BedFooter(
                    statusConfig: statusConfig,
                    nextStatus: _getNextStatus(bed.status),
                    isSmallCard: isSmallCard,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleBedTap(BuildContext context) {
    final nextStatus = _getNextStatus(bed.status);
    context.read<BedManagementBloc>().add(UpdateBedStatus(bed.id, nextStatus));
    
    // Show quick feedback
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Bed ${bed.id} set to $nextStatus'),
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  String _getNextStatus(String currentStatus) {
    switch (currentStatus) {
      case "Available": return "Occupied";
      case "Occupied": return "Cleaning";
      case "Cleaning": return "Available";
      default: return "Available";
    }
  }

  _StatusConfig _getStatusConfig(String status) {
    switch (status) {
      case "Available":
        return _StatusConfig(
          color: const Color(0xFF10B981),
          icon: Icons.check_circle_rounded,
          gradient: const LinearGradient(
            colors: [Color(0xFF10B981), Color(0xFF34D399)],
          ),
        );
      case "Occupied":
        return _StatusConfig(
          color: const Color(0xFFEF4444),
          icon: Icons.person_rounded,
          gradient: const LinearGradient(
            colors: [Color(0xFFEF4444), Color(0xFFF87171)],
          ),
        );
      case "Cleaning":
        return _StatusConfig(
          color: const Color(0xFFF59E0B),
          icon: Icons.cleaning_services_rounded,
          gradient: const LinearGradient(
            colors: [Color(0xFFF59E0B), Color(0xFFFBBF24)],
          ),
        );
      default:
        return _StatusConfig(
          color: const Color(0xFF6B7280),
          icon: Icons.help_rounded,
          gradient: const LinearGradient(
            colors: [Color(0xFF6B7280), Color(0xFF9CA3AF)],
          ),
        );
    }
  }
}

class _StatusConfig {
  final Color color;
  final IconData icon;
  final Gradient gradient;

  const _StatusConfig({
    required this.color,
    required this.icon,
    required this.gradient,
  });
}

class _BedBackgroundPattern extends StatelessWidget {
  final Color color;

  const _BedBackgroundPattern({required this.color});

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: 0.3,
      child: CustomPaint(
        size: Size.infinite,
        painter: _BedPatternPainter(color: color),
      ),
    );
  }
}

class _BedPatternPainter extends CustomPainter {
  final Color color;

  _BedPatternPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    const step = 20.0;
    for (double x = 0; x < size.width; x += step) {
      for (double y = 0; y < size.height; y += step) {
        canvas.drawCircle(Offset(x, y), 1, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _BedHeader extends StatelessWidget {
  final dynamic bed;
  final _StatusConfig statusConfig;
  final bool isSmallCard;

  const _BedHeader({
    required this.bed,
    required this.statusConfig,
    required this.isSmallCard,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Status icon with gradient background
        Container(
          width: isSmallCard ? 32 : 40,
          height: isSmallCard ? 32 : 40,
          decoration: BoxDecoration(
            gradient: statusConfig.gradient,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: statusConfig.color.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Icon(
            statusConfig.icon,
            color: Colors.white,
            size: isSmallCard ? 18 : 22,
          ),
        ),
        
        const Spacer(),
        
        // Status badge
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: isSmallCard ? 6 : 8,
            vertical: isSmallCard ? 2 : 4,
          ),
          decoration: BoxDecoration(
            color: statusConfig.color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: statusConfig.color.withOpacity(0.3)),
          ),
          child: Text(
            bed.status,
            style: TextStyle(
              color: statusConfig.color,
              fontSize: isSmallCard ? 10 : 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

class _BedInfo extends StatelessWidget {
  final dynamic bed;
  final bool isSmallCard;

  const _BedInfo({
    required this.bed,
    required this.isSmallCard,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Bed ID
        Text(
          "Bed ${bed.id}",
          style: TextStyle(
            fontSize: isSmallCard ? 14 : 18,
            fontWeight: FontWeight.w700,
            color: Colors.grey[800],
          ),
        ),
        
        SizedBox(height: isSmallCard ? 2 : 4),
        
        // Ward
        Text(
          bed.ward,
          style: TextStyle(
            fontSize: isSmallCard ? 11 : 13,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
        
        // Patient name if exists
        if (bed.patientName != null && bed.patientName!.isNotEmpty) ...[
          SizedBox(height: isSmallCard ? 4 : 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              bed.patientName!,
              style: TextStyle(
                fontSize: isSmallCard ? 10 : 12,
                color: Colors.blue[800],
                fontWeight: FontWeight.w500,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ],
    );
  }
}

class _BedFooter extends StatelessWidget {
  final _StatusConfig statusConfig;
  final String nextStatus;
  final bool isSmallCard;

  const _BedFooter({
    required this.statusConfig,
    required this.nextStatus,
    required this.isSmallCard,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Next status indicator
        Row(
          children: [
            Icon(
              Icons.touch_app_rounded,
              size: isSmallCard ? 12 : 14,
              color: Colors.grey[500],
            ),
            SizedBox(width: isSmallCard ? 4 : 6),
            Expanded(
              child: Text(
                'Next: $nextStatus',
                style: TextStyle(
                  fontSize: isSmallCard ? 10 : 12,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        
        SizedBox(height: isSmallCard ? 6 : 8),
        
        // Progress indicator showing status cycle
        Container(
          height: isSmallCard ? 3 : 4,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(2),
          ),
          child: Row(
            children: [
              Expanded(
                flex: _getProgressFlex("Available", nextStatus),
                child: Container(
                  decoration: BoxDecoration(
                    color: nextStatus == "Available" 
                        ? const Color(0xFF10B981)
                        : Colors.grey[300],
                    borderRadius: const BorderRadius.horizontal(
                      left: Radius.circular(2),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: _getProgressFlex("Occupied", nextStatus),
                child: Container(
                  color: nextStatus == "Occupied" 
                      ? const Color(0xFFEF4444)
                      : Colors.grey[300],
                ),
              ),
              Expanded(
                flex: _getProgressFlex("Cleaning", nextStatus),
                child: Container(
                  decoration: BoxDecoration(
                    color: nextStatus == "Cleaning" 
                        ? const Color(0xFFF59E0B)
                        : Colors.grey[300],
                    borderRadius: const BorderRadius.horizontal(
                      right: Radius.circular(2),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  int _getProgressFlex(String status, String nextStatus) {
    return status == nextStatus ? 3 : 1;
  }
}