import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class PullToRefreshPage extends StatelessWidget {
  final _refreshController = RefreshController(initialRefresh: false);

  void _onRefresh() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("pull_to_refresh"),
        centerTitle: true,
      ),
      body: Center(child: body()),
    );
  }

  Widget body() => SmartRefresher(
        enablePullDown: true,
        header: BezierCircleHeader(),
        controller: _refreshController,
        onRefresh: _onRefresh,
        child: ListView.builder(
          itemExtent: 50,
          itemCount: 100,
          itemBuilder: (context, index) => Card(child: Center(child: Text(index.toString()))),
        ),
      );
}
