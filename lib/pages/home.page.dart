import 'dart:convert';

import 'package:examen/constants/constants.dart';
import 'package:examen/services/city.service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //initialisation
  int temperature = 0;
  int maxTemp = 0;
  String weatherStateName = 'Loading..';
  int humidity = 0;
  int windSpeed = 0;

  var currentDate = 'Loading..';
  var last_updated = '${DateTime.now().hour}:00';
  String imageUrl = '';
  String city =
      'Bamako'; //This is the Where on Earth Id for London which is our default city
  String location = 'Bamako'; //Our default city

  //get the cities and selected cities data
  var selectedCities = City.selected;
  List<String> cities = [
    'Bamako',
    'Kayes',
    'Koulikoro',
    'Sikasso',
    'Segou',
    'Mopti',
    'Tombouctou',
    'Gao',
    'Kidal',
    'Menaka',
    'Nioro',
    'Kita',
    'Dioïla',
    'Nara',
    'Bougouni',
    'Koutiala',
    'San',
    'Douentza',
    'Bandiagara',
  ]; //the list to hold our selected cities. Deafult is London

  List consolidatedWeatherList = []; //To hold our weather data after api call

  String baseUrl = 'https://api.weatherapi.com/v1/';

  int count = 0;

  void fetchLocation(String location) async {
    setState(() {
      city = location;
    });
  }

  void fetchWeatherData() async {
    try {
      var weatherResult = await http.get(Uri.parse(baseUrl +
          'forecast.json?key=e74f44a130034b81840193148250502&days=7&q=' +
          city));
      print('response:::: ${weatherResult.body}');
      var result = json.decode(weatherResult.body);
      var current = result['current'];
      var consolidatedWeather = result['forecast']['forecastday'] as List;
      print('result::::: $consolidatedWeather');

      setState(() {
        count = consolidatedWeather.length;
        // for (int i = 0; i < 7; i++) {
        //   consolidatedWeather.add(consolidatedWeather[
        //       i]); //this takes the consolidated weather for the next six days for the location searched
        // }
        //The index 0 referes to the first entry which is the current day. The next day will be index 1, second day index 2 etc...
        temperature = current['temp_c'].round();
        weatherStateName = current['condition']['text'];
        humidity = current['humidity'].round();
        windSpeed = current['wind_kph'].round();
        maxTemp = consolidatedWeather.first['day']['maxtemp_c'].round();

        //date formatting
        last_updated = current['last_updated'];
        var myDate = DateTime.parse(current['last_updated']);
        currentDate = DateFormat('EEEE, d MMMM').format(myDate);

        //set the image url
        imageUrl = weatherStateName
            .replaceAll(' ', '')
            .toLowerCase(); //remove any spaces in the weather state name
        //and change to lowercase because that is how we have named our images.

        consolidatedWeatherList = consolidatedWeather
            .toSet()
            .toList(); //Remove any instances of dublicates from our
        //consolidated weather LIST
      });
    } catch (e, tr) {
      print('error:::: $e -- $tr');
    }
  }

  @override
  void initState() {
    fetchLocation(cities[0]);
    fetchWeatherData();

    //For all the selected cities from our City model, extract the city and add it to our original cities list
    for (int i = 0; i < selectedCities.length; i++) {
      cities.add(selectedCities[i].city);
    }
    super.initState();
  }

  //Create a shader linear gradient
  final Shader linearGradient = const LinearGradient(
    colors: <Color>[Color(0xffABCFF2), Color(0xff9AC6F3)],
  ).createShader(const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));


  @override
  Widget build(BuildContext context) {
    //Create a size variable for the mdeia query
    Size size = MediaQuery.of(context).size;
    
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: false,
        titleSpacing: 0,
        backgroundColor: Colors.white,
        elevation: 0.0,
        title: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          width: size.width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              //Our profile image
              ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                // child: Image.asset(
                //   'assets/profile.png',
                //   width: 40,
                //   height: 40,
                // ),
                child: Icon(
                  Icons.person,
                  size: 40,
                ),
              ),
              //our location dropdown
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/pin.png',
                    width: 20,
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                  DropdownButtonHideUnderline(
                    child: DropdownButton(
                        value: location,
                        icon: const Icon(Icons.keyboard_arrow_down),
                        items: cities.map((String location) {
                          return DropdownMenuItem(
                              value: location, child: Text(location));
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            location = newValue!;
                            fetchLocation(location);
                            fetchWeatherData();
                          });
                        }),
                  )
                ],
              )
            ],
          ),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              location,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 30.0,
              ),
            ),
            Text(
              currentDate,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 16.0,
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            Container(
              width: size.width,
              height: 200,
              decoration: BoxDecoration(
                  color: Constants.primary,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Constants.primary.withOpacity(.5),
                      offset: const Offset(0, 25),
                      blurRadius: 10,
                      spreadRadius: -12,
                    )
                  ]),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned(
                    top: -40,
                    left: 20,
                    child: imageUrl == ''
                        ? const Text('')
                        : Image.asset(
                            'assets/' + imageUrl + '.png',
                            width: 150,
                          ),
                  ),
                  Positioned(
                    bottom: 30,
                    left: 20,
                    child: Text(
                      weatherStateName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 20,
                    right: 20,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Text(
                            temperature.toString(),
                            style: TextStyle(
                              fontSize: 80,
                              fontWeight: FontWeight.bold,
                              foreground: Paint()..shader = linearGradient,
                            ),
                          ),
                        ),
                        Text(
                          'o',
                          style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            foreground: Paint()..shader = linearGradient,
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  weatherItem(
                    text: 'Wind Speed',
                    value: windSpeed,
                    unit: 'km/h',
                    imageUrl: 'assets/windspeed.png',
                  ),
                  weatherItem(
                      text: 'Humidity',
                      value: humidity,
                      unit: '',
                      imageUrl: 'assets/humidity.png'),
                  weatherItem(
                    text: 'Wind Speed',
                    value: maxTemp,
                    unit: 'C',
                    imageUrl: 'assets/max-temp.png',
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Today',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
                Text(
                  'Next $count Days',
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                      color: Constants.primary),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: consolidatedWeatherList.length,
                    itemBuilder: (BuildContext context, int index) {
                      String today = DateTime.now().toString().substring(0, 10);
                      var selectedDay = consolidatedWeatherList[index]['date'];
                      var futureWeatherName = consolidatedWeatherList[index]
                          ['day']['condition']['text'];
                      // ignore: unused_local_variable
                      var weatherUrl =
                          futureWeatherName.replaceAll(' ', '').toLowerCase();

                      var parsedDate = DateTime.parse(
                          consolidatedWeatherList[index]['date']);
                      var newDate = DateFormat('EEEE')
                          .format(parsedDate)
                          .substring(0, 3); //formateed date

                      var currentHour =
                          last_updated.split(' ').last.split(':').first;
                      print('currentHour::: $currentHour');
                      var hour =
                          (consolidatedWeatherList[index]['hour'] as List)
                              .firstWhere(
                        (element) {
                          var t = '${element['time']}'
                              .split(' ')
                              .last
                              .split(':')
                              .first;
                          print('hour:::: $t');
                          return t == currentHour;
                        },
                        orElse: () => null,
                      );

                      return GestureDetector(
                        onTap: () {
                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (context) => DetailPage(
                          //               consolidatedWeatherList:
                          //                   consolidatedWeatherList,
                          //               selectedId: index,
                          //               location: location,
                          //             )));
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          margin: const EdgeInsets.only(
                              right: 20, bottom: 10, top: 10),
                          width: 80,
                          decoration: BoxDecoration(
                              color: selectedDay == today
                                  ? Constants.primary
                                  : Colors.white,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10)),
                              boxShadow: [
                                BoxShadow(
                                  offset: const Offset(0, 1),
                                  blurRadius: 5,
                                  color: selectedDay == today
                                      ? Constants.primary
                                      : Colors.black54.withOpacity(.2),
                                ),
                              ]),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                hour['temp_c'].round().toString() + "C",
                                style: TextStyle(
                                  fontSize: 17,
                                  color: selectedDay == today
                                      ? Colors.white
                                      : Constants.primary,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              // Image.asset(
                              //   'assets/' + weatherUrl + '.png',
                              //   width: 30,
                              // ),
                              Image.network(
                                'https:' + hour['condition']['icon'],
                                width: 30,
                                // height: 10,
                              ),
                              Text(
                                newDate,
                                style: TextStyle(
                                  fontSize: 17,
                                  color: selectedDay == today
                                      ? Colors.white
                                      : Constants.primary,
                                  fontWeight: FontWeight.w500,
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    }))
          ],
        ),
      ),
    );
  }

  Widget weatherItem({
    required String text,
    required int value,
    required String unit,
    required String imageUrl,
  }) {
    return Column(
      children: [
        Text(
          text,
          style: const TextStyle(
            color: Colors.black54,
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        Container(
          padding: const EdgeInsets.all(10.0),
          height: 60,
          width: 60,
          decoration: const BoxDecoration(
            color: Color(0xffE0E8FB),
            borderRadius: BorderRadius.all(Radius.circular(15)),
          ),
          child: Image.asset(imageUrl),
        ),
        const SizedBox(
          height: 8,
        ),
        Text(
          value.toString() + unit,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        )
      ],
    );
  }
}


