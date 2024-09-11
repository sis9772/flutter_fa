import 'package:flutter/material.dart';

class Home extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: new Container(
        color: Colors.white,
        child: new BottomAppBar(
          child: new Row(
            children: <Widget>[
              new IconButton(onPressed: (){}, icon: Icon(Icons.map_outlined)),
              new IconButton(onPressed: (){}, icon: Icon(Icons.search))
            ],
          )
        )
      ),
    );
  }

}