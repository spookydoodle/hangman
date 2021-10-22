enum Category { general, business, entertainment, science, sport, health }

Category getCategory(String str) {
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

enum Country { gb, us, de, nl, pl }

Country getCountry(String str) {
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

enum Lang { english, german, polish, dutch }

getLang(Country country) {
  switch (country) {
    case Country.gb:
      return 'English';
    case Country.us:
      return 'English';
    case Country.de:
      return 'German';
    case Country.nl:
      return 'Dutch';
    case Country.pl:
      return 'Polish';
    default:
      return 'English';
  }
}

getAlphabet(Country country) {
  switch (country) {
    case Country.gb:
      return "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    case Country.us:
      return "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    case Country.de:
      return "AÄBCDEFGHIJKLMNOÖPQRSßTUÜVWXYZ";
    case Country.nl:
      return "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    case Country.pl:
      return "AĄBCĆDEĘFGHIJKLŁMNŃOÓPQRSŚTUVWXYZŹŻ";
    default:
      return "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
  }
}

class Settings {
  static Category category = Category.general;
  static Country country = Country.gb;
  static int page = 1;
}