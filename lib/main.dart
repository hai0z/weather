// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:weather/components/hidden_drawer.dart';

import 'package:weather/providers/setting_provider.dart';
import 'package:weather/themes/get_theme.dart';
import 'package:weather/utils/share_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('vi_VN', null);
  runApp(ChangeNotifierProvider(
    create: (context) => SettingProvider(),
    child: const MainApp(),
  ));
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});
  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  Future<void> _initApp() async {
    String? theme = await readData("theme");
    String? tempUnit = await readData("tempUnit");
    String? currentLocation = await readData("currentLocation");

    if (currentLocation != null) {
      Provider.of<SettingProvider>(context, listen: false)
          .changeLocation(currentLocation);
    }

    if (tempUnit != null) {
      if (tempUnit == "C") {
        Provider.of<SettingProvider>(context, listen: false)
            .changeTempUnit("C");
      } else {
        Provider.of<SettingProvider>(context, listen: false)
            .changeTempUnit("F");
      }
    }

    if (theme != null) {
      Provider.of<SettingProvider>(context, listen: false).changeTheme(theme);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _initApp(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return ScreenUtilInit(
            builder: (context, child) =>
                Consumer<SettingProvider>(builder: (context, value, child) {
              return MaterialApp(
                theme: ThemeData(
                  primarySwatch: getColorTheme(context),
                ),
                debugShowCheckedModeBanner: false,
                home: const HiddenDrawer(),
              );
            }),
          );
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }
}
