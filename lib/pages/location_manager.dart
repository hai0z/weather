// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather/components/hidden_drawer.dart';
import 'package:weather/model/weather.dart';
import 'package:weather/utils/share_preferences.dart';

import '../providers/setting_provider.dart';

class LocationPage extends StatefulWidget {
  const LocationPage({super.key});

  @override
  State<LocationPage> createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  late Future<List<String>> _locationList;

  @override
  void initState() {
    super.initState();
    _locationList = _prefs.then((SharedPreferences prefs) {
      return prefs.getStringList('listlocation') ?? [];
    });
  }

  void showBottomSheet1(BuildContext context, int index) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
            height: 50.h,
            color: Theme.of(context).primaryColor.withOpacity(0.8),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: GestureDetector(
                        onTap: () async {
                          final listLocation =
                              await readDataList("listlocation");
                          if (listLocation != null) {
                            listLocation.removeAt(index);
                            writeDataList("listlocation", listLocation)
                                .then((value) {
                              setState(() {
                                _locationList =
                                    _prefs.then((SharedPreferences prefs) {
                                  return prefs.getStringList('listlocation') ??
                                      [];
                                });
                              });
                            });
                          }
                          Navigator.of(context).pop();
                        },
                        child: const Text("Xoá"),
                      ),
                    ),
                  ]),
            ));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var textColor = Theme.of(context).primaryTextTheme.bodySmall?.color;

    TemperatureUnit tempUnit =
        Provider.of<SettingProvider>(context).getTempUnit;
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColorLight,
        ),
        child: FutureBuilder(
            future: _locationList,
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                case ConnectionState.waiting:
                  return const CircularProgressIndicator();
                case ConnectionState.active:
                case ConnectionState.done:
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Vị trí của bạn',
                          style: GoogleFonts.lato(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                        SizedBox(height: 10.h),
                        Expanded(
                            child: ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onLongPress: () {
                                showBottomSheet1(context, index);
                              },
                              onTap: () {
                                Provider.of<SettingProvider>(context,
                                        listen: false)
                                    .changeLocation(snapshot.data![index]);
                                Navigator.of(context)
                                    .pushReplacement(MaterialPageRoute(
                                  builder: (context) => const HiddenDrawer(),
                                ));
                              },
                              child: Container(
                                  margin: EdgeInsets.symmetric(vertical: 4.h),
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
                                        color:
                                            Theme.of(context).primaryColorDark,
                                        offset: const Offset(2.0, 2.0),
                                        blurRadius: 6.0,
                                      )
                                    ],
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  height: 85.h,
                                  child: Container(
                                    margin: EdgeInsets.symmetric(
                                      horizontal: 8.w,
                                    ),
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Row(
                                                children: [
                                                  const Icon(
                                                    Icons.location_on,
                                                    color: Colors.red,
                                                  ),
                                                  Text(
                                                      snapshot.data![index]
                                                          .split('-')[0],
                                                      style: GoogleFonts.lato(
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: textColor)),
                                                ],
                                              ),
                                              SizedBox(height: 4.h),
                                              Text(
                                                  snapshot.data![index]
                                                      .split('-')[1],
                                                  style: GoogleFonts.lato(
                                                      fontSize: 12,
                                                      color: textColor)),
                                            ],
                                          ),
                                          const Spacer(),
                                          FutureBuilder(
                                            future: fetchWeatherData(
                                                snapshot.data![index]),
                                            builder: (context, snapshot) {
                                              if (snapshot.connectionState ==
                                                  ConnectionState.done) {
                                                final currentTempC =
                                                    "${snapshot.data?.current?.tempC?.toStringAsFixed(0)}°";
                                                final currentTempF =
                                                    "${snapshot.data?.current?.tempF?.toStringAsFixed(0)}°";
                                                final minTempC =
                                                    "${snapshot.data?.forecast?.forecastday![0].day?.mintempC?.toStringAsFixed(0)}°";
                                                final minTempF =
                                                    "${snapshot.data?.forecast?.forecastday![0].day?.mintempF?.toStringAsFixed(0)}°";
                                                final maxTempC =
                                                    "${snapshot.data?.forecast?.forecastday![0].day?.maxtempC?.toStringAsFixed(0)}°";
                                                final maxTempF =
                                                    "${snapshot.data?.forecast?.forecastday![0].day?.maxtempF?.toStringAsFixed(0)}°";
                                                return Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Image.network(
                                                              "http:${snapshot.data?.current?.condition?.icon}",
                                                              fit: BoxFit.cover,
                                                              width: 48.w,
                                                              height: 48.w,
                                                              errorBuilder: (BuildContext
                                                                      context,
                                                                  Object
                                                                      exception,
                                                                  StackTrace?
                                                                      stackTrace) {
                                                            return Text(exception
                                                                .toString());
                                                          }),
                                                          Text(
                                                            tempUnit ==
                                                                    TemperatureUnit
                                                                        .celsius
                                                                ? currentTempC
                                                                : currentTempF,
                                                            style: GoogleFonts.lato(
                                                                fontSize: 18,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color:
                                                                    textColor),
                                                          )
                                                        ],
                                                      ),
                                                      Row(children: [
                                                        Text(
                                                          tempUnit ==
                                                                  TemperatureUnit
                                                                      .celsius
                                                              ? "$maxTempC / $minTempC"
                                                              : "$maxTempF / $minTempF",
                                                          style:
                                                              GoogleFonts.lato(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  color:
                                                                      textColor),
                                                        ),
                                                      ]),
                                                    ]);
                                              } else {
                                                return const CircularProgressIndicator();
                                              }
                                            },
                                          ),
                                        ]),
                                  )),
                            );
                          },
                        )),
                      ],
                    );
                  }
              }
            }),
      ),
    );
  }
}
