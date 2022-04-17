import 'package:hangman/settings/settings.dart';

class Translator {
  // Main screen
  final String title;
  final String subtitle;
  final String language;
  final String category;
  final String play;
  final String leaderboard;
  final String exit;

  // Categories
  final String general;
  final String business;
  final String entertainment;
  final String science;
  final String health;
  final String sport;

  // AppBar
  final String settings;
  final String account;

  // Game over
  final String wonGames;
  final String remainingGuesses;
  final String youWon;
  final String youLost;
  final String nextGame;
  final String startNewGame;
  final String goToNews;

  Translator(
      {required this.title,
      required this.subtitle,
      required this.language,
      required this.category,
      required this.play,
      required this.leaderboard,
      required this.exit,
      required this.general,
      required this.business,
      required this.entertainment,
      required this.science,
      required this.health,
      required this.sport,
      required this.settings,
      required this.account,
      required this.wonGames,
      required this.remainingGuesses,
      required this.youWon,
      required this.youLost,
      required this.nextGame,
      required this.startNewGame,
      required this.goToNews});
}

Translator englishTranslator = new Translator(
    title: "Hangman",
    subtitle: "Guess The News",
    language: "Language",
    category: "Category",
    play: "Play",
    leaderboard: "Leaderboard",
    exit: "Exit",
    general: "General",
    business: "Business",
    entertainment: "Entertainment",
    science: "Science",
    health: "Health",
    sport: "Sport",
    settings: "Settings",
    account: "Account",
    wonGames: "Won games",
    remainingGuesses: "Remaining guesses",
    youWon: "You won!",
    youLost: "You lost!",
    nextGame: "Next game",
    startNewGame: "Start a new game",
    goToNews: "Check out the news");

Translator polishTranslator = new Translator(
    title: "Wisielec",
    subtitle: "Zgaduj Wiadomości",
    language: "Język",
    category: "Kategoria",
    play: "Graj",
    leaderboard: "Tablica wyników",
    exit: "Wyjdź",
    general: "Aktualności",
    business: "Biznes",
    entertainment: "Rozrywka",
    science: "Nauka",
    health: "Zdrowie",
    sport: "Sport",
    settings: "Ustawienia",
    account: "Konto gracza",
    wonGames: "Wygrane gry",
    remainingGuesses: "Pozostałe pomyłki",
    youWon: "Zwycięstwo!",
    youLost: "Przegrana!",
    nextGame: "Następna gra",
    startNewGame: "Rozpocznij nową grę",
    goToNews: "Przeczytaj artykuł");

Translator dutchTranslator = new Translator(
    title: "Het Spel Van De Beul",
    subtitle: "Raad Het Nieuws",
    language: "Taal",
    category: "Categorie",
    play: "Spel",
    leaderboard: "Scorebord",
    exit: "Afsluiten",
    general: "Algemeen",
    business: "Zakelijk",
    entertainment: "Amusement",
    science: "Wetenschap",
    health: "Gezondheid",
    sport: "Sport",
    settings: "Instellingen",
    account: "Account",
    wonGames: "Winsten",
    remainingGuesses: "Resterende gissingen ",
    youWon: "Je hebt gewonnen!",
    youLost: "Je hebt verloren!",
    nextGame: "Volgend spel",
    startNewGame: "Begin met nieuw spel",
    goToNews: "Lees het nieuws");

Translator germanTranslator = new Translator(
    title: "Galgenmännchen",
    subtitle: "Errate Nachrichten",
    language: "Sprache",
    category: "Kategorie",
    play: "Los!",
    leaderboard: "Bestenliste",
    exit: "Verlassen",
    general: "Aktuelle",
    business: "Wirtschaft",
    entertainment: "Unterhaltung",
    science: "Wissenschaft",
    health: "Gesundheit",
    sport: "Sport",
    settings: "Einstellungen",
    account: "Spielerkonto",
    wonGames: "Gewonnene Spiele ",
    remainingGuesses: "Verbleibende Vermutungen",
    youWon: "Du hast gewonnen!",
    youLost: "Du hast verloren!",
    nextGame: "Nächstes Spiel ",
    startNewGame: "Neues Spiel starten",
    goToNews: "Lies diese Nachricht");
