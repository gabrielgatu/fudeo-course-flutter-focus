import 'package:flutter/material.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.indigo,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Facebook"),
      ),
      body: body(),
    );
  }

  Widget body() => Row(children: [
        Expanded(flex: 3, child: content()),
      ]);

  Widget content() => Container(
        color: Colors.grey.shade100,
        child: ListView.builder(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          itemCount: 10,
          itemBuilder: (context, index) => post(),
        ),
      );

  Widget post() => Card(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(radius: 20, backgroundColor: Colors.grey.shade100),
                  SizedBox(width: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Gabriel Gatu", style: TextStyle(fontWeight: FontWeight.bold)),
                      Text("3 min", style: TextStyle(fontSize: 12, color: Colors.black45)),
                    ],
                  )
                ],
              ),
              SizedBox(height: 10),
              Text(
                  "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla finibus justo et tellus dapibus efficitur. Nulla facilisi. Nulla ac nisi vitae urna semper accumsan pharetra ac velit. Proin volutpat leo vitae elit fermentum varius. Morbi ut dui vitae velit pulvinar dictum. Aliquam non arcu gravida, volutpat diam eget, euismod tortor."),
            ],
          ),
        ),
      );
}
