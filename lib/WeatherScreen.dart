import 'dart:convert';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/components/additionalinfo.dart';
import 'package:weather_app/components/hourlyforecastitem.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/components/secrets.dart';

class Weatherscreen extends StatefulWidget {
  const Weatherscreen({super.key});

  @override
  State<Weatherscreen> createState() => _WeatherscreenState();
}

class _WeatherscreenState extends State<Weatherscreen> {
  Future<Map<String, dynamic>> getCurrentWeather() async {
    try {
      String cityName = 'London';
      final res = await http.get(
        Uri.parse(
            'https://api.openweathermap.org/data/2.5/forecast?q=$cityName&APPID=$openWeatherApiKey'),
      );
      final data = jsonDecode(res.body);
      if (data['cod'] != '200') {
        throw "An unexpected error occured";
      }
      //
      return data;
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Weather App',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                setState(() {});
              },
              icon: const Icon(Icons.refresh))
        ],
      ),
      body: FutureBuilder(
          future: getCurrentWeather(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator.adaptive());
            }
            if (snapshot.hasError) {
              return const Center(child: Text('An unexpected error occured'));
            }
            final data = snapshot.data;
            final currentWeatherData = data?['list'][0];
            final currentTemp = currentWeatherData['main']['temp'];
            final currentSky = currentWeatherData['weather'][0]['main'];
            final humidity = currentWeatherData['main']['humidity'];
            final pressure = currentWeatherData['main']['pressure'];
            final windSpeed = currentWeatherData['wind']['speed'];

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: Card(
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                Text(
                                  '$currentTemp K',
                                  style: const TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                                Icon(
                                  currentSky == 'Clouds' || currentSky == "Rain"
                                      ? Icons.cloud
                                      : Icons.sunny,
                                  size: 64,
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  '$currentSky',
                                  style: const TextStyle(fontSize: 20),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    "Weather Forecast",
                    style: TextStyle(fontSize: 24),
                  ),
                  SizedBox(
                    height: 120,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 5,
                      itemBuilder: (context, index) {
                        final hourlyForecast = data?['list'][index + 1];
                        final time = DateTime.parse(hourlyForecast['dt_txt']);
                        return HourlyForeCastItem(
                            time: DateFormat.Hm().format(time),
                            icon: hourlyForecast['weather'][0]['main'] ==
                                        'Cloudl' ||
                                    hourlyForecast['weather'][0]['main'] ==
                                        'Rain'
                                ? Icons.cloud
                                : Icons.sunny,
                            temperature:
                                hourlyForecast['main']['temp'].toString());
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    "Additional Information",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Additionalinfo(
                          icon: Icons.water_drop,
                          label: "Humidity",
                          value: '$humidity'),
                      Additionalinfo(
                          icon: Icons.air,
                          label: "Wind Speed",
                          value: '$windSpeed'),
                      Additionalinfo(
                          icon: Icons.beach_access,
                          label: "Pressure",
                          value: '$pressure')
                    ],
                  )
                ],
              ),
            );
          }),
    );
  }
}
