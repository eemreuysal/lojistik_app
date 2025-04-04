import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/theme.dart';
import '../../providers/auth_provider.dart';
import '../../providers/dashboard_provider.dart';
import '../../models/trip_model.dart';
import 'admin_create_trip_screen.dart';
import 'admin_truck_screen.dart';
import 'profile_edit_screen.dart';
import '../../widgets/profile_image_widget.dart';

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({super.key});

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadTrips();
    // Dashboard verilerini yükle
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<DashboardProvider>(context, listen: false)
          .loadDashboardData();
    });
  }

  Future<void> _loadTrips() async {
    // ... existing code ...
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final dashboardProvider = Provider.of<DashboardProvider>(context);
    final user = authProvider.currentUser;

    return Scaffold(
      extendBody: true, // navbar arkasının şeffaf olması için
      body: Stack(
        children: [
          // Background gradient - Figma tasarımına uygun
          Container(
            height: 534,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment(-0.61, 0.50),
                end: Alignment(0.39, 1.11),
                colors: [
                  Color.fromRGBO(7, 38, 62, 1),
                  Color.fromRGBO(16, 52, 80, 1),
                  Color.fromRGBO(30, 72, 92, 1),
                ],
                stops: [0.004, 0.531, 1.0],
              ),
            ),
          ),

          // White curved background
          Positioned(
            top: 357,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 575,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
            ),
          ),

          // Content
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top bar with profile and logout
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 64, 20, 0),
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
                            imageUrl: user?.profileImageUrl,
                            initials: user?.initials,
                            companyName: user?.companyName,
                            radius: 18.5,
                          ),
                        ),
                        const SizedBox(width: 13),
                        Text(
                          (user?.companyName ?? 'Şirket Adı').length > 20
                              ? (user?.companyName ?? 'Şirket Adı')
                                  .substring(0, 20)
                              : user?.companyName ?? 'Şirket Adı',
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

                    // Logout button
                    GestureDetector(
                      onTap: () => authProvider.logout(),
                      child: Container(
                        width: 107,
                        height: 34,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: const Color(0xFFA3C0D6),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Çıkış Yap',
                              style: AppTheme.manropeSemiBold(
                                  13, const Color(0xFFA3C0D6)),
                            ),
                            const SizedBox(width: 7),
                            const Icon(
                              Icons.logout_rounded,
                              color: Color(0xFFA3C0D6),
                              size: 20,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Dashboard card
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 25, 20, 0),
                child: Container(
                  width: 390,
                  height: 206,
                  decoration: ShapeDecoration(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    shadows: [
                      BoxShadow(
                        color: Color(0x7F082740),
                        blurRadius: 4.70,
                        offset: Offset(0, 8),
                        spreadRadius: -32,
                      )
                    ],
                  ),
                  child: Stack(
                    children: [
                      // Sağdaki koyu renkli kutu
                      Positioned(
                        right: 20,
                        top: 19,
                        child: Container(
                          width: 149,
                          height: 160,
                          decoration: ShapeDecoration(
                            color: const Color(0xFF0C2D41),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            shadows: [
                              BoxShadow(
                                color: Color(0x7F082740),
                                blurRadius: 4.70,
                                offset: Offset(0, 8),
                                spreadRadius: -32,
                              )
                            ],
                          ),
                        ),
                      ),

                      // Kamyon görseli - bağımsız olarak konumlandırıldı
                      Positioned(
                        right: 20, // Sağ tarafa doğru konum
                        top: 55, // Kutunun üstünde görünmesi için
                        child: Image.asset(
                          'assets/images/truck.png',
                          width: 175, // Uygun genişlik
                          height: 175, // Uygun yükseklik
                          fit: BoxFit.contain,
                        ),
                      ),
                      // Araç etiketi
                      Positioned(
                        left: 122,
                        top: 71,
                        child: Text(
                          'Araç',
                          style: TextStyle(
                            color: const Color(0xFFBBBDC1),
                            fontSize: 12,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                            height: 2,
                          ),
                        ),
                      ),
                      // Şöför etiketi
                      Positioned(
                        left: 17,
                        top: 71,
                        child: Text(
                          'Şöför',
                          style: TextStyle(
                            color: const Color(0xFFBBBDC1),
                            fontSize: 12,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                            height: 2,
                          ),
                        ),
                      ),
                      // Sefer etiketi
                      Positioned(
                        left: 17,
                        top: 19,
                        child: Text(
                          'Sefer',
                          style: TextStyle(
                            color: const Color(0xFFBBBDC1),
                            fontSize: 12,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                            height: 2,
                          ),
                        ),
                      ),
                      // Araç sayısı
                      Positioned(
                        left: 122,
                        top: 94,
                        child: Text(
                          '${dashboardProvider.vehicleCount} Araç',
                          style: TextStyle(
                            color: const Color(0xFF474747),
                            fontSize: 18,
                            fontFamily: 'Clash Grotesk',
                            fontWeight: FontWeight.w600,
                            height: 1.33,
                          ),
                        ),
                      ),
                      // Şöför sayısı
                      Positioned(
                        left: 17,
                        top: 94,
                        child: Text(
                          '${dashboardProvider.driverCount} Şöför',
                          style: TextStyle(
                            color: const Color(0xFF474747),
                            fontSize: 18,
                            fontFamily: 'Clash Grotesk',
                            fontWeight: FontWeight.w600,
                            height: 1.33,
                          ),
                        ),
                      ),
                      // Sefer sayısı
                      Positioned(
                        left: 17,
                        top: 42,
                        child: Text(
                          '${dashboardProvider.tripCount} Sefer',
                          style: TextStyle(
                            color: const Color(0xFF474747),
                            fontSize: 18,
                            fontFamily: 'Clash Grotesk',
                            fontWeight: FontWeight.w600,
                            height: 1.33,
                          ),
                        ),
                      ),
                      // Sefer Oluştur butonu
                      Positioned(
                        left: 19,
                        top: 142,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const AdminCreateTripScreen(),
                              ),
                            );
                          },
                          child: Container(
                            width: 167,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: const Color(0xFFE0E2E4),
                                width: 1,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                'Sefer Oluştur',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: const Color(0xFF474747),
                                  fontSize: 15,
                                  fontFamily: 'Manrope',
                                  fontWeight: FontWeight.w600,
                                  height: 1.60,
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

              // Recent shipments section - başlık ve arama kısmı
              Padding(
                padding: const EdgeInsets.fromLTRB(19, 44, 19, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Stack(
                              clipBehavior: Clip.none,
                              children: [
                                const Text(
                                  'Son Seferler',
                                  style: TextStyle(
                                    color: Color(0xFF373737),
                                    fontSize: 20,
                                    fontFamily: 'Manrope',
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Positioned(
                                  left: 0,
                                  right: 0,
                                  bottom: -8,
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Container(
                                      width: 34,
                                      height: 3,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF1F2A35),
                                        borderRadius:
                                            BorderRadius.circular(1.5),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const AdminTruckScreen(),
                              ),
                            );
                          },
                          child: const Text(
                            'Tümünü Gör',
                            style: TextStyle(
                              color: Color(0xFF878787),
                              fontSize: 14,
                              fontFamily: 'Manrope',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),

                    // Search box
                    const SizedBox(height: 8),
                    Container(
                      width: 390,
                      height: 45,
                      decoration: BoxDecoration(
                        color: const Color(0xFFD3F0FF),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextField(
                        controller: _searchController,
                        onChanged: (value) {
                          // Arama sorgusunu güncelle
                          Provider.of<DashboardProvider>(context, listen: false)
                              .updateSearchQuery(value);
                        },
                        decoration: const InputDecoration(
                          hintText: 'Sefer veya Teslimat Numarası...',
                          hintStyle: TextStyle(
                            color: Color(0xFF93B6C2),
                            fontSize: 14,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w500,
                          ),
                          prefixIcon: Icon(
                            Icons.search,
                            color: Color(0xFF93B6C2),
                            size: 24,
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Sefer listesi için kaydırılabilir alan - sadece bu kısım kaydırılabilir olacak
              const SizedBox(height: 10),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 19.0),
                  child: dashboardProvider.isLoading
                      ? const Center(
                          child: Padding(
                            padding: EdgeInsets.all(20.0),
                            child: CircularProgressIndicator(
                                color: Color(0xFF0C2D41)),
                          ),
                        )
                      : dashboardProvider.recentTrips.isEmpty
                          ? Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 24.0),
                              child: Center(
                                child: dashboardProvider.searchQuery.isEmpty
                                    ? const Text("Henüz sefer bulunmamaktadır.")
                                    : Text(
                                        "'${dashboardProvider.searchQuery}' için sonuç bulunamadı."),
                              ),
                            )
                          : ListView.builder(
                              padding: EdgeInsets.only(
                                  bottom: 95), // Navbar için alt boşluk
                              itemCount: dashboardProvider.recentTrips.length,
                              itemBuilder: (context, index) {
                                final trip =
                                    dashboardProvider.recentTrips[index];
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: _buildShipmentCard(
                                    trip: trip,
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const AdminTruckScreen(),
                                        ),
                                      );
                                    },
                                  ),
                                );
                              },
                            ),
                ),
              ),
            ],
          ),

          // Bottom navigation - her zaman sabit kalır
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 45, left: 15, right: 15),
              child: Container(
                height: 69,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment(0.01, 0.50),
                    end: Alignment(1.00, 0.50),
                    colors: [
                      Color(0xFF06263E),
                      Color(0xFF10344F),
                      Color(0xFF1E485C)
                    ],
                  ),
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: const [
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
                    _buildNavItem(
                        icon: Icons.home, label: 'Ana Sayfa', isSelected: true),
                    _buildNavItem(
                        icon: Icons.insert_drive_file_outlined,
                        label: 'Giderler',
                        isSelected: false),
                    _buildNavItem(
                        icon: Icons.route,
                        label: 'Seferler',
                        isSelected: false),
                    _buildNavItem(
                        icon: Icons.account_box_outlined,
                        label: 'Hesabım',
                        isSelected: false),
                    _buildNavItem(
                        icon: Icons.settings,
                        label: 'Ayarlar',
                        isSelected: false),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShipmentCard({
    required Trip trip,
    required VoidCallback onTap,
  }) {
    final bool isOngoing = trip.isActive;
    final String formattedDateTime =
        '${trip.formattedStartDate} - ${trip.createdAt.hour}:${trip.createdAt.minute}';

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 400,
        height: isOngoing ? 100 : 110, // Yükseklikleri arttırdım
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: const Color(0xFFEBEBEB),
            width: 1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(17, 15, 17, 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Sefer numarası ve ikon yan yana
                  Row(
                    children: [
                      Text(
                        trip.tripNumber,
                        style: const TextStyle(
                          color: Color(0xFF474747),
                          fontSize: 18,
                          fontFamily: 'Manrope',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      // İkonu buraya taşıdık
                      if (isOngoing)
                        const Padding(
                          padding: EdgeInsets.only(left: 8),
                          child: Icon(
                            Icons.local_shipping_outlined,
                            color: Color(0xFF268BB8),
                            size: 26,
                          ),
                        ),
                    ],
                  ),
                  if (isOngoing)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFD3F0FF),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(
                        trip.statusText,
                        style: const TextStyle(
                          color: Color(0xFF2D4756),
                          fontSize: 11,
                          fontFamily: 'Manrope',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // İkonu kaldırdık, sadece tarih bilgisi
                  Text(
                    formattedDateTime,
                    style: const TextStyle(
                      color: Color(0xFFBCBEC2),
                      fontSize: 13,
                      fontFamily: 'Manrope',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    trip.vehiclePlate != null && trip.driverName != null
                        ? '${trip.vehiclePlate}  -  ${trip.driverName}'
                        : trip.vehiclePlate ?? trip.driverName ?? '',
                    style: const TextStyle(
                      color: Color(0xFF838383),
                      fontSize: 13,
                      fontFamily: 'Manrope',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              if (!isOngoing && trip.endDate != null)
                Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(
                    '${trip.endDate} - Tamamlandı',
                    style: const TextStyle(
                      color: Color(0xFFBCBEC2),
                      fontSize: 13,
                      fontFamily: 'Manrope',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required bool isSelected,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: isSelected ? Colors.white : const Color(0xFFDDDDDD),
          size: 24,
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : const Color(0xFFDDDDDD),
            fontSize: 11,
            fontFamily: 'Manrope',
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
