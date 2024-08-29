import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:live_yoko/Global/Constant.dart';
import 'package:live_yoko/Utils/Utils.dart';

class LanguageSettingsController extends GetxController {
  RxInt selectLanguuage = 0.obs;
  RxInt selectTranslationLanguage = 0.obs;
  List<Nation> listNation = [
    Nation(
        src: 'asset/icons/flag_english.svg', title: 'English (US)', code: 'US'),
    Nation(src: 'asset/icons/flag_vietnam.svg', title: 'Vietnam', code: 'VN'),
    Nation(src: 'asset/icons/flag_china.svg', title: 'China', code: 'CN')
  ];
  RxString selectTranslateName = ''.obs;
  RxBool isNull = false.obs;
  RxInt selectTransCode = 0.obs;
  static Map<String, String> countryTranslations = {
    'AD': 'ca', // Andorra
    'AE': 'ar', // United Arab Emirates
    'AF': 'fa', // Afghanistan
    'AG': 'en', // Antigua and Barbuda
    'AI': 'en', // Anguilla
    'AL': 'sq', // Albania
    'AM': 'hy', // Armenia
    'AO': 'pt', // Angola
    'AQ': 'es', // Antarctica
    'AR': 'es', // Argentina
    'AS': 'en', // American Samoa
    'AT': 'de', // Austria
    'AU': 'en', // Australia
    'AW': 'nl', // Aruba
    'AX': 'sv', // Åland Islands
    'AZ': 'az', // Azerbaijan
    'BA': 'bs', // Bosnia and Herzegovina
    'BB': 'en', // Barbados
    'BD': 'bn', // Bangladesh
    'BE': 'nl', // Belgium
    'BF': 'fr', // Burkina Faso
    'BG': 'bg', // Bulgaria
    'BH': 'ar', // Bahrain
    'BI': 'fr', // Burundi
    'BJ': 'fr', // Benin
    'BL': 'fr', // Saint Barthélemy
    'BM': 'en', // Bermuda
    'BN': 'ms', // Brunei Darussalam
    'BO': 'es', // Bolivia (Plurinational State of)
    'BQ': 'nl', // Bonaire, Sint Eustatius and Saba
    'BR': 'pt', // Brazil
    'BS': 'en', // Bahamas
    'BT': 'dz', // Bhutan
    'BV': 'en', // Bouvet Island
    'BW': 'en', // Botswana
    'BY': 'be', // Belarus
    'BZ': 'en', // Belize
    'CA': 'en', // Canada
    'CC': 'en', // Cocos (Keeling) Islands
    'CD': 'fr', // Congo (Democratic Republic of the)
    'CF': 'fr', // Central African Republic
    'CG': 'fr', // Congo
    'CH': 'de', // Switzerland
    'CI': 'fr', // Côte d'Ivoire
    'CK': 'en', // Cook Islands
    'CL': 'es', // Chile
    'CM': 'fr', // Cameroon
    'CN': 'zh', // China
    'CO': 'es', // Colombia
    'CR': 'es', // Costa Rica
    'CU': 'es', // Cuba
    'CV': 'pt', // Cabo Verde
    'CW': 'nl', // Curaçao
    'CX': 'en', // Christmas Island
    'CY': 'el', // Cyprus
    'CZ': 'cs', // Czechia
    'DE': 'de', // Germany
    'DJ': 'fr', // Djibouti
    'DK': 'da', // Denmark
    'DM': 'en', // Dominica
    'DO': 'es', // Dominican Republic
    'DZ': 'ar', // Algeria
    'EC': 'es', // Ecuador
    'EE': 'et', // Estonia
    'EG': 'ar', // Egypt
    'EH': 'ar', // Western Sahara
    'ER': 'ti', // Eritrea
    'ES': 'es', // Spain
    'ET': 'am', // Ethiopia
    'FI': 'fi', // Finland
    'FJ': 'en', // Fiji
    'FK': 'en', // Falkland Islands (Malvinas)
    'FM': 'en', // Micronesia (Federated States of)
    'FO': 'fo', // Faroe Islands
    'FR': 'fr', // France
    'GA': 'fr', // Gabon
    'GB': 'en', // United Kingdom of Great Britain and Northern Ireland
    'GD': 'en', // Grenada
    'GE': 'ka', // Georgia
    'GF': 'fr', // French Guiana
    'GG': 'en', // Guernsey
    'GH': 'en', // Ghana
    'GI': 'en', // Gibraltar
    'GL': 'kl', // Greenland
    'GM': 'en', // Gambia
    'GN': 'fr', // Guinea
    'GP': 'fr', // Guadeloupe
    'GQ': 'es', // Equatorial Guinea
    'GR': 'el', // Greece
    'GS': 'en', // South Georgia and the South Sandwich Islands
    'GT': 'es', // Guatemala
    'GU': 'en', // Guam
    'GW': 'pt', // Guinea-Bissau
    'GY': 'en', // Guyana
    'HK': 'zh', // Hong Kong
    'HM': 'en', // Heard Island and McDonald Islands
    'HN': 'es', // Honduras
    'HR': 'hr', // Croatia
    'HT': 'fr', // Haiti
    'HU': 'hu', // Hungary
    'ID': 'id', // Indonesia
    'IE': 'ga', // Ireland
    'IL': 'he', // Israel
    'IM': 'en', // Isle of Man
    'IN': 'hi', // India
    'IO': 'en', // British Indian Ocean Territory
    'IQ': 'ar', // Iraq
    'IR': 'fa', // Iran (Islamic Republic of)
    'IS': 'is', // Iceland
    'IT': 'it', // Italy
    'JE': 'en', // Jersey
    'JM': 'en', // Jamaica
    'JO': 'ar', // Jordan
    'JP': 'ja', // Japan
    'KE': 'sw', // Kenya
    'KG': 'ky', // Kyrgyzstan
    'KH': 'km', // Cambodia
    'KI': 'en', // Kiribati
    'KM': 'ar', // Comoros
    'KN': 'en', // Saint Kitts and Nevis
    'KP': 'ko', // Korea (Democratic People's Republic of)
    'KR': 'ko', // Korea (Republic of)
    'KW': 'ar', // Kuwait
    'KY': 'en', // Cayman Islands
    'KZ': 'kk', // Kazakhstan
    'LA': 'lo', // Lao People's Democratic Republic
    'LB': 'ar', // Lebanon
    'LC': 'en', // Saint Lucia
    'LI': 'de', // Liechtenstein
    'LK': 'si', // Sri Lanka
    'LR': 'en', // Liberia
    'LS': 'en', // Lesotho
    'LT': 'lt', // Lithuania
    'LU': 'lb', // Luxembourg
    'LV': 'lv', // Latvia
    'LY': 'ar', // Libya
    'MA': 'ar', // Morocco
    'MC': 'fr', // Monaco
    'MD': 'ro', // Moldova (Republic of)
    'ME': 'sr', // Montenegro
    'MF': 'fr', // Saint Martin (French part)
    'MG': 'mg', // Madagascar
    'MH': 'en', // Marshall Islands
    'MK': 'mk', // Macedonia (the former Yugoslav Republic of)
    'ML': 'fr', // Mali
    'MM': 'my', // Myanmar
    'MN': 'mn', // Mongolia
    'MO': 'zh', // Macao
    'MP': 'en', // Northern Mariana Islands
    'MQ': 'fr', // Martinique
    'MR': 'ar', // Mauritania
    'MS': 'en', // Montserrat
    'MT': 'mt', // Malta
    'MU': 'fr', // Mauritius
    'MV': 'dv', // Maldives
    'MW': 'en', // Malawi
    'MX': 'es', // Mexico
    'MY': 'ms', // Malaysia
    'MZ': 'pt', // Mozambique
    'NA': 'en', // Namibia
    'NC': 'fr', // New Caledonia
    'NE': 'fr', // Niger
    'NF': 'en', // Norfolk Island
    'NG': 'en', // Nigeria
    'NI': 'es', // Nicaragua
    'NL': 'nl', // Netherlands
    'NO': 'no', // Norway
    'NP': 'ne', // Nepal
    'NR': 'en', // Nauru
    'NU': 'en', // Niue
    'NZ': 'mi', // New Zealand
    'OM': 'ar', // Oman
    'PA': 'es', // Panama
    'PE': 'es', // Peru
    'PF': 'fr', // French Polynesia
    'PG': 'en', // Papua New Guinea
    'PH': 'tl', // Philippines
    'PK': 'ur', // Pakistan
    'PL': 'pl', // Poland
    'PM': 'fr', // Saint Pierre and Miquelon
    'PN': 'en', // Pitcairn
    'PR': 'es', // Puerto Rico
    'PS': 'ar', // Palestine, State of
    'PT': 'pt', // Portugal
    'PW': 'en', // Palau
    'PY': 'es', // Paraguay
    'QA': 'ar', // Qatar
    'RE': 'fr', // Réunion
    'RO': 'ro', // Romania
    'RS': 'sr', // Serbia
    'RU': 'ru', // Russian Federation
    'RW': 'rw', // Rwanda
    'SA': 'ar', // Saudi Arabia
    'SB': 'en', // Solomon Islands
    'SC': 'fr', // Seychelles
    'SD': 'ar', // Sudan
    'SE': 'sv', // Sweden
    'SG': 'zh', // Singapore
    'SH': 'en', // Saint Helena, Ascension and Tristan da Cunha
    'SI': 'sl', // Slovenia
    'SJ': 'no', // Svalbard and Jan Mayen
    'SK': 'sk', // Slovakia
    'SL': 'en', // Sierra Leone
    'SM': 'it', // San Marino
    'SN': 'fr', // Senegal
    'SO': 'so', // Somalia
    'SR': 'nl', // Suriname
    'SS': 'en', // South Sudan
    'ST': 'pt', // Sao Tome and Principe
    'SV': 'es', // El Salvador
    'SX': 'nl', // Sint Maarten (Dutch part)
    'SY': 'ar', // Syrian Arab Republic
    'SZ': 'en', // Eswatini
    'TC': 'en', // Turks and Caicos Islands
    'TD': 'fr', // Chad
    'TF': 'fr', // French Southern Territories
    'TG': 'fr', // Togo
    'TH': 'th', // Thailand
    'TJ': 'tg', // Tajikistan
    'TK': 'en', // Tokelau
    'TL': 'pt', // Timor-Leste
    'TM': 'tk', // Turkmenistan
    'TN': 'ar', // Tunisia
    'TO': 'to', // Tonga
    'TR': 'tr', // Turkey
    'TT': 'en', // Trinidad and Tobago
    'TV': 'en', // Tuvalu
    'TW': 'zh', // Taiwan, Province of China
    'TZ': 'sw', // Tanzania, United Republic of
    'UA': 'uk', // Ukraine
    'UG': 'en', // Uganda
    'UM': 'en', // United States Minor Outlying Islands
    'US': 'en', // United States of America
    'UY': 'es', // Uruguay
    'UZ': 'uz', // Uzbekistan
    'VA': 'it', // Holy See
    'VC': 'en', // Saint Vincent and the Grenadines
    'VE': 'es', // Venezuela (Bolivarian Republic of)
    'VG': 'en', // Virgin Islands (British)
    'VI': 'en', // Virgin Islands (U.S.)
    'VN': 'vi', // Viet Nam
    'VU': 'bi', // Vanuatu
    'WF': 'fr', // Wallis and Futuna
    'WS': 'sm', // Samoa
    'YE': 'ar', // Yemen
    'YT': 'fr', // Mayotte
    'ZA': 'en', // South Africa
    'ZM': 'en', // Zambia
    'ZW': 'en', // Zimbabwe
  };

  @override
  void onInit() async {
    selectTranslateName.value =
        await Utils.getStringValueWithKey(Constant.LANGUAGE_TRANSLATE_NAME);

    if (selectTranslateName.value == '') {
      String codeTraslate =
          WidgetsBinding.instance.platformDispatcher.locale.countryCode!;
      selectTranslateName.value = Country.tryParse(codeTraslate)!.name;
    }

    String language =
        await Utils.getStringValueWithKey(Constant.LANGUAGE_SYSTEM_INDEX);

    if (language == '') {
      String codeTraslate =
          WidgetsBinding.instance.platformDispatcher.locale.countryCode!;

      int index = listNation
          .indexWhere((element) => element.code.toString() == codeTraslate);

      if (index == -1) {
        selectLanguuage.value = 0;
      } else {
        selectLanguuage.value = index;
      }
    } else {
      int index = await listNation
          .indexWhere((element) => language.contains(element.code.toString()));

      selectLanguuage.value = index;
    }
    // TODO: implement onInit
    super.onInit();
  }
}

class Nation {
  String? src, title, code;
  Nation({this.src, this.title, this.code});
}
