import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Startup Name Generator',
      theme: ThemeData(
        primaryColor: Colors.white,
      ),
      home: RandomWords(),
    );
  }
}

class RandomWords extends StatefulWidget {
  @override
  _RandomWordsState createState() => _RandomWordsState();
}

class _RandomWordsState extends State<RandomWords> {
  final _suggestions = <WordPair>[];
  final _saved = Set<WordPair>();
  final TextStyle _biggerFont = const TextStyle(fontSize: 18);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Startup Name Generator"),
        actions: [
          Column(
            children: [
              Row(
                children: [
                  Text(
                    _saved.length.toString(),
                    textAlign: TextAlign.end,
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.favorite,
                      color: Colors.red,
                    ),
                    onPressed: _pushSaved,
                  )
                ],
              )
            ],
          )
        ],
      ),
      body: _buildSuggestions(),
    );
  }

  Widget _buildSuggestions() {
    return ListView.builder(
        padding: const EdgeInsets.all(25),
        itemBuilder: (BuildContext _context, int i) {
          if (i.isOdd) {
            return Divider();
          }

          final int index = i ~/ 2;

          if (index >= _suggestions.length) {
            _suggestions.addAll(generateWordPairs().take(10));
          }

          return _buildRow(_suggestions[index]);
        });
  }

  Widget _buildRow(WordPair pair) {
    final alreadySaved = _saved.contains(pair);
    return Card(
      child: Column(
        children: [
          ListTile(
            trailing: IconButton(
              icon: new Icon(
                alreadySaved ? Icons.favorite : Icons.favorite_border,
                color: alreadySaved ? Colors.red : null,
              ),
              onPressed: () {
                setState(() {
                  if (alreadySaved) {
                    _saved.remove(pair);
                  } else {
                    _saved.add(pair);
                  }
                });
              },
            ),
            title: Text(
              pair.asPascalCase,
              style: _biggerFont,
            ),
          ),
        ],
      ),
    );
  }

  Future onGoBack(dynamic value) {
    setState(() {});
    return null;
  }

  void _pushSaved() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              final tiles = _saved.map((WordPair pair) {
                return ListTile(
                  title: Text(
                    pair.asPascalCase,
                    style: _biggerFont,
                  ),
                  trailing: IconButton(
                    icon: new Icon(Icons.delete),
                    color: Colors.grey,
                    onPressed: () {
                      setState(() {
                        _saved.remove(pair);
                      });
                    },
                  ),
                );
              });
              final divided = ListTile.divideTiles(
                context: context,
                tiles: tiles,
              ).toList();

              return Scaffold(
                appBar: AppBar(
                  title: Text('Saved'),
                ),
                body: divided.length > 0
                    ? ListView(
                        children: divided,
                        padding: const EdgeInsets.all(25),
                      )
                    : Center(
                        child: Text(
                          "You have no Favorites",
                          style: TextStyle(fontSize: 22),
                        ),
                      ),
              );
            },
          );
        },
      ),
    ).then(onGoBack);
  }
}
