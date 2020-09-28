import 'package:flutter/material.dart';
import 'package:share/share.dart';






class Gif extends StatelessWidget {
    final Map gif;
    Gif(this.gif);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(gif["title"]),
        backgroundColor: Colors.black,
        actions: <Widget>[
          IconButton(icon: Icon(Icons.share), 
          onPressed: (){
            Share.share(gif["images"]["fixed_height"]["url"]);
          })
        ],
      ),
      body: Center(
        child: Image.network(gif["images"]["fixed_height"]["url"])
      ),
      
    );
  }
}