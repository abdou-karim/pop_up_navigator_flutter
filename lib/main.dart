import 'dart:async';
import 'package:flutter/material.dart';
import 'Musique.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:assets_audio_player/assets_audio_player.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Music app',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Music app'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Musique> maListeDeMusqiue = [
    new Musique('Maher', 'Maher zain', 'assets/un.png', 'assets/music/Number_One_For_Me.mp3'),
    new Musique('Fouini', 'La fouine', 'assets/deuxx.jpg', 'assets/music/03-la_fouine-ma_meilleure_feat_zaho.mp3'),
  ];
  late AssetsAudioPlayer audioPlayer = AssetsAudioPlayer();
  late StreamSubscription positionSub;
  late StreamSubscription stateSubscription;
  late Musique maMusqiueActuelle;
  var t ;
  Duration position = new Duration(seconds: 0);
  Duration duree = new Duration(seconds: 10);
  NewPlayerState statut = NewPlayerState.stopped;
  int index= 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    maMusqiueActuelle = maListeDeMusqiue[index];
    t = audioPlayer.currentPosition.length;
    configurationAudioPlayer();
  }
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.grey[900],
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      backgroundColor: Colors.grey[800],
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            new Card(
              elevation: 9.0,
              child: new Container(
                width: MediaQuery.of(context).size.height / 2.5,
                child: new Image.asset(maMusqiueActuelle.imagePath)
              ),
            ),
            textAvecStyle(maMusqiueActuelle.titre, 1.5),
            textAvecStyle(maMusqiueActuelle.artiste, 1.0),
            new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                bouton(Icons.fast_rewind, 30.0, ActionMusique.rewind),
                bouton((statut == NewPlayerState.playing)?Icons.pause:Icons.play_arrow, 45.0,(statut == NewPlayerState.playing)?ActionMusique.pause:ActionMusique.play),
                bouton(Icons.fast_forward, 30.0, ActionMusique.forward),
              ],

            ),
            new Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                textAvecStyle(fromDuration(position), 0.8),
                textAvecStyle(fromDuration(audioPlayer.currentPosition.value), 0.8),
              ],
            ),
            new Slider(
                value: position.inSeconds.toDouble(),
                min: 0.0,
                max: 200,
                inactiveColor: Colors.white,
                activeColor: Colors.red,
                onChanged: (double d){
                setState(() {
                  Duration nouvelleDuration = new Duration(seconds: d.toInt());
                  position = nouvelleDuration;
                  audioPlayer.seek(nouvelleDuration);
                });
                }
            ),
          ],
        ),
      ),
    );
  }
  IconButton bouton(IconData icon, double taille, ActionMusique action){
    return new IconButton(
        iconSize: taille,
        color: Colors.white,
        onPressed: (){
          switch (action) {
            case ActionMusique.play:
              play();
              break;
            case ActionMusique.pause:
              pause();
              break;
            case ActionMusique.forward:
              forward();
              break;
            case ActionMusique.rewind:
             rewind();
                  break;

          }
        },
        icon: new Icon(icon));
  }
  Text textAvecStyle(String data , double scale){
    return new Text(
        data,
      textScaleFactor: scale,
      textAlign: TextAlign.center,
      style: new TextStyle(
        color: Colors.white,
        fontSize: 20.0,
        fontStyle: FontStyle.italic
      ),
    );
  }
  void configurationAudioPlayer() {
    audioPlayer = new AssetsAudioPlayer();
    positionSub = audioPlayer.currentPosition.listen(
        (pos) => setState( () => position = pos )
    );
    stateSubscription = audioPlayer.playerState.listen((state) {
      if (state == audioPlayer.isPlaying){
          duree = audioPlayer.currentPosition.value;
      }
      else if(state != audioPlayer.isPlaying) {
        setState(() {
            statut = NewPlayerState.stopped;
        });
      }
    },onError: (message) {
      print('erreur :$message');
      setState(() {
        statut = NewPlayerState.stopped;
        duree = new Duration(seconds: 0);
        position = new Duration(seconds: 0);
      });
    }
    );
  }

  Future play() async {
    await audioPlayer.open(Audio(maMusqiueActuelle.urlSong));
    setState(() => statut = NewPlayerState.playing);
  }

  Future pause() async {
    await audioPlayer.pause();
    setState(() {
      statut = NewPlayerState.paused;
      duree = new Duration(seconds: 0);
      position = new Duration(seconds: 0);
    });
  }

  Future<void> stop() async {
    await audioPlayer.stop();
    setState(() {
      statut = NewPlayerState.stopped;
      position = new Duration();
    });
  }
  void forward(){
    if (index == maListeDeMusqiue.length -1){
      index =0;
    }
    else {
      index++;
    }
    maMusqiueActuelle = maListeDeMusqiue[index];
    audioPlayer.stop();
    configurationAudioPlayer();
    play();
  }
  void rewind(){
    if(position > Duration(seconds: 3)){
      audioPlayer.seek(Duration(seconds: 0));
    }
    else{
      if(index==0){
        index = maListeDeMusqiue.length -1;
      }else{
        index--;
      }
      maMusqiueActuelle = maListeDeMusqiue[index];
      audioPlayer.stop();
      configurationAudioPlayer();
      play();
    }
  }
  String fromDuration(Duration duree){
    return duree.toString().split('.').first;
  }
}
enum ActionMusique {
  play,
  pause,
  rewind,
  forward
}
enum NewPlayerState {
  playing,
  stopped,
  paused
}
