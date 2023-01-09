import 'package:country_list_pick/diacritic/diacritic.dart';

/// Country element. This is the element that contains all the information
class CountryCode {
  /// the name of the country
  final String name;

  /// the flag of the country
  final String flagUri;

  /// the country code (IT,AF..)
  final String code;

  /// the dial code (+39,+93..)
  final String dialCode;

  CountryCode({
    required this.name,
    required this.flagUri,
    required this.code,
    required this.dialCode,
  });

  @override
  String toString() => "$dialCode";

  String toLongString() => "$dialCode $name";

  String toCountryStringOnly() => '$name';

  String genSearchQuery() {
    final search = '$code$dialCode$name';
    return removeDiacritics(search).toLowerCase();
  }

  bool filterWith(String query) {
    return genSearchQuery().contains(removeDiacritics(query).toLowerCase());
  }
}
