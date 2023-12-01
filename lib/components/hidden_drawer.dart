import 'package:flutter/material.dart';
import 'package:hidden_drawer_menu/hidden_drawer_menu.dart';
import 'package:weather/pages/home_page.dart';
import 'package:weather/pages/location_manager.dart';
import 'package:weather/pages/search_page.dart';
import 'package:weather/pages/setting_page.dart';

class HiddenDrawer extends StatefulWidget {
  const HiddenDrawer({super.key});

  @override
  State<HiddenDrawer> createState() => _HiddenDrawerState();
}

class _HiddenDrawerState extends State<HiddenDrawer> {
  @override
  Widget build(BuildContext context) {
    return HiddenDrawerMenu(
      backgroundColorMenu: Theme.of(context).primaryColor,
      screens: [
        ScreenHiddenDrawer(
            ItemHiddenMenu(
              name: "Thời tiết",
              baseStyle:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              selectedStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.white),
            ),
            const HomePage()),
        ScreenHiddenDrawer(
            ItemHiddenMenu(
              name: "Quản lý vị trí",
              baseStyle:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              selectedStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.white),
            ),
            const LocationPage()),
        ScreenHiddenDrawer(
            ItemHiddenMenu(
              name: "Cài đặt",
              baseStyle:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              selectedStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.white),
            ),
            const SettingPage()),
      ],
      elevationAppBar: 16,
      initPositionSelected: 0,
      slidePercent: 50,
      backgroundColorAppBar: Theme.of(context).primaryColor,
      withAutoTittleName: true,
      leadingAppBar: const Icon(
        Icons.menu,
      ),
      actionsAppBar: [
        IconButton(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const SearchPage(),
            ));
          },
          icon: const Icon(
            Icons.add,
          ),
        )
      ],
    );
  }
}
