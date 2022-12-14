import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/models/icon_reference.dart';
import 'package:weather_app/utility/weather_from_url.dart';
import 'package:weather_app/views/settings_page.dart';

import '../models/Settings.dart';
import '../models/more_page_chart.dart';

/// A stateful widget that displays weather details and allows users
/// to view chart data by tapping an entry in its ListView
class MorePage extends StatefulWidget {
  const MorePage({Key? key}) : super(key: key);

  @override
  State<MorePage> createState() => _MorePageState();
}

class _MorePageState extends State<MorePage> {
  @override
  Widget build(BuildContext context) {
    SettingsBLoC settingsBLoC = context.watch<SettingsBLoC>();
    WeatherBLoC weatherBLoC = context.watch<WeatherBLoC>();
    return Scaffold(
      appBar: AppBar(
        title: Text(FlutterI18n.translate(context, "app.title")),
        elevation: 3,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: FutureBuilder(
            future: weatherBLoC.initializeList(),
            builder: (context, snapshot) {
              return snapshot.hasData
              ? ListView.separated(
                itemCount: 13,
                itemBuilder: (content, index) {
                  return settingsBLoC.userSettings[index] == false
                  ? Container()
                  : GestureDetector(
                      onTap: () {
                        _openChart(index);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                child: Icon(
                                  IconReference.moreIcons[index],
                                  size: 25,
                                ),
                              ),
                              Text(
                                FlutterI18n.translate(context, "more.${settings.settingNames[index]}"),
                                style: const TextStyle(fontSize: 18),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Text(
                                "${
                                    (weather == null || weather!.whenCreated == null) ?
                                    "" :
                                    weather!.getWeatherDetails(index)
                                      [weather!.whenCreated!.hour]
                                }"
                                "${
                                    (weather == null || weather!.whenCreated == null) ?
                                    "" :
                                    weather!.getWeatherUnit(index)
                                }",
                                style: const TextStyle(
                                  fontSize: 18
                                ),
                            ),
                          ),
                        ],
                      ),
                  );
                }, separatorBuilder: (BuildContext context, int index)
                      =>  settingsBLoC.userSettings[index] == false
                          ? Container()
                          : const Divider(),
              )
              : const Center(child: CircularProgressIndicator());
            }
        ),
      ),
    );
  }

  Future<void> _openChart(int index) async {
    /// Opens an AlertDialog showing chart and
    /// @param index corresponding to a ListViewEntry that was tapped
    /// @return A Future<void> which will return null when the alert is dismissed
    return showDialog<void>(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return AlertDialog(
            title: Text("${FlutterI18n.translate(context, "more.${settings.settingNames[index]}")} ${FlutterI18n.translate(context, "more.data")}"),
            content: MorePageChart(index: index),
          );
        },
    );
  }
}

