import 'package:country_list_pick/diacritic/diacritic.dart';
import 'package:intl/intl.dart';

import 'country_utils.dart';

class Country {
  final String name;
  final String isoCode;
  final String iso3Code;
  final String phoneCode;
  final String currencyCode;
  final String currencyName;
  final String? continent;
  final String? capital;

  Country({
    required this.isoCode,
    required this.iso3Code,
    required this.phoneCode,
    required this.name,
    required this.currencyCode,
    required this.currencyName,
    this.continent,
    this.capital,
  });

  // factory Country.fromMap(Map<String, String> map) => Country(
  //       name: map['name'],
  //       isoCode: map['isoCode'],
  //       iso3Code: map['iso3Code'],
  //       phoneCode: map['phoneCode'],
  //       currencyCode: map['currencyCode'],
  //       currencyName: map['currencyName'],
  //       continent: map['continent'],
  //       capital: map['capital'],
  //     );

  String get currencySymbol => NumberFormat().simpleCurrencySymbol(currencyCode);

  String get flagUri => CountryUtils.getFlagImageAssetPath(isoCode);

  String toCountryStringOnly() => '$name';

  String genSearchQuery(bool isCurrency) {
    final search = '$isoCode$phoneCode$name${isCurrency ? currencyCode : ''}';
    return removeDiacritics(search).toLowerCase();
  }

  bool filterWith(String query, {bool isCurrency = false}) {
    return genSearchQuery(isCurrency).contains(removeDiacritics(query).toLowerCase());
  }
}
