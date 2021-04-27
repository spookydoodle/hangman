import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Game extends StatefulWidget {
  @override
  _GameState createState() => _GameState();
}

class _GameState extends State<Game> {
  List keywords = [
    "Cities urge people to stay home on Dutch king's birthday",
    "Global rights group accuses Israel of apartheid, persecution",
    "Private Florida school won't employ vaccinated teachers",
    "5 million Americans have missed 2nd COVID-19 vaccine dose, CDC data shows",
    "European Union ready to allow vaccinated tourists from America to visit this summer",
    "Asia Today: India records 320K cases as foreign help arrives",
    "4 serious accusations facing Boris Johnson at the moment",
    "Indonesia says 53 Crew Members of Missing Submarine are Dead, Wreckage Found",
    "Crystal Palace's Zaha extends notable Premier League run against Leicester City",
    "The Debate - Erdogan's battles: Turkey's leader digs in against domestic rivals",
  ];

  final List _alphabet = ['ABCDEFG', 'HIJKLMN', 'OPQRSTU', 'VWXYZ'];
  final List mistakeImages = [
    Image.asset('images/doodle-1/wrong_0.png'),
    Image.asset('images/doodle-1/wrong_1.png'),
    Image.asset('images/doodle-1/wrong_2.png'),
    Image.asset('images/doodle-1/wrong_3.png'),
    Image.asset('images/doodle-1/wrong_4.png'),
    Image.asset('images/doodle-1/wrong_5.png'),
    Image.asset('images/doodle-1/wrong_6.png'),
  ];

  bool gameOver = false;
  int keywordIndex = 0;
  int mistakeIndex = 0;
  final int maxMistakes = 7;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(keywords);
    // Shuffle the keywords list
    keywords.shuffle();
    print(keywords);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 80.0),
          child: Column(
            children: <Widget>[
              Container(
                height: 150,
                width: 150,
                child: Stack(
                  children: <Widget>[
                    mistakeIndex > 0 && mistakeIndex <= 7
                        ? Image.asset('images/doodle-1/wrong_0.png')
                        : Text(''),
                    mistakeIndex > 1 && mistakeIndex <= 7
                        ? mistakeImages[mistakeIndex - 1]
                        : Text(''),
                  ],
                ),
              ),
              Spacer(),
              Text(
                '_ _ \n_ _ _\n _ _',
                textAlign: TextAlign.center,
              ),
              Spacer(),
              Container(
                child: Column(
                  children: <Widget>[
                    ..._alphabet.map((row) => Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            ...row.split('').map((char) => OutlinedButton(
                                  onPressed: () => _onLetterPressed(char),
                                  child: Text(
                                    char.toString().toUpperCase(),
                                    style:
                                        Theme.of(context).textTheme.bodyText1,
                                  ),
                                ))
                          ],
                        ))
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onLetterPressed(char) {
    setState(() {
      _onMistake();
    });
  }

  // Increase index and if reached the max allowed mistakes end the game and reset index
  void _onMistake() {
    if (!gameOver) {
      _increaseMistakeIndex();
    }

    if (mistakeIndex == maxMistakes) {
      _setGameOver(true);
      // _resetMistakeIndex();
    }
  }

  void _increaseMistakeIndex() {
    mistakeIndex++;
    print("Mistake $mistakeIndex");
  }

  void _setGameOver(bool b) {
  gameOver = b;
  print("Game Over!");
}

  void _resetMistakeIndex() {
    mistakeIndex = 0;
    print("resetting");
  }
}
