import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:weather/model/weather.dart';

import '../providers/setting_provider.dart';

class HourForecast extends StatelessWidget {
  final List<Hour> item;
  final int index;
  const HourForecast({super.key, required this.item, required this.index});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<SettingProvider>();
    TemperatureUnit tempUnit = state.getTempUnit;
    var textColor = Theme.of(context).primaryTextTheme.bodySmall?.color;
    return Container(
      margin: EdgeInsets.only(right: 6.w),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 5.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: LinearGradient(
          begin: Alignment.topCenter, // Điểm bắt đầu của gradient
          end: Alignment.bottomCenter, // Điểm kết thúc của gradient
          colors: [
            Theme.of(context).primaryColor,
            // Màu ở đầu
            Theme.of(context).primaryColorDark, // Màu ở cuối gradient
          ],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            item[index].time!.split(" ")[1].toString(),
            style:
                GoogleFonts.lato(fontWeight: FontWeight.bold, color: textColor),
          ),
          Image.network(
            "http:${item[index].condition?.icon}",
            width: 48.w,
            height: 48.w,
          ),
          Text(
            tempUnit == TemperatureUnit.celsius
                ? "${item[index].tempC!.toStringAsFixed(0)}°"
                : "${item[index].tempF!.toStringAsFixed(0)}°",
            style: GoogleFonts.lato(
                fontWeight: FontWeight.bold, fontSize: 14.sp, color: textColor),
          ),
          Row(
            children: [
              Icon(
                Icons.water_drop_outlined,
                size: 10,
                color: textColor,
              ),
              const SizedBox(
                width: 4,
              ),
              Text(
                "${item[index].chanceOfRain!}%",
                style: GoogleFonts.lato(
                    fontWeight: FontWeight.bold,
                    fontSize: 11.sp,
                    color: textColor),
              ),
            ],
          )
        ],
      ),
    );
  }
}
