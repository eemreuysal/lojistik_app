import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/theme.dart';
import '../../providers/auth_provider.dart';
import '../../providers/trips_provider.dart';
import '../../models/trip_model.dart';
import '../../models/user_model.dart';
import 'admin_create_trip_screen.dart';
import 'profile_edit_screen.dart';
import '../../widgets/profile_image_widget.dart';

class AdminTruckScreen extends StatefulWidget {
  const AdminTruckScreen({super.key});

  @override
  State<AdminTruckScreen> createState() => _AdminTruckScreenState();
}

class _AdminTruckScreenState extends State<AdminTruckScreen> {
  String _selectedFilter = 'all'; // 'all', 'active', 'completed'
  final String _selectedTimeFilter = 'Bu Hafta';
  bool _isLoading = false;
  List<Trip> _filteredTrips = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadTrips();

    // Arama alanı değişiklikleri dinleme
    _searchController.addListener(_filterTrips);
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterTrips);
    _searchController.dispose();
    super.dispose();
  }

  // Seferleri yükleme
  Future<void> _loadTrips() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await Provider.of<TripsProvider>(context, listen: false).loadTrips();
      _filterTrips();
    } catch (e) {
      // Hata durumunda snackbar gösterilmesi
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Seferler yüklenirken hata oluştu: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // Seferleri filtreleme
  void _filterTrips() {
    final tripsProvider = Provider.of<TripsProvider>(context, listen: false);
    final allTrips = tripsProvider.trips;

    setState(() {
      // Önce durum filtrelemesi
      if (_selectedFilter == 'all') {
        _filteredTrips = List.from(allTrips);
      } else if (_selectedFilter == 'active') {
        _filteredTrips = allTrips.where((trip) => trip.isActive).toList();
      } else if (_selectedFilter == 'completed') {
        _filteredTrips = allTrips.where((trip) => !trip.isActive).toList();
      }

      // Sonra arama filtresi uygulama
      if (_searchController.text.isNotEmpty) {
        final searchTerm = _searchController.text.toLowerCase();
        _filteredTrips = _filteredTrips.where((trip) {
          return trip.tripNumber.toLowerCase().contains(searchTerm) ||
              (trip.vehiclePlate?.toLowerCase().contains(searchTerm) ??
                  false) ||
              (trip.driverName?.toLowerCase().contains(searchTerm) ?? false);
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final tripsProvider = Provider.of<TripsProvider>(context);
    final currentUser = authProvider.currentUser;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.white,
        child: Stack(
          children: [
            // Gradient background
            Positioned(
              left: 0,
              top: 0,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 534,
                decoration: const BoxDecoration(
                  gradient: AppTheme.primaryGradient,
                ),
              ),
            ),

            // Main content area (Light gray background)
            Positioned(
              left: 0,
              top: 204,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height - 204,
                decoration: ShapeDecoration(
                  color: AppTheme.backgroundGrey,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
            ),

            // Content
            SafeArea(
              child: Column(
                children: [
                  // App Bar
                  _buildAppBar(currentUser),

                  // Filter tabs
                  _buildFilterTabs(),

                  // Trips list
                  Expanded(
                    child: Container(
                      decoration: const BoxDecoration(
                        color: AppTheme.backgroundGrey,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(5),
                          topRight: Radius.circular(5),
                        ),
                      ),
                      child: Column(
                        children: [
                          // Search and date filter
                          _buildSearchAndFilter(),

                          // Trip count and date range info
                          _buildInfoRow(tripsProvider),

                          // Trips list
                          _isLoading
                              ? const Center(child: CircularProgressIndicator())
                              : _buildTripsList(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Bottom Navigation Bar
            Positioned(
              left: 15,
              bottom: 18,
              child: _buildBottomNavBar(),
            ),
          ],
        ),
      ),
    );
  }

  // App Bar Widget
  Widget _buildAppBar(User? currentUser) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Profile
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ProfileEditScreen(),
                    ),
                  );
                },
                child: ProfileImageWidget(
                  imageUrl: currentUser?.profileImageUrl,
                  initials: currentUser?.initials,
                  companyName: currentUser?.companyName,
                  radius: 18.5,
                ),
              ),
              const SizedBox(width: 13),
              Text(
                (currentUser?.companyName ?? 'Şirket Adı').length > 20
                    ? (currentUser?.companyName ?? 'Şirket Adı')
                        .substring(0, 20)
                    : currentUser?.companyName ?? 'Şirket Adı',
                style: const TextStyle(
                  color: Color(0xFFDEDFE1),
                  fontSize: 20,
                  fontFamily: 'Manrope',
                  fontWeight: FontWeight.w600,
                  height: 0,
                  letterSpacing: 0.60,
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // "Seferler" Title
          Text(
            'Seferler',
            style: AppTheme.manropeBold(22, Colors.white),
          ),
        ],
      ),
    );
  }

  // Filter Tabs Widget
  Widget _buildFilterTabs() {
    return Padding(
      padding: const EdgeInsets.only(left: 16, top: 16),
      child: SizedBox(
        height: 40,
        child: Row(
          children: [
            // Tümü
            _buildFilterTab(
              'Tümü',
              _selectedFilter == 'all',
              () => setState(() {
                _selectedFilter = 'all';
                _filterTrips();
              }),
            ),
            const SizedBox(width: 16),

            // Devam Eden
            _buildFilterTab(
              'Devam Eden',
              _selectedFilter == 'active',
              () => setState(() {
                _selectedFilter = 'active';
                _filterTrips();
              }),
            ),
            const SizedBox(width: 16),

            // Tamamlanan
            _buildFilterTab(
              'Tamamlanan',
              _selectedFilter == 'completed',
              () => setState(() {
                _selectedFilter = 'completed';
                _filterTrips();
              }),
            ),
          ],
        ),
      ),
    );
  }

  // Individual Filter Tab
  Widget _buildFilterTab(String title, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTheme.manropeSemiBold(
              15,
              isSelected ? Colors.white : const Color(0xFF84AAC9),
            ),
          ),
          const SizedBox(height: 4),
          if (isSelected)
            Container(
              height: 2,
              width: 32,
              color: Colors.white,
            ),
        ],
      ),
    );
  }

  // Search and Date Filter Widget
  Widget _buildSearchAndFilter() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
      child: Row(
        children: [
          // Search field
          Expanded(
            child: Container(
              height: 45,
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  side: const BorderSide(
                    width: 1,
                    color: Color(0xFFDFE2E3),
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Seferlerde ara...',
                  hintStyle:
                      AppTheme.manropeSemiBold(15, const Color(0xFFC1C1C2)),
                  prefixIcon:
                      const Icon(Icons.search, color: Color(0xFFC1C1C2)),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ),

          const SizedBox(width: 10),

          // Date filter
          Container(
            height: 45,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: ShapeDecoration(
              shape: RoundedRectangleBorder(
                side: const BorderSide(
                  width: 1,
                  color: Color(0xFFDFE2E3),
                ),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Row(
              children: [
                const Icon(Icons.calendar_today, size: 20),
                const SizedBox(width: 8),
                Text(
                  _selectedTimeFilter,
                  style: AppTheme.manropeSemiBold(15, const Color(0xFF474747)),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.arrow_drop_down),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Info Row (Trip count and date range)
  Widget _buildInfoRow(TripsProvider tripsProvider) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Trip count
          Text(
            'Toplam ${_filteredTrips.length} Sefer',
            style: AppTheme.manropeRegular(13, const Color(0xFFC1C1C2)),
          ),

          // Date range
          Text(
            '14/02/2025 - 21/02/2025',
            style: AppTheme.manropeRegular(13, const Color(0xFFC1C1C2)),
            textAlign: TextAlign.right,
          ),
        ],
      ),
    );
  }

  // Trips List Widget
  Widget _buildTripsList() {
    if (_filteredTrips.isEmpty) {
      return Expanded(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.directions_car_outlined,
                  size: 48, color: AppTheme.textLightGrey),
              const SizedBox(height: 16),
              Text(
                'Sefer bulunamadı',
                style: AppTheme.manropeSemiBold(16, AppTheme.textLightGrey),
              ),
            ],
          ),
        ),
      );
    }

    return Expanded(
      child: ListView.builder(
        padding: const EdgeInsets.all(15),
        itemCount: _filteredTrips.length,
        itemBuilder: (context, index) {
          final trip = _filteredTrips[index];
          return _buildTripCard(trip);
        },
      ),
    );
  }

  // Individual Trip Card
  Widget _buildTripCard(Trip trip) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      width: double.infinity,
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: const BorderSide(
            width: 1,
            color: Color(0xFFEAEAEA),
          ),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Trip number
                Text(
                  trip.tripNumber,
                  style: AppTheme.manropeBold(18, const Color(0xFF474747)),
                ),

                // Status badge
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: ShapeDecoration(
                    color: trip.isActive
                        ? const Color(0xFFD3F0FF)
                        : const Color(0xFFDBFFDF),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  child: Text(
                    trip.isActive ? 'Devam Ediyor' : 'Tamamlandı',
                    style: AppTheme.manropeBold(
                      11,
                      trip.isActive
                          ? const Color(0xFF2D4856)
                          : const Color(0xFF5D8765),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            // Start date
            Text(
              '${trip.formattedStartDate} - 14:30',
              style: AppTheme.manropeSemiBold(13, const Color(0xFFBCBEC2)),
            ),

            // End date (if completed)
            if (!trip.isActive && trip.endDate != null)
              Text(
                '${trip.endDate} - 14:30 Tamamlandı',
                style: AppTheme.manropeSemiBold(13, const Color(0xFFBCBEC2)),
              ),

            // Vehicle and driver info
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                '${trip.vehiclePlate ?? ""}  -  ${trip.driverName ?? ""}',
                style: AppTheme.manropeSemiBold(13, const Color(0xFF838383)),
                textAlign: TextAlign.right,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Bottom Navigation Bar
  Widget _buildBottomNavBar() {
    return Container(
      width: MediaQuery.of(context).size.width - 30,
      height: 69,
      decoration: ShapeDecoration(
        gradient: AppTheme.navBarGradient,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        shadows: const [
          BoxShadow(
            color: Color(0x26000000),
            blurRadius: 10,
            offset: Offset(0, 4),
            spreadRadius: 0,
          )
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _navItem('Ana Sayfa', Icons.home, false, () {
            Navigator.pushReplacementNamed(context, '/admin_home');
          }),
          _navItem('Giderler', Icons.attach_money, false, () {
            // Handle navigation
          }),
          _navItem('Seferler', Icons.local_shipping, true, () {
            // Already on this screen
          }),
          _navItem('Hesabım', Icons.person, false, () {
            // Handle navigation
          }),
          _navItem('Ayarlar', Icons.settings, false, () {
            // Handle navigation
          }),
        ],
      ),
    );
  }

  // Individual Navigation Item
  Widget _navItem(
      String label, IconData icon, bool isActive, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: isActive ? Colors.white : AppTheme.navIconColor,
            size: 24,
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              color: isActive ? Colors.white : AppTheme.navIconColor,
              fontFamily: 'Manrope',
              fontSize: 11,
              fontWeight: isActive ? FontWeight.w700 : FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
