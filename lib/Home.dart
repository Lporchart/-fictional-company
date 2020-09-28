import 'package:flutter/material.dart';
import 'package:gif/gif_page.dart';
import 'package:http/http.dart'as http;
import 'dart:convert';
import 'dart:async';
import 'package:share/share.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}
  String _pesquisa;
  int offset = 0;
  Future<Map> _getgif() async{
    http.Response response;
    if(_pesquisa == null)
      response = await http.get("https://api.giphy.com/v1/gifs/trending?api_key=PeQOe8lkOhBbbVa9CKQZEx76x7ojagAy&limit=25&rating=G");
      else
      response = await http.get("https://api.giphy.com/v1/gifs/search?api_key=PeQOe8lkOhBbbVa9CKQZEx76x7ojagAy&q=$_pesquisa&limit=25&offset=$offset&rating=G&lang=pt");

    return json.decode(response.body);
  
  }
  
int _getCount(List data){
  if(_pesquisa == null){
    return data.length;

  }else
  return data.length + 1;
}



  Widget _createGif (BuildContext context, AsyncSnapshot snapshot){
    return GridView.builder(
        padding: EdgeInsets.all(10.0),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10.0,
          mainAxisSpacing: 10.0
        ),
        itemCount: _getCount(snapshot.data["data"]),
        itemBuilder: (context, index){
          if(_pesquisa == null || index < snapshot.data["data"].length)
            return GestureDetector(
             child: Image.network(snapshot.data["data"][index]["images"]["fixed_height"]["url"],
        height: 300,
        fit: BoxFit.cover,
        ),
              onTap: (){
                Navigator.push(context,
                  MaterialPageRoute(builder: (context) => Gif(snapshot.data["data"][index]))
                );
              },
              onLongPress: (){
                Share.share(snapshot.data["data"][index]["images"]["fixed_height"]["url"]);
              },
            );
          else
            return Container(
              child: GestureDetector(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.add, color: Colors.white, size: 70.0,),
                    Text("Carregar mais...",
                      style: TextStyle(color: Colors.white, fontSize: 22.0),)
                  ],
                ),
                onTap: (){
                    offset += 25;
                    
                },
              ),
            );
        }
    );
  }           

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        title: Image.network("https://developers.giphy.com/branch/master/static/header-logo-8974b8ae658f704a5b48a2d039b8ad93.gif"),
      ),
      backgroundColor: Colors.black,
      body:   
      Column(
        children: <Widget>[
          Padding(padding: EdgeInsets.all(15),
          child: TextField(
            decoration: InputDecoration(
              labelText: "Pesquisa",
              labelStyle: TextStyle(
                color: Colors.white,),
                border: OutlineInputBorder()              
              ),
              style: TextStyle(color: Colors.white,
              fontSize: 20,
            ),
            onSubmitted: (text){
              setState(() {
                _pesquisa = text;
                offset = 0;
              });

            },
          ),
          ),
          Expanded(
            child: FutureBuilder(
              future: _getgif(),
              builder:(context, snapshot){
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:                                           
                    case ConnectionState.none: 
                      return Container(
                        width: 200,
                        height: 200,
                        alignment: Alignment.center,
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          strokeWidth: 5.0,
                        ),
                      );
                      default: 
                        if (snapshot.hasError) {
                          return Container(
                            child: Text("Erro a o Carregar os Gifs"),
                            alignment: Alignment.center,
                          );
                        } else {
                          return _createGif(context, snapshot);
                        
                        }
                      }
                      }
              )
           )
        ],
      ),
    );
  }
}












//https://api.giphy.com/v1/gifs/search?api_key=PeQOe8lkOhBbbVa9CKQZEx76x7ojagAy&q=25&limit=25&offset=25&rating=G&lang=pt
//https://api.giphy.com/v1/gifs/trending?api_key=PeQOe8lkOhBbbVa9CKQZEx76x7ojagAy&limit=25&rating=G
