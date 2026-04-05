import 'package:flutter/material.dart';
import 'package:pos_system/features/reports/presentation/screens/reports_screen.dart';
import 'package:pos_system/features/settings/presentation/screens/settings_screen.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../invoices/presentation/screens/pos_screen.dart';
import '../../../menu/presentation/screens/menu_admin_screen.dart';
import '../../../shifts/presentation/screens/shift_screen.dart';

class MainDashboardScreen extends StatefulWidget {
  const MainDashboardScreen({super.key});

  @override
  State<MainDashboardScreen> createState() => _MainDashboardScreenState();
}

class _MainDashboardScreenState extends State<MainDashboardScreen> {
  int _selectedIndex = 0;

  // قائمة الشاشات التي سيتم التنقل بينها
  final List<Widget> _screens = const [
    PosScreen(),
    ShiftScreen(),
    MenuAdminScreen(),
    ReportsScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // الشريط الجانبي (Navigation Rail)
          NavigationRail(
            selectedIndex: _selectedIndex,
            onDestinationSelected: (int index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            labelType: NavigationRailLabelType.all,
            backgroundColor: AppColors.primary,
            unselectedIconTheme: const IconThemeData(color: Colors.white70),
            unselectedLabelTextStyle: const TextStyle(color: Colors.white70),
            selectedIconTheme: const IconThemeData(color: AppColors.primary, size: 30),
            selectedLabelTextStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            useIndicator: true,
            indicatorColor: Colors.white,
            // لوجو التطبيق أو الكاشير في أعلى الشريط
            leading: Padding(
              padding: const EdgeInsets.only(bottom: 24.0, top: 16.0),
              child: Column(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 30,
                    child: Icon(Icons.storefront, size: 35, color: AppColors.primary),
                  ),
                  const SizedBox(height: 8),
                  const Text('POS', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            destinations: const [
              NavigationRailDestination(
                icon: Icon(Icons.point_of_sale),
                label: Text('نقطة البيع'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.access_time_filled),
                label: Text('الورديات'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.restaurant_menu),
                label: Text('قائمة الطعام'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.analytics),
                label: Text('التقارير'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.settings),
                label: Text('الإعدادات'),
              ),
            ],
          ),
          const VerticalDivider(thickness: 1, width: 1, color: Colors.grey),
          
          // منطقة عرض الشاشات (باستخدام IndexedStack للحفاظ على الحالة)
          Expanded(
            child: IndexedStack(
              index: _selectedIndex,
              children: _screens,
            ),
          ),
        ],
      ),
    );
  }
}