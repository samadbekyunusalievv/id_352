import 'dart:convert';

class MovieBingo {
  final String movieName;
  final List<String> bingoOptions;
  final String bannerImagePath;
  final bool isAddedMovie;

  MovieBingo({
    required this.movieName,
    required this.bingoOptions,
    required this.bannerImagePath,
    this.isAddedMovie = false,
  });

  String toJson() {
    return jsonEncode({
      'movieName': movieName,
      'bingoOptions': bingoOptions,
      'bannerImagePath': bannerImagePath,
      'isAddedMovie': isAddedMovie,
    });
  }

  factory MovieBingo.fromJson(String jsonString) {
    final data = jsonDecode(jsonString);
    return MovieBingo(
      movieName: data['movieName'],
      bingoOptions: List<String>.from(data['bingoOptions']),
      bannerImagePath: data['bannerImagePath'],
      isAddedMovie: data['isAddedMovie'],
    );
  }
}

List<MovieBingo> movieBingoList = [
  MovieBingo(
    movieName: 'Deadpool',
    bingoOptions: [
      'Slow-mo',
      'Breaking the 4th wall',
      'Death',
      'Sarcastic remark',
      'Flashback',
      'Blood',
      'Naughty jokes',
      'The X-MEN show up',
      'Mention of the Avengers',
      'The animal on the screen',
      'Jokes about The Marvels bombing',
      'Romantic moment',
      'Chimichanga',
      'Deadpool uses swords',
      'Deadpool uses guns',
      'Explosion',
      'Deadpool without his mask',
      'Deadpool\'s girlfriend on the screen',
      'Peter on the screen',
      'Wade does something explicitly queer',
      'Logan kills Wade',
      'Breaking the 4th wall, again',
      'Deadpool breaks the bones of himself or his enemies',
      'Wade loses a limb',
    ],
    bannerImagePath: 'assets/deadpool_banner.png',
  ),
  MovieBingo(
    movieName: 'Sherlock BBC',
    bingoOptions: [
      'Ear hat',
      '221 B Baker St.',
      'Mustache',
      'Free Space',
      '"BORING"',
      'Sherlock eats something',
      'Sherlock\'s going through the process of investigation',
      'Sherlock forgets names',
      'Taxi ride',
      'Someone mistakes Sherlock and John for a couple',
      'John\'s life is in danger',
      'Displaying a text message on the screen',
      'A play on words of a classic Holmes story title',
      'Sherlock and Mycroft communicating',
      'Anderson is on the screen',
      'Violin on the screen',
      'Client counseling',
      'Watson mentions his blog',
      '"I\'m not your housekeeper!"',
      'Sherlock and Moriarty on one screen',
      'John punches someone',
      'Mind Place',
      'Sherlock is rude to a client',
      'Sherlock steeples his fingers',
    ],
    bannerImagePath: 'assets/sherlock_bbc_banner.png',
  ),
  MovieBingo(
    movieName: 'Lord of the Rings',
    bingoOptions: [
      'Hobbit feet close up',
      'The eye of Sauron appears',
      'They\'re taking the hobbits to Isengard!',
      'Close up of the ring',
      'Gandalf insults Pippin',
      'Gimli makes a joke',
      'Gandalf uses magic',
      'Merry and Pippin do something dumb',
      'Someone eats',
      'Frodo starts buggin from the Ring',
      'A Nazgul is on screen',
      'Sam says "Mr. Frodo"',
      'Someone runs',
      'Someone puts on the Ring',
      'A main character dies',
      'Legolas and Gimli share a bro moment',
      'Legolas and Gimli count kills',
      'Orc Scream',
      'Elf senses something dangerous',
      'Legolas looks off into the distance',
      'A character pulls out a weapon',
      'A character rides a horse',
      'All 4 hobbits are together',
      'Someone speaks Elvish',
    ],
    bannerImagePath: 'assets/lord_of_the_rings_banner.png',
  ),
  MovieBingo(
    movieName: 'Pirates of the Caribbean',
    bingoOptions: [
      'CAPTAIN Jack Sparrow',
      'Someone\'s drinking',
      'Jack Sparrow gets slapped',
      'Mentions the Black Pearl',
      '"Fire!"',
      'Elizabeth smiles',
      'Someone says "rum"',
      'A British officer is on screen',
      'Jack laughs',
      'Someone uses a sword or pistol',
      'Someone goes "HARR!"',
      'Jack says "savvy"',
      'Jack says "poppet"',
      'Jack is either the best or the worst pirate someone has ever seen',
      'Barbarossa falls for one of Jack\'s stories',
      'The moon comes out from behind a cloud',
      'Jack steals anything',
      'Cursed pirates on the screen',
      'The monkey makes an appearance',
      'Someone says "Bootstrap Bill"',
      'Will does something stupid despite being expressly told not to',
      'Big Battle',
      'Skirmishes',
      'Tortuga Bound shows up on screen',
    ],
    bannerImagePath: 'assets/pirates_of_the_caribbean_banner.png',
  ),
];
