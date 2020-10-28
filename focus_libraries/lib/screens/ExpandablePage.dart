import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';

class ExpandablePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("expandable"),
        centerTitle: true,
      ),
      body: Center(child: body()),
    );
  }

  Widget body() => SingleChildScrollView(
        child: Card(
          margin: EdgeInsets.all(20),
          child: Column(
            children: [
              Image.network(
                  "https://images.unsplash.com/photo-1601758175576-648226072e90?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=2140&q=80"),
              ExpandablePanel(
                header: Text("Header"),
                collapsed: Text(
                  "Collpased",
                  softWrap: true,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                expanded: Text(
                  "Expandable should not be confused with ExpansionPanel. ExpansionPanel, which is a part of Flutter material library, is designed to work only within ExpansionPanelList and cannot be used for making other widgets, for example, expandable Card widgets.",
                  softWrap: true,
                ),
              ),
            ],
          ),
        ),
      );
}
