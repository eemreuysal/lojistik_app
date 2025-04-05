import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/theme.dart';
import '../../models/vehicle_model.dart';
import '../../providers/vehicles_provider.dart';
import 'admin_home_screen.dart';
import 'admin_truck_screen.dart';
import 'admin_expense_screen.dart';
import 'admin_account_screen.dart';
import 'admin_settings_screen.dart';
import 'admin_add_vehicle_screen.dart';

class AdminVehiclesScreen extends StatefulWidget {
  const AdminVehiclesScreen({super.key});

  @override
  State<AdminVehiclesScreen> createState() => _AdminVehiclesScreenState();
}

class _AdminVehiclesScreenState extends State<AdminVehiclesScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Araçları yükle
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<VehiclesProvider>(context, listen: false).loadVehicles();
    });

    // Arama yapıldığında filtreleme işlemi
    _searchController.addListener(() {
      Provider.of<VehiclesProvider>(context, listen: false)
          .searchVehicles(_searchController.text);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vehiclesProvider = Provider.of<VehiclesProvider>(context);

    return Scaffold(
      extendBody: true, // navbar arkasının şeffaf olması için
      body: Stack(
        children: [
          // Background gradient - AppTheme'den alınıyor
          Container(
            height: 534,
            decoration: const BoxDecoration(
              gradient: AppTheme.primaryGradient,
            ),
          ),

          // White curved background
          Positioned(
            top: 142, // Admin home screen'den daha yukarıda başlattım
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 795, // Daha uzun olması için
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(5),
                  topRight: Radius.circular(5),
                ),
              ),
            ),
          ),

          // Content
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Üst Kısım
              Padding(
                padding: const EdgeInsets.only(top: 59, left: 19, right: 17),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Araçlar",
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

                    // Araç Ekle butonu
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AdminAddVehicleScreen(),
                          ),
                        ).then((_) {
                          // Sayfa geri döndüğünde araçları yeniden yükle
                          vehiclesProvider.loadVehicles();
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
                            "Araç Ekle",
                            style:
                                AppTheme.manropeSemiBold(15, AppTheme.textDark),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

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
                      // Arama alanı ve toplam araç sayısı
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
                                  width: 397,
                                  height: 45,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFD3F0FF),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: TextField(
                                    controller: _searchController,
                                    decoration: InputDecoration( // Removed const
                                      hintText: "Araçlarda ara...", // Fixed quotes
                                      hintStyle: const TextStyle( // Added const here as TextStyle can be const
                                        color: Color(0xFF93B6C2),
                                        fontSize: 14,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w500,
                                      ),
                                      prefixIcon: const Icon( // Added const here as Icon can be const
                                        Icons.search,
                                        color: Color(0xFF93B6C2),
                                        size: 24,
                                      ),
                                      border: InputBorder.none,
                                      contentPadding: const EdgeInsets.symmetric( // Added const here
                                          vertical: 12),
                                    ),
                                  ),
                                ),
                              ),

                              // Toplam araç sayısı
                              Positioned(
                                left: 271,
                                top: 51,
                                child: SizedBox(
                                  width: 127,
                                  child: Text(
                                    "Toplam ${vehiclesProvider.vehicleCount} Araç", // Removed leading whitespace
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


              // Araç listesi
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: vehiclesProvider.isLoading
                      ? const Center(
                          child: CircularProgressIndicator(
                              color: Color(0xFF0C2D41)))
                      : vehiclesProvider.vehicles.isEmpty
                          ? Center(
                              child: Text(
                                "Araç bulunmamaktadır.",
                                style: AppTheme.manropeSemiBold(16),
                              ),
                            )
                          : ListView.separated(
                              padding: const EdgeInsets.only( // Added const
                                  bottom: 95), // Navbar için alt boşluk
                              itemCount: vehiclesProvider.vehicles.length,
                              separatorBuilder: (context, index) =>
                                  const SizedBox(height: 10),
                              itemBuilder: (context, index) {
                                final vehicle =
                                    vehiclesProvider.vehicles[index];
                                return _buildVehicleCard(vehicle);
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
                  gradient: AppTheme.navBarGradient,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x26000000), // Color literal is const implicitly
                      blurRadius: 10,
                      offset: const Offset(0, 4), // Added const
                      spreadRadius: 0,
                    )
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildNavItem(
                        icon: Icons.home,
                        label: 'Ana Sayfa',
                        isSelected: false),
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

  Widget _buildVehicleCard(Vehicle vehicle) {
    return Container(
      width: 400,
      height: 59,
      decoration: ShapeDecoration( // Restored decoration
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            width: 1,
            color: const Color(0xFFEAEAEA), // Added const back to Color
          ),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Row(
        children: [
          // Araç ikonu
          Padding(
            padding: const EdgeInsets.only(left: 18),
            child: Container(
              width: 26,
              height: 26,
              decoration: BoxDecoration(
                color: Colors.grey.withAlpha(26),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.local_shipping,
                color: Colors.grey.shade600,
                size: 16,
              ),
            ),
          ),

          const SizedBox(width: 8),

          // Araç bilgileri
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                vehicle.plateNumber,
                style: TextStyle( // Restored style
                  color: const Color(0xFF474747),
                  fontSize: 17,
                  fontFamily: 'Manrope',
                  fontWeight: FontWeight.w600,
                  height: 1.41, // Restored height
                ),
              ),
            ],
          ),

          const Spacer(),

          // Araç modeli ve markası
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Text(
              '${vehicle.modelYear} - ${vehicle.fullName}',
              textAlign: TextAlign.right,
              style: TextStyle( // Restored second style
                color: const Color(0xFFBCBEC2),
                fontSize: 13,
                fontFamily: 'Manrope',
                fontWeight: FontWeight.w600,
                height: 1.85,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: () {
        if (label == 'Ana Sayfa') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const AdminHomeScreen()),
          );
        } else if (label == 'Giderler') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const AdminExpenseScreen()),
          );
        } else if (label == 'Seferler') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const AdminTruckScreen()),
          );
        } else if (label == 'Hesabım') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const AdminAccountScreen()),
          );
        } else if (label == 'Ayarlar') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => const AdminSettingsScreen()),
          );
        }
      },
      child: Column(
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
            style: TextStyle( // No const here
              color: isSelected ? Colors.white : Color(0xFFDDDDDD), // Removed const from Color
              fontSize: 11,
              fontFamily: 'Manrope',
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
