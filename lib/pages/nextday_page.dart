import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:weather/model/weather.dart';
import 'package:weather/providers/setting_provider.dart';
import 'package:weather/utils/format_date.dart';

class NextDay extends StatelessWidget {
  final List<Forecastday>? forecastDay;
  const NextDay({super.key, required this.forecastDay});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<SettingProvider>();
    TemperatureUnit tempUnit = state.getTempUnit;

    var textColor = Theme.of(context).primaryTextTheme.bodySmall?.color;
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColorLight,
      appBar: AppBar(
        title: const Text("Dự báo các ngày tới"),
        elevation: 0,
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            height: 200.h,
            decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Theme.of(context).primaryColor,
                    Theme.of(context).primaryColorDark,
                  ],
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(36.w),
                  bottomRight: Radius.circular(36.w),
                )),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Image.network(
                    "http:${forecastDay![1].day!.condition!.icon}",
                    width: 128.w,
                    height: 128.w,
                    fit: BoxFit.cover,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Ngày mai",
                        style: TextStyle(color: textColor, fontSize: 24.sp),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        tempUnit == TemperatureUnit.celsius
                            ? "${forecastDay![1].day?.maxtempC!.toStringAsFixed(0)}°/ ${forecastDay![1].day?.mintempC!.toStringAsFixed(0)}°"
                            : "${forecastDay![1].day?.maxtempF!.toStringAsFixed(0)}°/ ${forecastDay![1].day?.mintempF!.toStringAsFixed(0)}°",
                        style: GoogleFonts.roboto(
                            fontWeight: FontWeight.bold,
                            fontSize: 18.sp,
                            color: textColor),
                      ),
                      SizedBox(height: 8.h),
                      Text("${forecastDay![1].day!.condition!.text}",
                          style: TextStyle(color: textColor, fontSize: 18.sp))
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 12.h,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: ListView.builder(
                  itemCount: forecastDay!.length,
                  itemBuilder: (_, index) {
                    return Container(
                      height: 90.h,
                      margin: EdgeInsets.symmetric(vertical: 8.h),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Theme.of(context).primaryColor,
                          gradient: LinearGradient(
                            begin: Alignment.centerRight,
                            end: Alignment.centerLeft,
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
                          ]),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            convertDateToDay(
                                forecastDay![index].date!.split(" ")[0]),
                            style: TextStyle(fontSize: 18.sp, color: textColor),
                          ),
                          Text(
                            tempUnit == TemperatureUnit.celsius
                                ? "${forecastDay![1].day?.maxtempC!.toStringAsFixed(0)}°/ ${forecastDay![1].day?.mintempC!.toStringAsFixed(0)}°"
                                : "${forecastDay![1].day?.maxtempF!.toStringAsFixed(0)}°/ ${forecastDay![1].day?.mintempF!.toStringAsFixed(0)}°",
                            style: GoogleFonts.roboto(
                                fontWeight: FontWeight.bold,
                                fontSize: 18.sp,
                                color: textColor),
                          ),
                          Column(
                            children: [
                              Image.network(
                                "http:${forecastDay![index].day!.condition!.icon}",
                                width: 64.w,
                                height: 64.w,
                                fit: BoxFit.cover,
                              ),
                              Text(
                                "${forecastDay![index].day!.condition!.text}",
                                style: TextStyle(
                                    fontSize: 14.sp, color: textColor),
                              ),
                            ],
                          )
                        ],
                      ),
                    );
                  }),
            ),
          )
        ],
      ),
    );
  }
}
