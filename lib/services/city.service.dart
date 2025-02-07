class City {
  bool isSelected;
  final String city;
  final String country;
  final bool isDefault;

  City(
      {required this.isSelected,
      required this.city,
      required this.country,
      required this.isDefault});

  //La liste des villes
  static List<City> citiesList = [
    City(
      isSelected: false,
      city: 'Bamako',
      country: 'Kita',
      isDefault: true,
    ),
    City(isSelected: false, city: 'Kayes', country: 'Koulikoro', isDefault: false),
    City(isSelected: false, city: 'Sikasso', country: 'Segou', isDefault: false),
    City(
        isSelected: false, city: 'Mopti', country: 'Tombouctou', isDefault: false),
    City(isSelected: false, city: 'Gao', country: 'Kidal', isDefault: false),
    City(isSelected: false, city: 'Menaka', country: 'Nioro', isDefault: false),
    City(
        isSelected: false, city: 'Kita', country: 'Dioïla', isDefault: false),
    City(
        isSelected: false,
        city: 'Nara',
        country: 'Bougouni',
        isDefault: false),
    City(
        isSelected: false,
        city: 'Koutiala',
        country: 'San',
        isDefault: false),
    City(
        isSelected: false,
        city: 'Douenza',
        country: 'Bandiagara',
        isDefault: false),
    
  ];

  //recupération des viles sélectionnées
  static List<City> get selected {
    List<City> selectedCities = City.citiesList;
    return selectedCities.where((city) => city.isSelected == true).toList();
  }
}
