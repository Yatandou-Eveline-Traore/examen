import 'package:examen/constants/constants.dart';
import 'package:examen/pages/get_started.page.dart';
import 'package:examen/pages/home.page.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DetailPage extends StatefulWidget {
  final List consolidatedWeatherList;
  final int selectedId;
  final String location;

  const DetailPage({super.key,
   required this.consolidatedWeatherList,
   required this.selectedId,
   required this.location,});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  String imageUrl = '';

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    //Création un dégradé linéaire shader
    final Shader linearGradient = const LinearGradient(
      colors: <Color>[Color(0xffABCFF2), Color(0xff9AC6F3)],
    ).createShader(const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));
    int selectedIndex = widget.selectedId;

    print(
        'widget.consolidatedWeatherList[selectedIndex]::::: ${widget.consolidatedWeatherList[selectedIndex]['hour']}');
    var weatherStateName = widget.consolidatedWeatherList[selectedIndex]['day']
        ['condition']['text'];
    imageUrl = weatherStateName.replaceAll(' ', '').toLowerCase();
    var last_updated = '${DateTime.now().hour}:00';

    var currentHour = last_updated.split(' ').last.split(':').first;
    if (currentHour.length == 1){
      currentHour = '0$currentHour';
    }
    print('currentHour::: $last_updated -- $currentHour');
    var hour = (widget.consolidatedWeatherList[selectedIndex]['hour'] as List)
        .firstWhere(
      (element) {
        var t = '${element['time']}'.split(' ').last.split(':').first;
        print('::::::: $t');
        return t == currentHour;
      },
      orElse: () => null,
    );

    print('hour::::;;::;;:: $hour');

    return Scaffold(
      backgroundColor: Constants.secondary,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Constants.secondary,
        elevation: 0.0,
        title: Text(widget.location),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const Welcome()));
                },
                icon: const Icon(Icons.settings)),
          )
        ],
      ),
      body: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          Positioned(
            top: 10,
            left: 10,
            child: SizedBox(
              height: 150,
              width: 400,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: widget.consolidatedWeatherList.length,
                  itemBuilder: (BuildContext context, int index) {
                    var futureWeatherName =
                        widget.consolidatedWeatherList[selectedIndex]['day']
                            ['condition']['text'];
                    var weatherURL =
                        futureWeatherName.replaceAll(' ', '').toLowerCase();

                    var parsedDate = DateTime.parse(
                        widget.consolidatedWeatherList[index]['date']);
                    var newDate =
                        DateFormat('EEEE').format(parsedDate).substring(0, 3);

                    return Container(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      margin: const EdgeInsets.only(right: 20),
                      width: 80,
                      decoration: BoxDecoration(
                          color: index == selectedIndex
                              ? Colors.white
                              : const Color(0xff9ebcf9),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                          boxShadow: [
                            BoxShadow(
                              offset: const Offset(0, 1),
                              blurRadius: 5,
                              color: Colors.blue.withOpacity(.3),
                            )
                          ]),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            hour['temp_c'].round().toString() + "C",
                            style: TextStyle(
                              fontSize: 17,
                              color: index == selectedIndex
                                  ? Colors.blue
                                  : Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Image.network(
                            'https:' + hour['condition']['icon'],
                            width: 30,
                            // height: 10,
                          ),
                          Text(
                            newDate,
                            style: TextStyle(
                              fontSize: 17,
                              color: index == selectedIndex
                                  ? Colors.blue
                                  : Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            child: Container(
              height: size.height * .55,
              width: size.width,
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(50),
                    topLeft: Radius.circular(50),
                  )),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned(
                    top: -50,
                    right: 20,
                    left: 20,
                    child: Container(
                      width: size.width * .7,
                      height: 300,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.center,
                              colors: [
                                Color(0xffa9c1f5),
                                Color(0xff6696f5),
                              ]),
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blue.withOpacity(.1),
                              offset: const Offset(0, 25),
                              blurRadius: 3,
                              spreadRadius: -10,
                            ),
                          ]),
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Positioned(
                            top: -40,
                            left: 20,
                            child: Image.network(
                              'https:' + hour['condition']['icon'],
                              width: 30,
                              // height: 10,
                            ),
                          ),
                          Positioned(
                              top: 120,
                              left: 30,
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 10.0),
                                child: Text(
                                  weatherStateName,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                  ),
                                ),
                              )),
                          Positioned(
                            bottom: 20,
                            left: 20,
                            child: Container(
                              width: size.width * .8,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  weatherItem(
                                    text: 'Wind Speed',
                                    value: hour['wind_kph'].round(),
                                    unit: 'km/h',
                                    imageUrl: 'assets/windspeed.png',
                                  ),
                                  weatherItem(
                                      text: 'Humidity',
                                      value: hour['humidity'].round(),
                                      unit: '',
                                      imageUrl: 'assets/humidity.png'),
                                  weatherItem(
                                    text: 'Max Temp',
                                    value: widget
                                        .consolidatedWeatherList[selectedIndex]
                                            ['day']['maxtemp_c']
                                        .round(),
                                    unit: 'C',
                                    imageUrl: 'assets/max-temp.png',
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            top: 20,
                            right: 20,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  hour['temp_c'].round().toString(),
                                  style: TextStyle(
                                    fontSize: 80,
                                    fontWeight: FontWeight.bold,
                                    foreground: Paint()
                                      ..shader = linearGradient,
                                  ),
                                ),
                                Text(
                                  'o',
                                  style: TextStyle(
                                    fontSize: 40,
                                    fontWeight: FontWeight.bold,
                                    foreground: Paint()
                                      ..shader = linearGradient,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                      top: 300,
                      left: 20,
                      child: SizedBox(
                        height: 200,
                        width: size.width * .9,
                        child: ListView.builder(
                            scrollDirection: Axis.vertical,
                            itemCount: widget.consolidatedWeatherList.length,
                            itemBuilder: (BuildContext context, int index) {
                              print(
                                  'widget.consolidatedWeatherList:::: ${widget.consolidatedWeatherList[index]['day']}');
                              var futureWeatherName =
                                  widget.consolidatedWeatherList[index]['day']
                                      ['condition']['text'];
                              var futureImageURL = futureWeatherName
                                  .replaceAll(' ', '')
                                  .toLowerCase();
                              var myDate = DateTime.parse(widget
                                  .consolidatedWeatherList[index]['date']);
                              var currentDate =
                                  DateFormat('d MMMM, EEEE').format(myDate);
                              return Container(
                                margin: const EdgeInsets.only(
                                    left: 10, top: 10, right: 10, bottom: 5),
                                height: 80,
                                width: size.width,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10)),
                                    boxShadow: [
                                      BoxShadow(
                                        color:
                                            Constants.secondary.withOpacity(.1),
                                        spreadRadius: 5,
                                        blurRadius: 20,
                                        offset: const Offset(0, 3),
                                      ),
                                    ]),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        currentDate,
                                        style: const TextStyle(
                                          color: Color(0xff6696f5),
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            widget
                                                .consolidatedWeatherList[index]
                                                    ['day']['maxtemp_c']
                                                .round()
                                                .toString(),
                                            style: const TextStyle(
                                              color: Colors.grey,
                                              fontSize: 30,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          const Text(
                                            '/',
                                            style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 30,
                                            ),
                                          ),
                                          Text(
                                            widget
                                                .consolidatedWeatherList[index]
                                                    ['day']['mintemp_c']
                                                .round()
                                                .toString(),
                                            style: const TextStyle(
                                              color: Colors.grey,
                                              fontSize: 20,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Image.network(
                                            'https:' +
                                                widget.consolidatedWeatherList[
                                                        index]['day']
                                                    ['condition']['icon'],
                                            width: 30,
                                          ),
                                          Text(widget.consolidatedWeatherList[
                                                  index]['day']['condition']
                                              ['text']),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              );
                            }),
                      ))
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}