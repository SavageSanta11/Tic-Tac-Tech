import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:hexcolor/hexcolor.dart';
import 'dart:async';
import "dart:js" as js;

enum AudioState { recording, stop, play }
/*
class room {
  final String id;
  final String title;
  final String type;
  final bool isLocked;
  final String lastActivity;
  final String creatorId;
  final String created;
  final String ownerId;

  room(
      {this.id,
      this.title,
      this.type,
      this.isLocked,
      this.lastActivity,
      this.creatorId,
      this.created,
      this.ownerId});

  factory room.fromJson(Map<String, dynamic> json) {
    return room(
      id: json["id"] as String,
      title: json["title"] as String,
      type: json["type"] as String,
      isLocked: json["isLocked"] as bool,
      lastActivity: json["lastActivity"] as String,
      creatorId: json["creatorId"] as String,
      created: json["created"] as String,
      ownerId: json["ownerId"] as String,
    );
  }
}

List<room> parseRooms(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

  return parsed.map<room>((json) => room.fromJson(json)).toList();
}
*/

void main() {
  runApp(MaterialApp(
    home: OpenScreen(),
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      primarySwatch: createMaterialColor(Color(0XFF3bc8f3)),
      brightness: Brightness.dark,
    ),
  ));
}

MaterialColor createMaterialColor(Color color) {
  List strengths = <double>[.05];
  Map swatch = <int, Color>{};
  final int r = color.red, g = color.green, b = color.blue;

  for (int i = 1; i < 10; i++) {
    strengths.add(0.1 * i);
  }
  strengths.forEach((strength) {
    final double ds = 0.5 - strength;
    swatch[(strength * 1000).round()] = Color.fromRGBO(
      r + ((ds < 0 ? r : (255 - r)) * ds).round(),
      g + ((ds < 0 ? g : (255 - g)) * ds).round(),
      b + ((ds < 0 ? b : (255 - b)) * ds).round(),
      1,
    );
  });
  return MaterialColor(color.value, swatch);
}

class App extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.dark(),
      home: OpenScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class OpenScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 100.0,
        ),
        Row(mainAxisAlignment: MainAxisAlignment.center, 
        children: <Widget>[
          Image.asset("images/logo.png"),
        ]),
        SizedBox(height: 50.0),
        SizedBox(
          width: 280,
          height: 40.0,
          child: ElevatedButton(
            child: Text('PLAY!'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomePage()),
              );
            },
          ),
        )
      ],
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  List<List> _matrix;

  _HomePageState() {
    _initMatrix();
  }

  _initMatrix() {
    _matrix = List<List>(3);
    for (var i = 0; i < _matrix.length; i++) {
      _matrix[i] = List(3);
      for (var j = 0; j < _matrix[i].length; j++) {
        _matrix[i][j] = ' ';
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildElement(0, 0),
              SizedBox(
                width: 5.0,
              ),
              _buildElement(0, 1),
              SizedBox(
                width: 5.0,
              ),
              _buildElement(0, 2),
            ],
          ),
          SizedBox(
            height: 5.0,
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildElement(1, 0),
              SizedBox(
                width: 5.0,
              ),
              _buildElement(1, 1),
              SizedBox(
                width: 5.0,
              ),
              _buildElement(1, 2),
            ],
          ),
          SizedBox(
            height: 5.0,
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildElement(2, 0),
              SizedBox(
                width: 5.0,
              ),
              _buildElement(2, 1),
              SizedBox(
                width: 5.0,
              ),
              _buildElement(2, 2),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
          ),
          SizedBox(
            height: 20.0,
          ),
          SizedBox(
            height: 40.0,
            width: 280.0,
            child: ElevatedButton(
              child: Text('Help'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SecondRoute()),
                );
              },
            ),
          ),
          SizedBox(
            height: 5.0,
          ),
          SizedBox(
            height: 40.0,
            width: 280.0,
            child: ElevatedButton(
              child: Text('Reset Game'),
              onPressed: () {
                return showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: Text('Reset Game?'),
                    content: Text('Do you really want to reset the game?'),
                    actions: <Widget>[
                      FlatButton(
                        onPressed: () {
                          Navigator.of(ctx).pop();
                          setState(() {
                            _initMatrix();
                          });
                        },
                        child: Text('Yes'),
                      ),
                    ],
                  ),
                );
              },
            ),
          )
        ],
      ),
    ));
  }

  String _lastChar = 'o';

  _buildElement(int i, int j) {
    return GestureDetector(
      onTap: () {
        _changeMatrixField(i, j);

        if (_checkWinner(i, j)) {
          _showDialog(_matrix[i][j]);
        } else {
          if (_checkDraw()) {
            _showDialog(null);
          }
        }
      },
      child: Container(
        width: 90.0,
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: HexColor("#3bc8f3"),
        ),
        child: Center(
          child: Text(
            _matrix[i][j],
            style: TextStyle(fontSize: 70.0, color: Colors.white),
          ),
        ),
      ),
    );
  }

  _changeMatrixField(int i, int j) {
    setState(() {
      if (_matrix[i][j] == ' ') {
        if (_lastChar == 'O')
          _matrix[i][j] = 'X';
        else
          _matrix[i][j] = 'O';

        _lastChar = _matrix[i][j];
      }
    });
  }

  _checkDraw() {
    var draw = true;
    _matrix.forEach((i) {
      i.forEach((j) {
        if (j == ' ') draw = false;
      });
    });
    return draw;
  }

  _checkWinner(int x, int y) {
    var col = 0, row = 0, diag = 0, rdiag = 0;
    var n = _matrix.length - 1;
    var player = _matrix[x][y];

    for (int i = 0; i < _matrix.length; i++) {
      if (_matrix[x][i] == player) col++;
      if (_matrix[i][y] == player) row++;
      if (_matrix[i][i] == player) diag++;
      if (_matrix[i][n - i] == player) rdiag++;
    }
    if (row == n + 1 || col == n + 1 || diag == n + 1 || rdiag == n + 1) {
      return true;
    }
    return false;
  }

  _showDialog(String winner) {
    String dialogText;
    if (winner == null) {
      dialogText = 'It\'s a draw';
    } else {
      dialogText = 'Player $winner won';
    }

    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Game over'),
            content: Text(dialogText),
            actions: <Widget>[
              FlatButton(
                child: Text('Reset Game'),
                onPressed: () {
                  Navigator.of(context).pop();
                  setState(() {
                    _initMatrix();
                  });
                },
              )
            ],
          );
        });
  }
}

class SecondRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
          child: Column(children: [
          
        SizedBox(
          height: 40.0,
        ),
        SizedBox(
          width: 1000.0,
          height: 200.0,
                  child: Card(
              child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text(
                  'How to Play',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 25.0),
                ),
                subtitle: Text(
                  "1.The game is played on a square grid composed of 9 smaller squares. \n 2. You are O and the computer is O. \n 3. Players take turns to fill their respective marks. \n 4. The first player to get three marks in a row is the winner \n 5. If the grid is filled without any player getting three marks in a row, then the game ends in a draw.",
                  style: TextStyle(fontSize: 20.0),
                ),
              )
            ],
          )),
        ),
        SizedBox(
          height: 20.0,
        ),
        SizedBox(
          height: 40.0,
          width: 280.0,
          child: ElevatedButton(
            child: Text('Help'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ThirdRoute()),
              );
            },
          ),
        ),
      ])),
    );
  }
}

Future<void> fetchRooms() async {
  // gets the list of rooms
  var headers = {
    'Authorization':
        'API KEY',
    'Content-Type': 'application/json',
  };
  var request =
      http.Request('GET', Uri.parse('https://webexapis.com/v1/rooms'));

  request.headers.addAll(headers);

  http.StreamedResponse response = await request.send();

  if (response.statusCode == 200) {
    print(await response.stream.bytesToString());
    //js.context.callMethod('test');
  } else {
    print(response.reasonPhrase);
  }
}

Future<void> onPress() async {
  //SENDS MESSAGE TO THE DESIRED ROOM
  var headers = {
    'Authorization':
        'API KEY',
    'Content-Type': 'application/json'
  };
  var request =
      http.Request('POST', Uri.parse('https://webexapis.com/v1/messages'));
  request.body =
      '''{\r\n  "roomId" : "{{rid}}",\r\n  "text" : "Hey! I need help!"\r\n}''';
  request.headers.addAll(headers);

  http.StreamedResponse response = await request.send();

  if (response.statusCode == 200) {
    print(await response.stream.bytesToString());
  } else {
    print(response.reasonPhrase);
  }
}

class ThirdRoute extends StatefulWidget {
  @override
  _ThirdRouteState createState() => _ThirdRouteState();
}

class _ThirdRouteState extends State<ThirdRoute> {
  final myController = TextEditingController();

  AudioState audioState;

  void handleAudioState(AudioState state) {
    setState(() {
      if (audioState == null) {
        //starts recording
        audioState = AudioState.recording;
        //finished recording
      } else if (audioState == AudioState.recording) {
        audioState = AudioState.play;
        //play recorded audio
      } else if (audioState == AudioState.play) {
        audioState = AudioState.stop;
        //stop recorded audio
      } else if (audioState == AudioState.stop) {
        audioState = AudioState.play;
      }
    });
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Center(
            child: Column(
          children: [
            SizedBox(
              height: 20.0,
            ),
            /*
            Row(
              children: [
                Expanded(
                  child: Text(
                    "You are advised to create a space in webex teams with contacts like you'd notify - enter the name of the room below",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 25.0),
                  ),
                )
              ],
            ),
            SizedBox(
              width: 280.0,
              child: TextField(
                controller: myController,
              ),
            ),*/
            SizedBox(
              height: 40.0,
            ),
            SizedBox(
              height: 40.0,
              width: 280.0,
              child: ElevatedButton(
                child: Text('Message Contacts'),
                onPressed: () {
                  String roomname = myController.text;
                  fetchRooms();
                  onPress();
                },
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            /*
            SizedBox(
              height: 40.0,
              width: 280.0,
              child: ElevatedButton(
                child: Text('Record'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SecondRoute()),
                  );
                },
              ),
            ),*/
          ],
        )));
  }
}
