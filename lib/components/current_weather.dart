import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:weather/components/hour_forecast.dart';
import 'package:weather/model/weather.dart';
import 'package:weather/pages/nextday_page.dart';
import 'package:weather/providers/setting_provider.dart';
import 'package:weather_icons/weather_icons.dart';

class CurrentWeather extends StatelessWidget {
  final AsyncSnapshot<Weather> snapshot;
  const CurrentWeather({super.key, required this.snapshot});

  @override
  Widget build(BuildContext context) {
    var textColor = Theme.of(context).primaryTextTheme.bodySmall?.color;

    Weather? data = snapshot.data;

    final hourForcast = data!.forecast!.forecastday![0].hour!.where((element) {
      final currentTime = data.location!.localtime!.split(" ")[1].split(":")[0];
      var elementTime = element.time?.split(" ")[1].split(":")[0];
      return int.parse(elementTime!) > int.parse(currentTime);
    }).toList();

    final displayHourForcast = [
      ...hourForcast,
      ...data.forecast!.forecastday![1].hour!
    ].take(24).toList();

    final forecastDay = data.forecast!.forecastday;

    return Consumer<SettingProvider>(
      builder: (context, setting, child) => Column(
        children: [
          SizedBox(
            height: 25.h,
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 12.w),
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Theme.of(context).primaryColorDark,
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
                ]),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.location_on,
                          color: Colors.red,
                        ),
                        const SizedBox(
                          width: 4,
                        ),
                        Text(
                          "${data.location!.name}, ",
                          style: GoogleFonts.lato(
                              fontWeight: FontWeight.normal,
                              fontSize: 14.sp,
                              color: textColor),
                        ),
                        Text(
                          "${data.location!.country}",
                          style: GoogleFonts.lato(
                              fontWeight: FontWeight.normal,
                              fontSize: 14.sp,
                              color: textColor),
                        ),
                      ],
                    ),
                    Text(
                      setting.getTempUnit == TemperatureUnit.celsius
                          ? "${data.current?.tempC?.toStringAsFixed(0)}°"
                          : "${data.current?.tempF?.toStringAsFixed(0)}°",
                      style: GoogleFonts.lato(
                        fontSize: 60.sp,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    Text(
                      "${data.current!.condition?.text} ",
                      style: GoogleFonts.lato(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.sp,
                          color: textColor),
                    ),
                  ],
                ),
                Image.network("http:${data.current?.condition?.icon}",
                    fit: BoxFit.cover,
                    width: 80.w,
                    height: 80.w, errorBuilder: (BuildContext context,
                        Object exception, StackTrace? stackTrace) {
                  return Text(exception.toString());
                }),
              ],
            ),
          ),
          SizedBox(
            height: 12.h,
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 12.w),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Theme.of(context).primaryColorDark,
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
                ]),
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 5.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Text(
                      "Tốc độ gió",
                      style: GoogleFonts.roboto(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                          color: textColor),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Row(
                      children: [
                        BoxedIcon(
                          WeatherIcons.windy,
                          size: 24,
                          color: textColor,
                        ),
                        const SizedBox(
                          width: 4,
                        ),
                        Text(
                          "${data.current?.windKph} km/h",
                          style: GoogleFonts.dmMono(
                              fontSize: 14.sp, color: textColor),
                        ),
                      ],
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      "Độ ẩm",
                      style: GoogleFonts.roboto(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                          color: textColor),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Row(
                      children: [
                        BoxedIcon(WeatherIcons.humidity,
                            size: 24, color: textColor),
                        const SizedBox(
                          width: 4,
                        ),
                        Text(
                          "${data.current?.humidity}%",
                          style: GoogleFonts.dmMono(
                              fontSize: 14.sp, color: textColor),
                        ),
                      ],
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      "Cập nhật lần cuối",
                      style: GoogleFonts.roboto(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                          color: textColor),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Row(
                      children: [
                        BoxedIcon(
                          TimeIcon.fromHour(int.parse("3")),
                          color: textColor,
                        ),
                        const SizedBox(
                          width: 4,
                        ),
                        Text(
                          "${data.current?.lastUpdated?.split(" ")[1]}",
                          style: GoogleFonts.dmMono(
                              fontSize: 14.sp, color: textColor),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            height: 12.h,
          ),
          Center(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 10.w),
              height: 125.h,
              width: double.infinity,
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: displayHourForcast.length,
                itemBuilder: (context, index) {
                  return HourForecast(
                    index: index,
                    item: displayHourForcast,
                  );
                },
              ),
            ),
          ),
          SizedBox(
            height: 4.h,
          ),
          Center(
            child: Container(
              margin: EdgeInsets.all(8.w),
              height: 225.h,
              width: double.infinity,
              padding: EdgeInsets.only(right: 12.w, top: 4.w),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
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
                  ]),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      MaterialButton(
                          elevation: 0,
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    NextDay(forecastDay: forecastDay)));
                          },
                          color: textColor,
                          child: Row(
                            children: [
                              const Text(
                                "3 ngày tiếp theo",
                                style: TextStyle(color: Colors.black),
                              ),
                              SizedBox(
                                width: 4.w,
                              ),
                              const Icon(
                                Icons.arrow_forward,
                                size: 12,
                              )
                            ],
                          )),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            width: 8.w,
                          ),
                          Text(
                            "Bình minh",
                            style: TextStyle(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.normal,
                                color: textColor),
                          ),
                        ],
                      ),
                      Text(
                          data.forecast!.forecastday![0].astro!.sunrise!
                              .toString(),
                          style: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: 15.sp,
                              color: textColor))
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            width: 8.w,
                          ),
                          Text(
                            "Hoàng hôn",
                            style: TextStyle(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.normal,
                                color: textColor),
                          ),
                        ],
                      ),
                      Text(
                        data.forecast!.forecastday![0].astro!.sunset!
                            .toString(),
                        style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 15.sp,
                            color: textColor),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            width: 8.w,
                          ),
                          Text(
                            "Nhiệt độ trung bình",
                            style: TextStyle(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.normal,
                                color: textColor),
                          ),
                        ],
                      ),
                      Text(
                        setting.getTempUnit == TemperatureUnit.celsius
                            ? "${data.forecast!.forecastday![0].day!.avgtempC!.toStringAsFixed(0)}°"
                            : "${data.forecast!.forecastday![0].day!.avgtempF!.toStringAsFixed(0)}°",
                        style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 15.sp,
                            color: textColor),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            width: 8.w,
                          ),
                          Text(
                            "Nhiệt độ cao nhất",
                            style: TextStyle(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.normal,
                                color: textColor),
                          ),
                        ],
                      ),
                      Text(
                        setting.getTempUnit == TemperatureUnit.celsius
                            ? "${data.forecast!.forecastday![0].day!.maxtempC!.toStringAsFixed(0)}°"
                            : "${data.forecast!.forecastday![0].day!.maxtempF!.toStringAsFixed(0)}°",
                        style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 15.sp,
                            color: textColor),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            width: 8.w,
                          ),
                          Text(
                            "Nhiệt độ thấp nhất",
                            style: TextStyle(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.normal,
                                color: textColor),
                          ),
                        ],
                      ),
                      Text(
                        setting.getTempUnit == TemperatureUnit.celsius
                            ? "${data.forecast!.forecastday![0].day!.mintempC!.toStringAsFixed(0)}°"
                            : "${data.forecast!.forecastday![0].day!.mintempF!.toStringAsFixed(0)}°",
                        style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 15.sp,
                            color: textColor),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            width: 8.w,
                          ),
                          Text(
                            "UV",
                            style: TextStyle(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.normal,
                                color: textColor),
                          ),
                        ],
                      ),
                      Text(
                        data.forecast!.forecastday![0].day!.uv.toString(),
                        style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 15.sp,
                            color: textColor),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
