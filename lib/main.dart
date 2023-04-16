import 'package:flutter/material.dart';
import 'dart:convert' as convert;

import 'package:http/http.dart' as http;

import 'details.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: const Home(),
    routes: {
      '/details': (context) => const Details(),
    },
  ));
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<String> names = [];
  List<Widget> widgets = [];

  int rebuild = 0;

  void loaddata() async {
    var url = Uri.https('pokeapi.co', '/api/v2/pokemon', {'limit': '100000'});

    // Await the http get response, then decode the json-formatted response.
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var jsonResponse =
          convert.jsonDecode(response.body) as Map<String, dynamic>;

      for (var item in jsonResponse["results"]) {
        names.add(item["name"].toString());
      }
      widgets = names
          .asMap()
          .map((key, value) => MapEntry(
              key,
              Card(
                child: InkWell(
                  onTap: () {
                    Navigator.pushNamed(context as BuildContext, "/details",
                        arguments: {"id": key + 1});
                  },
                  child: Container(
                      child: Center(
                          child: Column(
                    children: [
                      Image.network(
                          "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/home/${key + 1}.png"),
                      Text("$value"),
                    ],
                  ))),
                ),
              )))
          .values
          .toList();
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
    if (rebuild < 2) {
      setState(() {
        rebuild++;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    loaddata();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("Pokemon app")),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(30, 40, 30, 30),
        child: GridView.count(
          crossAxisCount: 2,
          childAspectRatio: 4 / 5,
          children: [
            Center(
                child: Text(
              "LIST OF POKEMONS",
              style: TextStyle(fontSize: 20, color: Colors.black),
            )),
            ...widgets
          ],
        ),
      ),
    );
  }
}