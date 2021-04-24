
import 'package:flutter/material.dart';
import 'package:travel_app/managers/api_manager.dart';
import 'package:travel_app/pages/home_page.dart';
import 'package:travel_app/routes/app_routes.dart';

class App extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    ApiManager.instance.init(context);

    return MaterialApp(
      title: 'Travel App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: AppRoutes.home,
      routes: <String, WidgetBuilder>{
        AppRoutes.home: (context) => HomePage(),
      },
    );
  }
}
