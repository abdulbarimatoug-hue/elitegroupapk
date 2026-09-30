import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/providers/repository_providers.dart';
import 'package:core_domain/entities/travel_package_entity.dart';
import '../../bookings/presentation/booking_modal.dart';

class PackageDetailScreen extends ConsumerStatefulWidget {
  final TravelPackageEntity package;

  const PackageDetailScreen({super.key, required this.package});

  @override
  ConsumerState<PackageDetailScreen> createState() => _PackageDetailScreenState();
}

class _PackageDetailScreenState extends ConsumerState<PackageDetailScreen> {
  int _activeImageIndex = 0;
  bool _isFavorite = false;

  @override
  Widget build(BuildContext context) {
    final pkg = widget.package;

    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      body: CustomScrollView(
        slivers: [
          // Collapsible Luxury App Bar with Image Carousel
          SliverAppBar(
            expandedHeight: 260,
            pinned: true,
            backgroundColor: AppColors.primaryNavy,
            leading: IconButton(
              icon: const CircleAvatar(
                backgroundColor: Colors.black40,
                child: Icon(Icons.arrow_back, color: Colors.white, size: 20),
              ),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              IconButton(
                icon: CircleAvatar(
                  backgroundColor: Colors.black40,
                  child: Icon(
                    _isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: _isFavorite ? Colors.red : Colors.white,
                    size: 20,
                  ),
                ),
                onPressed: () {
                  setState(() => _isFavorite = !_isFavorite);
                },
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    pkg.imageUrls.isNotEmpty
                        ? pkg.imageUrls[_activeImageIndex]
                        : pkg.coverImage,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: AppColors.primaryNavy,
                      child: const Icon(Icons.image, color: Colors.white, size: 50),
                    ),
                  ),
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.transparent, Colors.black87],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 16,
                    right: 16,
                    left: 16,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.accentGold,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            pkg.destination,
                            style: const TextStyle(
                              color: AppColors.primaryNavyDark,
                              fontWeight: FontWeight.bold,
                              fontSize: 11,
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          pkg.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Details Body
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Overview Bar (Days, Nights, Category, Rating)
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.lightDividers),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildDetailItem(Icons.calendar_today, '${pkg.durationDays} أيام', 'المدة'),
                        _buildDetailItem(Icons.nightlight_round, '${pkg.durationNights} ليالٍ', 'الإقامة'),
                        _buildDetailItem(Icons.category, pkg.category, 'التصنيف'),
                        _buildDetailItem(Icons.star, '4.9', 'التقييم'),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Package Description
                  const Text(
                    'نبذة عن الرحلة',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryNavy,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    pkg.overview,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.lightTextSecondary,
                      height: 1.6,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Day by Day Itinerary (Expandable)
                  const Text(
                    'برنامج الرحلة يوماً بيوم',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryNavy,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...pkg.itinerary.map((day) => Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: AppColors.lightDividers),
                        ),
                        child: ExpansionTile(
                          shape: const Border(),
                          leading: CircleAvatar(
                            backgroundColor: AppColors.primaryNavy,
                            child: Text(
                              '${day.dayNumber}',
                              style: const TextStyle(
                                color: AppColors.accentGold,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ),
                          title: Text(
                            day.title,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: AppColors.primaryNavy,
                            ),
                          ),
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    day.description,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: AppColors.lightTextSecondary,
                                    ),
                                  ),
                                  if (day.activities.isNotEmpty) ...[
                                    const SizedBox(height: 8),
                                    Wrap(
                                      spacing: 6,
                                      children: day.activities
                                          .map((a) => Chip(
                                                label: Text(a, style: const TextStyle(fontSize: 11)),
                                                backgroundColor: AppColors.lightBackground,
                                                side: BorderSide.none,
                                              ))
                                          .toList(),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ],
                        ),
                      )),

                  const SizedBox(height: 24),

                  // Includes & Excludes
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Includes (Checkmark)
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: const Color(0xFF10B981).withOpacity(0.3)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Row(
                                children: [
                                  Icon(Icons.check_circle, color: Color(0xFF10B981), size: 18),
                                  SizedBox(width: 6),
                                  Text(
                                    'ما يشمله السعر',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                      color: Color(0xFF047857),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              ...pkg.includedServices.map((inc) => Padding(
                                    padding: const EdgeInsets.only(bottom: 6),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text('• ', style: TextStyle(color: Color(0xFF10B981))),
                                        Expanded(
                                          child: Text(inc, style: const TextStyle(fontSize: 11)),
                                        ),
                                      ],
                                    ),
                                  )),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      // Excludes (Crossmark)
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: const Color(0xFFEF4444).withOpacity(0.3)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Row(
                                children: [
                                  Icon(Icons.cancel, color: Color(0xFFEF4444), size: 18),
                                  SizedBox(width: 6),
                                  Text(
                                    'ما لا يشمله السعر',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                      color: Color(0xFFB91C1C),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              ...pkg.excludedServices.map((exc) => Padding(
                                    padding: const EdgeInsets.only(bottom: 6),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text('• ', style: TextStyle(color: Color(0xFFEF4444))),
                                        Expanded(
                                          child: Text(exc, style: const TextStyle(fontSize: 11)),
                                        ),
                                      ],
                                    ),
                                  )),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 90), // Spacing for sticky bottom bar
                ],
              ),
            ),
          ),
        ],
      ),

      // Sticky Bottom Booking Bar (Without Electronic Payment)
      bottomSheet: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          border: const Border(top: BorderSide(color: AppColors.lightDividers)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 10,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('السعر للشخص', style: TextStyle(fontSize: 11, color: AppColors.lightTextSecondary)),
                  Text(
                    '\$${pkg.price.toInt()}',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      color: AppColors.primaryNavy,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 20),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accentGold,
                    foregroundColor: AppColors.primaryNavyDark,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 0,
                  ),
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (ctx) => BookingModal(package: pkg),
                    );
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.send_rounded, size: 18),
                      SizedBox(width: 8),
                      Text(
                        'اطلب هذه الباقة',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailItem(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: AppColors.accentGold, size: 20),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.primaryNavy)),
        Text(label, style: const TextStyle(fontSize: 10, color: AppColors.lightTextSecondary)),
      ],
    );
  }
}
