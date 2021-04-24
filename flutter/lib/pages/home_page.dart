import 'package:flutter/material.dart';
import 'package:travel_app/blocs/home_bloc.dart';

class HomePage extends StatefulWidget with HomeBloc {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    widget.requestWeather(19.99, -99.998);
    widget.requestCities("nayarit");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: RefreshIndicator(
        onRefresh: () => widget.requestWeather(19.99, -99.99),
        child: StreamBuilder(
          stream: widget.getWeatherStream,
          builder: (context, snapshot) {
            return Container(
              child: Text("loading"),
            );
          },
        ),
      ),
    );
  }
}
