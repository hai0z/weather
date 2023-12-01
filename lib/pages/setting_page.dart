import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:weather/providers/setting_provider.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).primaryTextTheme.bodySmall?.color;
    return Consumer<SettingProvider>(
      builder: (context, setting, child) => Container(
        decoration: BoxDecoration(color: Theme.of(context).primaryColor.withOpacity(0.8)),
        width: double.infinity,
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColorLight,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 25,
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 16),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  height: 85.h,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Theme.of(context).primaryColor,
                        Theme.of(context).primaryColorDark,
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context).primaryColorDark,
                        offset: const Offset(2.0, 2.0),
                        blurRadius: 6.0,
                      )
                    ],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Đơn vị",
                            style: GoogleFonts.lato(fontSize: 16.sp, color: textColor),
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          Text(
                            setting.getTempUnit == TemperatureUnit.celsius ? "°C" : "°F",
                            style: GoogleFonts.lato(fontSize: 14.sp, color: textColor),
                          )
                        ],
                      ),
                      Switch(
                        activeColor: Theme.of(context).primaryColorLight,
                        value: setting.getTempUnit == TemperatureUnit.celsius,
                        onChanged: (value) {
                          setting.changeTempUnit(value == true ? "C" : "F");
                        },
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 16),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  height: 85.h,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Theme.of(context).primaryColor,
                        Theme.of(context).primaryColorDark,
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context).primaryColorDark,
                        offset: const Offset(2.0, 2.0),
                        blurRadius: 6.0,
                      )
                    ],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Chủ đề",
                        style: GoogleFonts.lato(fontSize: 16.sp, color: textColor),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      DropdownButton(
                        iconEnabledColor: textColor,
                        style: TextStyle(
                          color: textColor,
                        ),
                        value: setting.getSelectedTheme,
                        dropdownColor: Theme.of(context).primaryColor,
                        onChanged: (value) {
                          setting.changeTheme(value!);
                        },
                        items: setting.getListTheme.map((String value) {
                          return DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value,
                              ));
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
