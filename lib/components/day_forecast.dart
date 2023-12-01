import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:google_fonts/google_fonts.dart";
import "package:weather/model/weather.dart";

import "../providers/setting_provider.dart";
import "../utils/format_date.dart";

class DayForecast extends StatelessWidget {
  final Forecastday eachDay;
  final SettingProvider setting;
  const DayForecast({super.key, required this.eachDay, required this.setting});

  @override
  Widget build(BuildContext context) {
    var textColor = Theme.of(context).primaryTextTheme.bodySmall?.color;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: 70.w,
          child: Text(
            convertDateToDay(eachDay.date!).toString(),
            style: TextStyle(
                fontSize: 15.sp, fontWeight: FontWeight.bold, color: textColor),
          ),
        ),
        const Spacer(),
        SizedBox(
          width: 80.w,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Icon(
                Icons.water_drop_sharp,
                size: 10,
                color: Colors.blueAccent,
              ),
              Text(
                "${eachDay.day?.dailyChanceOfRain}%",
                style: TextStyle(fontWeight: FontWeight.w300, color: textColor),
              ),
              Image.network(
                "http:${eachDay.day?.condition?.icon}",
                width: 32.w,
                height: 32.w,
              ),
            ],
          ),
        ),
        const Spacer(),
        SizedBox(
          width: 70.w,
          child: Text(
            setting.getTempUnit == TemperatureUnit.celsius
                ? "${eachDay.day?.maxtempC!.toStringAsFixed(0)}°/ ${eachDay.day?.mintempC!.toStringAsFixed(0)}°"
                : "${eachDay.day?.maxtempF!.toStringAsFixed(0)}°/ ${eachDay.day?.mintempF!.toStringAsFixed(0)}°",
            style: GoogleFonts.roboto(
                fontWeight: FontWeight.bold, fontSize: 14.sp, color: textColor),
          ),
        )
      ],
    );
  }
}
