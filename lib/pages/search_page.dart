import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:weather/model/search_respone.dart';
import 'package:weather/providers/setting_provider.dart';
import '../components/hidden_drawer.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _textController = TextEditingController();
  Timer? _debounce;
  Future<List<SearchRespone>> _searchData = fetchSearch(" ");

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).primaryTextTheme.bodySmall?.color;
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColorLight,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: true,
        title: Text(
          "Tìm kiếm vị trí / thành phố",
          style: TextStyle(fontSize: 16.sp),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            TextField(
              onChanged: (value) async {
                if (_debounce != null) {
                  _debounce!.cancel();
                }
                _debounce = Timer(const Duration(milliseconds: 500), () {
                  // Handle the debounced input here
                  if (value == "") return;
                  Future<List<SearchRespone>> myData = fetchSearch(value);
                  setState(() {
                    _searchData = myData;
                  });
                });
              },
              controller: _textController,
              decoration: InputDecoration(
                hintText: "Nhập vị trí cần tìm",
                suffix: GestureDetector(
                  onTap: () {},
                  child: const Icon(Icons.search),
                ),
              ),
            ),
            SizedBox(
              height: 10.h,
            ),
            FutureBuilder(
              future: _searchData,
              builder: (context, snapshot) => SizedBox(
                height: 500.h,
                child: ListView.builder(
                  itemCount: snapshot.data != null ? snapshot.data!.length : 0,
                  itemBuilder: (context, index) {
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      final searchData = snapshot.data;
                      if (searchData != null) {
                        final itemColor = Theme.of(context).primaryColor;
                        return GestureDetector(
                          onTap: () {
                            Provider.of<SettingProvider>(context, listen: false)
                                .changeLocation(
                                    "${searchData[index].name} - ${searchData[index].country!}");
                            Navigator.of(context)
                                .pushReplacement(MaterialPageRoute(
                              builder: (context) => const HiddenDrawer(),
                            ));
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 20.h, horizontal: 8.w),
                            margin: EdgeInsets.symmetric(vertical: 2.h),
                            decoration: BoxDecoration(
                                color: itemColor,
                                borderRadius: BorderRadius.circular(8)),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.location_on,
                                  color: Colors.red,
                                ),
                                Text(
                                  "${searchData[index].name!} - ${searchData[index].country!}",
                                  style: TextStyle(color: textColor),
                                ),
                              ],
                            ),
                          ),
                        );
                      } else {
                        return const Text('No weather data available.');
                      }
                    }
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
