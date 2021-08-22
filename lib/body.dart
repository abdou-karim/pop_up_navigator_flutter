import 'package:flutter/material.dart';
import 'package:pop_up_navigator/nouvelle_page.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => new _BodyState();
}

class _BodyState extends State<Body> {
  @override
  Widget build(BuildContext context){
    return new Center(
      child: new RaisedButton(
        color: Colors.teal,
        textColor: Colors.white,
        child: Text(
          'Appuyer moi',
          style: new TextStyle(
              fontStyle: FontStyle.italic,
              fontSize: 20.0
          ),),
        onPressed: versNouvellePage,
        //(() => dialog('Bienvenue au Senegal','Admirez le beau paysage du senegal')),
      ),
    );
  }
  void snack(){
    SnackBar snackbar = new SnackBar(
      content: new Text(
        'Je suis une snackBar',
        textScaleFactor: 1.5,),
      duration: new Duration(seconds: 5),
    );
    Scaffold.of(context).showSnackBar(snackbar);
  }
  Future<Null> alert() async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context){
          return new AlertDialog(
            title: new Text('Ceci est une alert',textScaleFactor: 1.5,),
            content: Text('Nous avons un probleme avec notre application.Voulez vous continuer ?'),
            contentPadding: EdgeInsets.all(5.0),
            actions: <Widget>[
              new FlatButton(
                  onPressed: (){
                    print('Abort');
                    Navigator.pop(context);
                  },
                  child: new Text('Annuler',style: new TextStyle(color: Colors.red),)
              ),
              new FlatButton(
                  onPressed: (){
                    print('proceed');
                    Navigator.pop(context);
                  },
                  child: new Text('Continuer',style: new TextStyle(color: Colors.blue),))
            ],
          );
        }
    );
  }
  Future<Null> dialog(String title,String desc) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new SimpleDialog(
            title: new Text(title,textScaleFactor: 1.4,),
            contentPadding: EdgeInsets.all(10.0),
            children: <Widget>[
              new Text(desc),
              new Container(height: 20.0,),
              new RaisedButton(
                  child: new Text('Ok'),
                  color: Colors.teal,
                  onPressed: (){
                    print("Appuyer");
                    Navigator.pop(context);
                  }
              )
            ],
          );
        }
    );
  }
  void versNouvellePage(){
    Navigator.push(
      context,
      new MaterialPageRoute(builder: (BuildContext context) {
        return new NouvellePage('La seconde page de sidibe');
      }),
    );
  }
}