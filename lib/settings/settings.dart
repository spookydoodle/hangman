import 'package:hangman/settings/translator.dart';

enum Category { general, business, entertainment, science, sport, health }
enum Country { gb, us, de, nl, pl }
enum Lang { english, german, polish, dutch }

class Settings {
  static Country getCountry(String str) {
    switch (str) {
      case 'gb':
        return Country.gb;
      case 'us':
        return Country.us;
      case 'de':
        return Country.de;
      case 'pl':
        return Country.pl;
      case 'nl':
        return Country.nl;
      default:
        return Country.gb;
    }
  }

  static Lang getLang(Country country) {
    switch (country) {
      case Country.gb:
        return Lang.english;
      case Country.us:
        return Lang.english;
      case Country.de:
        return Lang.german;
      case Country.nl:
        return Lang.dutch;
      case Country.pl:
        return Lang.polish;
      default:
        return Lang.english;
    }
  }

  static Category getCategory(String str) {
    switch (str) {
      case 'general':
        return Category.general;
      case 'business':
        return Category.business;
      case 'entertainment':
        return Category.entertainment;
      case 'science':
        return Category.science;
      case 'sport':
        return Category.sport;
      case 'health':
        return Category.health;
      default:
        return Category.general;
    }
  }

  static String getAlphabet(Country country) {
    final Lang lang = Settings.getLang(country);

    switch (lang) {
      case Lang.english:
        return "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
      case Lang.german:
        return "AÄBCDEFGHIJKLMNOÖPQRSßTUÜVWXYZ";
      case Lang.dutch:
        return "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
      case Lang.polish:
        return "AĄBCĆDEĘFGHIJKLŁMNŃOÓPQRSŚTUVWXYZŹŻ";
      default:
        return "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    }
  }

  static Translator getTranslator(Country country) {
    final Lang lang = Settings.getLang(country);

    switch (lang) {
      case Lang.english:
        return englishTranslator;
      case Lang.german:
        return germanTranslator;
      case Lang.dutch:
        return dutchTranslator;
      case Lang.polish:
        return polishTranslator;
      default:
        return englishTranslator;
    }
  }
}
