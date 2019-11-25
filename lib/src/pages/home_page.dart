import 'package:flutter/material.dart';


class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
        title: Text('Escaner Documentos'),
        centerTitle: true,
      ),
      body:_crearListado(context),
      //floatingActionButton: _crearBoton(context),
    );
  }

 /*  _crearBoton(BuildContext context){

    return FloatingActionButton(
      child: Icon(Icons.share, size: 20.0,),
      backgroundColor: Colors.lightBlue,
      onPressed: ()=> Navigator.pushNamed(context, 'producto'),
    );
  } */


  Widget _crearListado(BuildContext context){

    final sizeButton = 30.0;

    return Container(
        padding: EdgeInsets.only(top: 200.0),
        child: Column(
          children: <Widget>[
            Center(
              child: RaisedButton(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 50.0, vertical: 15.0),
                child: Icon(Icons.wallpaper, size: sizeButton, ),
              ),
              shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0) 
              ),
              elevation: 0.0,
              color: Colors.lightBlue,
              textColor: Colors.white,
              onPressed: (){} ,
               ),
            ),
            SizedBox(height: 60,),
            Center(
              child: RaisedButton(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 50.0, vertical: 15.0),
                child: Icon(Icons.folder, size: sizeButton,),
              ),
              shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0) 
              ),
              elevation: 0.0,
              color: Colors.lightBlue,
              textColor: Colors.white,
              onPressed: (){
                Navigator.pushNamed(context, 'documents');
              } ,
            ),
          ),
        ],
        ),
      );
  }

}