import 'dart:convert';

import 'package:examen/constants/constants.dart';
import 'package:examen/pages/detail.page.dart';
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
  String fallback = '';
  String city =
      'Bamako'; //C’est l’identifiant Where on Earth pour Bamako qui est notre ville par défaut
  String location = 'Bamako'; //Notre ville par défaut

  //Obtenir les données sur les villes et les villes sélectionnées
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
  ]; //la liste des villes que nous avons sélectionnées. Deafult, c’est Bamako
  List consolidatedWeatherList = []; //Pour conserver nos données météorologiques après l’appel d’API

  String baseUrl = 'https://api.weatherapi.com/v1/';

  int count = 0;

  void fetchLocation(String location) async {
    setState(() {
      city = location;
    });
  }

  void fetchWeatherData() async {
    try {
      //envoie une requête HTTP à une API de prévisions météorologiques
      var weatherResult = await http.get(Uri.parse(baseUrl +
          'forecast.json?key=e74f44a130034b81840193148250502&days=7&q=' +
          city));
      print('response:::: ${weatherResult.body}');
      var result = json.decode(weatherResult.body);
      var current = result['current'];
      var consolidatedWeather = result['forecast']['forecastday'] as List;
      print('result::::: $consolidatedWeather');

      setState(() {
        //extrait des valeurs météorologiques spécifiques à partir d'un objet JSON, 
        //les arrondit et les stocke dans des variables pour une utilisation ultérieure.
        count = consolidatedWeather.length;
        temperature = current['temp_c'].round();
        weatherStateName = current['condition']['text'];
        humidity = current['humidity'].round();
        windSpeed = current['wind_kph'].round();
        maxTemp = consolidatedWeather.first['day']['maxtemp_c'].round();

        //Formatage de la date
        last_updated = current['last_updated'];
        var myDate = DateTime.parse(current['last_updated']);
        currentDate = DateFormat('EEEE, d MMMM').format(myDate);

        //Définir l’URL de l’image
        imageUrl = weatherStateName.replaceAll(' ', '').toLowerCase();
        fallback = current['condition']['icon'];
        

        consolidatedWeatherList = consolidatedWeather
            .toSet()
            .toList(); //Remove any instances of dublicates from our
        //Liste météorologique consolidée
      });
    } catch (e, tr) {
      print('error:::: $e -- $tr');
    }
  }

  @override
  void initState() {
    fetchLocation(cities[0]);
    fetchWeatherData();

    //Pour toutes les villes sélectionnées dans notre modèle de ville,
    // extrayez la ville et ajoutez-la à notre liste de villes d’origine
    for (int i = 0; i < selectedCities.length; i++) {
      cities.add(selectedCities[i].city);
    }
    super.initState();
  }

  //Création d’un dégradé linéaire de shader
  final Shader linearGradient = const LinearGradient(
    colors: <Color>[Color(0xffABCFF2), Color(0xff9AC6F3)],
  ).createShader(const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));


  @override
  Widget build(BuildContext context) {
    //Créer une variable de taille pour la requête de média
    Size size = MediaQuery.of(context).size;
    
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,//Permet de dire à appBar de ne pas afficher le boutton automatique
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
              //Notre profile image
              ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                child: Icon(
                  Icons.person,
                  size: 40,
                ),
              ),
              //Notre liste déroulante de localisation
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
                  //Création du menu déroulante contenant les villes
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
                        : _asset,
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
            //affichage des humidité et vent
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  weatherItem(
                    text: 'Vitesse du vent',
                    value: windSpeed,
                    unit: 'km/h',
                    imageUrl: 'assets/windspeed.png',
                  ),
                  weatherItem(
                      text: 'Humidité',
                      value: humidity,
                      unit: '',
                      imageUrl: 'assets/humidity.png'),
                  weatherItem(
                    text: 'Vitesse du vent',
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
            
            //affichage de la partie today
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

                      // Extrait l'heure actuelle à partir d'une chaine de caractère
                      var currentHour =
                          last_updated.split(' ').last.split(':').first;//etrait l'heure actuelle
                      print('currentHour::: $currentHour');//debogue a console
                      var hour =
                          (consolidatedWeatherList[index]['hour'] as List)
                              .firstWhere(//rechercher l'heure correspondant
                        (element) {
                          var t = '${element['time']}'
                              .split(' ')
                              .last
                              .split(':')
                              .first;
                          return t == currentHour;
                        },
                        orElse: () => null,
                      );

                      return GestureDetector(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(
                                builder: (context) => DetailPage(
                                         consolidatedWeatherList:
                                             consolidatedWeatherList,
                                         selectedId: index,
                                         location: location,
                                       )));
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
                              ),  
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

  //renvoie une image différente selon la valeur de imageUrl
  Widget get _asset {
    try {
      print('_asset====== $imageUrl -- $fallback');
      if (imageUrl == 'partlycloudy') {
        return Image.network(
          'https:' + fallback,
          width: 150,
        );
      }
      return Image.asset(
        'assets/' + imageUrl + '.png',
        width: 150,
      );
    } catch (e) {
      print('_asset======error $e');
      return Image.network(
        'https:' + fallback,
        width: 150,
      );
    }
  }
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
          height: 8,//Ajoute un autre espacement vertical de 8 pixels
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
          height: 8,//Ajoute un autre espacement vertical de 8 pixels
        ),
        //affiche par exemple 25°C
        Text(
          value.toString() + unit,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        )
      ],
    );
  }

Widget asset(String img, String fallback) {
  try {
    return Image.asset(
      'assets/' + img + '.png',
      width: 150,
    );
  } catch (e) {
    return Image.network(
      'https:' + fallback,
      width: 150,//permet de charger une image sur URL
    );
  }
}



