import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/theme.dart';
import '../../providers/drivers_provider.dart';
import '../../models/driver_model.dart';
import 'admin_add_driver_screen.dart';
import 'admin_home_screen.dart';
import 'admin_expense_screen.dart';
import 'admin_truck_screen.dart';
import 'admin_account_screen.dart';
import 'admin_settings_screen.dart';

class AdminDriversScreen extends StatefulWidget {
  const AdminDriversScreen({super.key});

  @override
  State<AdminDriversScreen> createState() => _AdminDriversScreenState();
}

class _AdminDriversScreenState extends State<AdminDriversScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Şoförleri yükle
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<DriversProvider>(context, listen: false).loadDrivers();
    });

    // Arama yapıldığında filtreleme işlemi
    _searchController.addListener(() {
      Provider.of<DriversProvider>(context, listen: false)
          .searchDrivers(_searchController.text);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final driversProvider = Provider.of<DriversProvider>(context);

    return Scaffold(
      extendBody: true, // navbar arkasının şeffaf olması için
      body: Stack(
        children: [
          // Background gradient container
          Container(
            height: 534, // Figma'daki yükseklik
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

          // Main content
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Üst Kısım
              Padding(
                padding: const EdgeInsets.only(top: 59, left: 19, right: 17),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Başlık
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Şoförler",
                          style: AppTheme.manropeBold(22, Colors.white),
                        ),
                        const SizedBox(height: 15),
                        // Sekme çubuğu
                        Text(
                          "Tümü",
                          style: AppTheme.manropeSemiBold(15, Colors.white),
                        ),
                        const SizedBox(height: 6),
                        // Seçili sekmenin alt çizgisi
                        Container(
                          width: 38,
                          height: 2,
                          color: const Color(0xFFD3F0FF),
                        ),
                      ],
                    ),

                    // Şoför Ekle butonu
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AdminAddDriverScreen(),
                          ),
                        ).then((_) {
                          // Sayfa geri döndüğünde şoförleri yeniden yükle
                          driversProvider.loadDrivers();
                        });
                      },
                      child: Container(
                        width: 107,
                        height: 35,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: const Color(0xFFE0E2E3),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            "Şoför Ekle",
                            style:
                                AppTheme.manropeSemiBold(15, AppTheme.textDark),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // İçerik Alanı
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(top: 10),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(5),
                      topRight: Radius.circular(5),
                    ),
                  ),
                  child: Column(
                    children: [
                      // Arama alanı ve toplam şoför sayısı
                      Padding(
                        padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
                        child: SizedBox(
                          width: 400,
                          height: 75,
                          child: Stack(
                            children: [
                              // Arama kutusu
                              Positioned(
                                left: 0,
                                top: 0,
                                child: Container(
                                  width: 400,
                                  height: 45,
                                  decoration: ShapeDecoration(
                                    color: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      side: const BorderSide(
                                        width: 1,
                                        color: Color(0xFFDFE2E3), // Figma rengi
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      const SizedBox(width: 11.40),
                                      const Icon(
                                        Icons.search,
                                        color: Color(0xFFC1C1C2), // Figma rengi
                                        size: 24.22,
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: TextField(
                                          controller: _searchController,
                                          decoration: const InputDecoration(
                                            hintText: "Şöförlerde ara...",
                                            hintStyle: TextStyle(
                                              color: Color(
                                                  0xFFC1C1C2), // Figma rengi
                                              fontSize: 15,
                                              fontFamily: 'Manrope',
                                              fontWeight: FontWeight.w600,
                                              height:
                                                  1.60, // Figma'daki gibi height
                                            ),
                                            border: InputBorder.none,
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    vertical: 12),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              // Toplam şoför sayısı
                              Positioned(
                                left: 271,
                                top: 51,
                                child: SizedBox(
                                  width: 127,
                                  child: Text(
                                    "Toplam ${driversProvider.driverCount} Şoför",
                                    textAlign: TextAlign.right,
                                    style: const TextStyle(
                                      color: Color(0xFFC1C1C2), // Figma rengi
                                      fontSize: 13,
                                      fontFamily: 'Manrope',
                                      fontWeight: FontWeight.w500,
                                      height: 1.85, // Figma'daki gibi height
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Şoför listesi
                      Expanded(
                        child: driversProvider.isLoading
                            ? const Center(child: CircularProgressIndicator())
                            : driversProvider.drivers.isEmpty
                                ? Center(
                                    child: Text(
                                      "Şoför bulunmamaktadır.",
                                      style: AppTheme.manropeSemiBold(16),
                                    ),
                                  )
                                : ListView.builder(
                                    padding: const EdgeInsets.only(
                                        top: 10,
                                        bottom: 120), // Navbar için alt boşluk
                                    itemCount: driversProvider.drivers.length,
                                    itemBuilder: (context, index) {
                                      final driver =
                                          driversProvider.drivers[index];
                                      return _buildDriverCard(driver);
                                    },
                                  ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Bottom navigation bar
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
                        icon: Icons.home_outlined,
                        label: 'Ana Sayfa',
                        isSelected: false,
                        onTap: () => _navigateTo(0)),
                    _buildNavItem(
                        icon: Icons.insert_drive_file_outlined,
                        label: 'Giderler',
                        isSelected: false,
                        onTap: () => _navigateTo(1)),
                    _buildNavItem(
                        icon: Icons.route,
                        label: 'Seferler',
                        isSelected: false,
                        onTap: () => _navigateTo(2)),
                    _buildNavItem(
                        icon: Icons.account_box_outlined,
                        label: 'Şoförler',
                        isSelected: true,
                        onTap: () => _navigateTo(3)),
                    _buildNavItem(
                        icon: Icons.settings,
                        label: 'Ayarlar',
                        isSelected: false,
                        onTap: () => _navigateTo(5)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _navigateTo(int index) {
    // Eğer zaten seçili sayfa ise bir şey yapma
    if (index == 3) return;

    Widget screen;

    switch (index) {
      case 0: // Ana Sayfa
        screen = const AdminHomeScreen();
        break;
      case 1: // Giderler
        screen = const AdminExpenseScreen();
        break;
      case 2: // Seferler
        screen = const AdminTruckScreen();
        break;
      case 4: // Hesabım
        screen = const AdminAccountScreen();
        break;
      case 5: // Ayarlar
        screen = const AdminSettingsScreen();
        break;
      default:
        return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isSelected
                ? Colors.white
                : const Color.fromRGBO(221, 221, 221, 0.8),
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
      ),
    );
  }

  Widget _buildDriverCard(Driver driver) {
    return Container(
      margin: const EdgeInsets.fromLTRB(15, 0, 15, 10),
      height: 76,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: AppTheme.borderColor,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.03),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          const SizedBox(width: 30),
          // Şoför ikonu
          Icon(
            Icons.account_circle_outlined,
            size: 24,
            color: AppTheme.iconGrey,
          ),
          const SizedBox(width: 14),
          // Şoför bilgileri
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                driver.fullName,
                style: AppTheme.manropeSemiBold(17, AppTheme.textDark),
              ),
              const SizedBox(height: 4),
              Text(
                driver.phone,
                style: AppTheme.manropeSemiBold(13, AppTheme.textLightGrey),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
