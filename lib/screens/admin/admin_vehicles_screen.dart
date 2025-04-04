import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/theme.dart';
import '../../models/vehicle_model.dart';
import '../../providers/vehicles_provider.dart';
import '../../widgets/bottom_navigation_bar.dart';
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
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppTheme.primaryGradient,
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Üst Kısım
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Başlık
                    Text(
                      "Araçlar",
                      style: AppTheme.manropeBold(22, Colors.white),
                    ),
                    
                    // Araç Ekle butonu
                    ElevatedButton(
                      onPressed: () {
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
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: AppTheme.textDark,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        "Araç Ekle",
                        style: AppTheme.manropeSemiBold(15),
                      ),
                    ),
                  ],
                ),
              ),
              
              // İçerik Alanı
              Expanded(
                child: Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(top: 16),
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Arama alanı
                      Container(
                        height: 46,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Colors.grey.withAlpha(76),  // withOpacity(0.3) yerine withAlpha kullanıldı
                          ),
                        ),
                        child: TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            hintText: "Araçlarda ara...",
                            hintStyle: AppTheme.interMedium(14, Colors.grey),
                            border: InputBorder.none,
                            icon: const Icon(Icons.search, color: Colors.grey),
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Toplam araç sayısı
                      Text(
                        "Toplam ${vehiclesProvider.vehicleCount} Araç",
                        style: AppTheme.manropeSemiBold(14, AppTheme.textGrey),
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Araç listesi
                      Expanded(
                        child: vehiclesProvider.isLoading
                            ? const Center(child: CircularProgressIndicator())
                            : vehiclesProvider.vehicles.isEmpty
                                ? Center(
                                    child: Text(
                                      "Araç bulunmamaktadır.",
                                      style: AppTheme.manropeSemiBold(16),
                                    ),
                                  )
                                : ListView.separated(
                                    itemCount: vehiclesProvider.vehicles.length,
                                    separatorBuilder: (context, index) => const SizedBox(height: 12),
                                    itemBuilder: (context, index) {
                                      final vehicle = vehiclesProvider.vehicles[index];
                                      return _buildVehicleCard(vehicle);
                                    },
                                  ),
                      ),
                    ],
                  ),
                ),
              ),
              
              // Alt Navigasyon Barı
              const CustomBottomNavigationBar(currentIndex: 0),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildVehicleCard(Vehicle vehicle) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.withAlpha(51)),  // withOpacity(0.2) yerine withAlpha kullanıldı
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(8),  // withOpacity(0.03) yerine withAlpha kullanıldı
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Araç ikonu
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.grey.withAlpha(26),  // withOpacity(0.1) yerine withAlpha kullanıldı
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.local_shipping,  // directions_truck yerine local_shipping kullanıldı
              color: Colors.grey.shade600,
            ),
          ),
          
          const SizedBox(width: 16),
          
          // Araç bilgileri
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  vehicle.plateNumber,
                  style: AppTheme.manropeSemiBold(16, Colors.black),
                ),
                const SizedBox(height: 4),
                Text(
                  vehicle.fullName,
                  style: AppTheme.manropeSemiBold(14, Colors.grey),
                ),
              ],
            ),
          ),
          
          // Model yılı
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppTheme.searchBg,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '${vehicle.modelYear ?? "-"}',
              style: AppTheme.manropeSemiBold(12, AppTheme.statusBlue),
            ),
          ),
        ],
      ),
    );
  }
}