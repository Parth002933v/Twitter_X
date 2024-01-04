import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_x_three/common/common.dart';
import 'package:twitter_x_three/constants/constants.dart';
import 'package:twitter_x_three/features/application/controller/application_controller.dart';

BottomNavigationBar applicationBottomNavigationBar(
    int BottomNavBarP, WidgetRef ref) {
  return BottomNavigationBar(
    showSelectedLabels: false,
    showUnselectedLabels: false,
    type: BottomNavigationBarType.fixed,
    currentIndex: BottomNavBarP,
    onTap: (value) => ref.read(BottomNavBarProvider.notifier).state = value,
    items: [
      _buildBottomNavigationBarItem(
        UnselectedIcon: AssetsConstants.home,
        selectedIcon: AssetsConstants.home_filled,
        label: 'Home',
      ),
      _buildBottomNavigationBarItem(
        UnselectedIcon: AssetsConstants.search,
        selectedIcon: AssetsConstants.search_filled,
        label: 'search',
      ),
      _buildBottomNavigationBarItem(
        UnselectedIcon: AssetsConstants.people,
        selectedIcon: AssetsConstants.people_filled,
        label: 'people',
      ),
      _buildBottomNavigationBarItem(
        UnselectedIcon: AssetsConstants.notification,
        selectedIcon: AssetsConstants.notification_filled,
        label: 'notification',
      ),
      _buildBottomNavigationBarItem(
        UnselectedIcon: AssetsConstants.mail,
        selectedIcon: AssetsConstants.mail_filled,
        label: 'mail',
      ),
    ],
  );
}

BottomNavigationBarItem _buildBottomNavigationBarItem({
  required String UnselectedIcon,
  required String selectedIcon,
  required String label,
}) {
  return BottomNavigationBarItem(
    backgroundColor: Colors.transparent,
    icon: svgIcon(icon: UnselectedIcon, color: Colors.white),
    activeIcon: svgIcon(icon: selectedIcon, color: Colors.white),
    label: label,
  );
}
