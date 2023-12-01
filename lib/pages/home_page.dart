import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:weather/components/current_weather.dart';
import 'package:weather/model/weather.dart';
import 'package:weather/pages/search_page.dart';
import 'package:weather/providers/setting_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    String? currentLocation =
        Provider.of<SettingProvider>(context).getCurrentLocation;
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor.withOpacity(0.3),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {});
        },
        child: ListView(
          children: [
            currentLocation != null
                ? FutureBuilder(
                    future: fetchWeatherData(currentLocation),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Container(
                          width: double.infinity,
                          height: 1.sh,
                          padding: EdgeInsets.all(50.h),
                          child:
                              const Center(child: CircularProgressIndicator()),
                        );
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else {
                        final weatherData = snapshot.data;
                        if (weatherData != null) {
                          return Container(
                              decoration: BoxDecoration(
                                color: Theme.of(context).primaryColorLight,
                              ),
                              child: CurrentWeather(snapshot: snapshot));
                        } else {
                          return const Text('No weather data available.');
                        }
                      }
                    })
                : Center(
                    child: SizedBox(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height - 100.h,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Thêm vị trí của bạn",
                            style: TextStyle(fontSize: 16.sp),
                          ),
                          SizedBox(
                            height: 25.h,
                          ),
                          const Icon(
                            Icons.location_on,
                            size: 36,
                            color: Colors.red,
                          ),
                          SizedBox(
                            height: 25.h,
                          ),
                          MaterialButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const SearchPage(),
                                  ));
                            },
                            padding: EdgeInsets.all(8.w),
                            color: Theme.of(context)
                                .buttonTheme
                                .colorScheme!
                                .background,
                            child: const Text(
                                "Nhấn vào đây để thêm vị trí của bạn"),
                          )
                        ],
                      ),
                    ),
                  )
          ],
        ),
      ),
    );
  }
}
