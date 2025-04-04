import 'package:flutter/material.dart';
import '../config/theme.dart';
import '../screens/admin/admin_home_screen.dart';
import '../screens/admin/admin_expense_screen.dart';
import '../screens/admin/admin_truck_screen.dart';
import '../screens/admin/admin_drivers_screen.dart'; // Şoförler ekranı eklendi
import '../screens/admin/admin_account_screen.dart';
import '../screens/admin/admin_settings_screen.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;

  const CustomBottomNavigationBar({
    super.key,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      decoration: BoxDecoration(
        gradient: AppTheme.navBarGradient,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(26),  // withOpacity(0.1) yerine withAlpha kullanıldı
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(
              context,
              icon: Icons.home,
              label: "Ana Sayfa",
              isSelected: currentIndex == 0,
              onTap: () {
                if (currentIndex != 0) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const AdminHomeScreen()),
                  );
                }
              },
            ),
            _buildNavItem(
              context,
              icon: Icons.attach_money,
              label: "Giderler",
              isSelected: currentIndex == 1,
              onTap: () {
                if (currentIndex != 1) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const AdminExpenseScreen()),
                  );
                }
              },
            ),
            _buildNavItem(
              context,
              icon: Icons.local_shipping,
              label: "Seferler",
              isSelected: currentIndex == 2,
              onTap: () {
                if (currentIndex != 2) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const AdminTruckScreen()),
                  );
                }
              },
            ),
            _buildNavItem(
              context,
              icon: Icons.people,
              label: "Şoförler",
              isSelected: currentIndex == 3,
              onTap: () {
                if (currentIndex != 3) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const AdminDriversScreen()),
                  );
                }
              },
            ),
            _buildNavItem(
              context,
              icon: Icons.person,
              label: "Hesabım",
              isSelected: currentIndex == 4,
              onTap: () {
                if (currentIndex != 4) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const AdminAccountScreen()),
                  );
                }
              },
            ),
            _buildNavItem(
              context,
              icon: Icons.settings,
              label: "Ayarlar",
              isSelected: currentIndex == 5,
              onTap: () {
                if (currentIndex != 5) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const AdminSettingsScreen()),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context, {
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
            color: isSelected ? Colors.white : Colors.white.withAlpha(128),  // withOpacity(0.5) yerine withAlpha kullanıldı
            size: 24,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.white.withAlpha(128),  // withOpacity(0.5) yerine withAlpha kullanıldı
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}