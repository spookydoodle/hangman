class Range {
  final int min;
  final int max;

  Range(this.min, this.max);
}

class GameOverDisplayData {
  final String message;
  final String buttonText;
  final void Function() onPressed;

  const GameOverDisplayData(
      {required this.message,
        required this.buttonText,
        required this.onPressed});
}

class GameOverDisplay {
  final GameOverDisplayData won;
  final GameOverDisplayData lost;

  GameOverDisplay({required this.won, required this.lost});
}
