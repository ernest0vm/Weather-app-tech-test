import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:travel_app/blocs/home_bloc.dart';
import 'package:travel_app/helpers/date_parser.dart';
import 'package:travel_app/models/weather_model.dart';
import 'package:travel_app/utils/colors.dart';
import 'package:travel_app/utils/enums.dart';
import 'package:travel_app/utils/styles.dart';
import 'package:travel_app/helpers/extensions.dart';

class HomePage extends StatefulWidget with HomeBloc {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //variables
  LinearGradient background = AppColors.verticalGradient;

  @override
  void initState() {
    widget.requestCities("monterrey");
    widget.requestWeather(19.99, -99.998);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedContainer(
        decoration: BoxDecoration(
          gradient: background,
        ),
        duration: Duration(seconds: 1),
        child: RefreshIndicator(
          onRefresh: () => widget.requestWeather(19.99, -99.99),
          child: body(),
        ),
      ),
    );
  }

  Widget body() => SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            searchBar(),
            mainCard(),
            sectionTitle('Weather forecast'),
            forecastWeekList(),
            sectionTitle('Today'),
            forecastTodayList(),
          ],
        ),
      );

  Widget searchBar() => Padding(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: TextFormField(
          style: AppStyles.sectionTitleDark,
          decoration: InputDecoration(
            hintText: 'Find a place?',
            hintStyle: AppStyles.sectionTitleDark,
            focusedBorder: InputBorder.none,
            border: InputBorder.none,
            suffixIcon: IconButton(
              icon: Icon(Icons.search),
              onPressed: null,
            ),
          ),
          keyboardType: TextInputType.name,
          textInputAction: TextInputAction.search,
          onEditingComplete: () {
            FocusScope.of(context).unfocus();
          },
        ),
      );

  Widget sectionTitle(String title) => Padding(
        padding: EdgeInsets.only(left: 20),
        child: Text(
          title,
          style: AppStyles.sectionTitleDark,
        ),
      );

  Widget mainCard() => Container(
        width: MediaQuery.of(context).size.width * 0.8,
        height: MediaQuery.of(context).size.height * 0.4,
        margin: EdgeInsets.all(10),
        padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
        child: StreamBuilder<WeatherModel>(
          stream: widget.getWeatherStream,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text("Ocurrio un error.");
            } else if (snapshot.hasData) {
              return mainCardContent(snapshot.data.current);
            }
            return Text("Cargando datos climaticos.");
          },
        ),
      );

  Widget mainCardContent(Current current) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                DateParser.getDate(current.dt),
                style: AppStyles.dailyForeCastDate,
              ),
              Text(
                current.weather.first.description.capitalize(),
                style: AppStyles.dailyForeCastDescription,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.network(
                widget.getIconUrl(context, current.weather.first.icon),
                scale: 0.8,
              ),
              Text(
                '${current.temp.toStringAsFixed(1)}°',
                style: AppStyles.currentTemp,
              ),
            ],
          ),
          currentWeatherExtras(current),
        ],
      );

  Widget currentWeatherExtras(Current current) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          currentWeatherExtraItem(
              FontAwesomeIcons.wind, '${current.windSpeed} \nm/s'),
          currentWeatherExtraItem(
              FontAwesomeIcons.tachometerAlt, '${current.pressure} \nhPa'),
          currentWeatherExtraItem(
              FontAwesomeIcons.tint, '${current.humidity} \n%'),
        ],
      );

  Widget currentWeatherExtraItem(IconData icon, String text) => Container(
        padding: EdgeInsets.all(20),
        margin: EdgeInsets.zero,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(
              icon,
              size: 30,
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              text,
              textAlign: TextAlign.center,
              style: AppStyles.weatherExtraItemText,
            ),
          ],
        ),
      );

  Widget forecastWeek() => Container(
        height: MediaQuery.of(context).size.height * 0.35,
        child: StreamBuilder<WeatherModel>(
          stream: widget.getWeatherStream,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text("Ocurrio un error.");
            } else if (snapshot.hasData) {
              if (snapshot.data.daily.isEmpty) {
                return Text("No hay datos climaticos.");
              } else {
                List<Daily> dailyList = snapshot.data.daily;
                if (dailyList.length > 7) {
                  dailyList.remove(dailyList.first);
                }

                return CarouselSlider(
                  options: CarouselOptions(
                    enableInfiniteScroll: false,
                    aspectRatio: 1,
                    enlargeCenterPage: true,
                    initialPage: 0,
                    viewportFraction: 0.7,
                    onPageChanged: (index, reason) {},
                  ),
                  items: List.generate(dailyList.length,
                      (index) => forecastItem(dailyList[index])),
                );
              }
            }

            return Text("Cargando datos climaticos.");
          },
        ),
      );

  Widget forecastWeekList() => Container(
        height: MediaQuery.of(context).size.height * 0.2,
        child: StreamBuilder<WeatherModel>(
          stream: widget.getWeatherStream,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text("Ocurrio un error.");
            } else if (snapshot.hasData) {
              if (snapshot.data.daily.isEmpty) {
                return Text("No hay datos climaticos.");
              } else {
                List<Daily> dailyList = snapshot.data.daily;
                if (dailyList.length > 7) {
                  dailyList.remove(dailyList.first);
                }

                return Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(
                      dailyList.length,
                      (index) => simpleForecastItem(dailyList[index]),
                    ),
                  ),
                );
              }
            }

            return Text("Cargando datos climaticos.");
          },
        ),
      );

  Widget simpleForecastItem(Daily daily) => GestureDetector(
        onTap: () => showDialog(
          context: context,
          useSafeArea: true,
          barrierColor: Colors.white54,
          barrierDismissible: true,
          child: forecastItem(daily),
        ),
        child: Column(
          children: [
            Text(
              DateParser.getDate(daily.dt).split(',').first,
              style: AppStyles.dailyForeCastDate,
            ),
            Image.network(
              widget.getIconUrl(context, daily.weather.first.icon),
              scale: 2.5,
            ),
            Text(
              '${daily.temp.max.toStringAsFixed(1)}°',
              style: AppStyles.simpleForecastItemMax,
            ),
            Text(
              '${daily.temp.min.toStringAsFixed(1)}°',
              style: AppStyles.simpleForecastItemMin,
            ),
          ],
        ),
      );

  Widget forecastItem(Daily daily) => Material(
        type: MaterialType.transparency,
        child: Center(
          child: Container(
            padding: EdgeInsets.all(10),
            margin: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white),
              boxShadow: [
                BoxShadow(color: Colors.grey, blurRadius: 5),
              ],
            ),
            child: forecastItemContent(daily),
          ),
        ),
      );

  Widget forecastItemContent(Daily daily) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      DateParser.getDate(daily.dt),
                      style: AppStyles.dailyForeCastDate,
                    ),
                    IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    )
                  ],
                ),
                Text(
                  daily.weather.first.description.capitalize(),
                  style: AppStyles.dailyForeCastDescription,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.network(
                  widget.getIconUrl(context, daily.weather.first.icon),
                  scale: 0.8,
                ),
                Text(
                  '${daily.temp.day.toStringAsFixed(1)}°',
                  style: AppStyles.currentTemp,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                temperatureChip(
                    TemperatureType.max, daily.temp.max.toStringAsFixed(1)),
                temperatureChip(
                    TemperatureType.min, daily.temp.min.toStringAsFixed(1)),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                currentWeatherExtraItem(
                    FontAwesomeIcons.wind, '${daily.windSpeed} m/s'),
                currentWeatherExtraItem(
                    FontAwesomeIcons.tachometerAlt, '${daily.pressure} hPa'),
                currentWeatherExtraItem(
                    FontAwesomeIcons.tint, '${daily.humidity} %'),
              ],
            ),
          ],
        ),
      );

  Widget temperatureChip(TemperatureType type, String temperature) => Chip(
        label: Text(
            '${(type == TemperatureType.max ? "Max" : "Min")}: $temperature°'),
        shape: StadiumBorder(),
        backgroundColor: Colors.transparent,
        avatar: Icon(
          type == TemperatureType.max
              ? Icons.arrow_drop_up_sharp
              : Icons.arrow_drop_down_sharp,
          color: type == TemperatureType.max
              ? Colors.redAccent
              : Colors.blueAccent,
          size: 26,
        ),
        elevation: 1,
      );

  Widget forecastTodayList() => Container(
        child: StreamBuilder<WeatherModel>(
          stream: widget.getWeatherStream,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text("Ocurrio un error.");
            } else if (snapshot.hasData) {
              if (snapshot.data.daily.isEmpty) {
                return Text("No hay datos climaticos.");
              } else {
                List<Hourly> hourlyList = snapshot.data.hourly;
                // hourlyList.re

                return Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(
                      hourlyList.length,
                      (index) => foreCastTodayItem(hourlyList[index]),
                    ),
                  ),
                );
              }
            }

            return Text("Cargando datos climaticos.");
          },
        ),
      );

  Widget foreCastTodayItem(Hourly hourly) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            DateParser.getDateTime(hourly.dt).split('-')[1],
            style: AppStyles.simpleForecastItemMax,
          ),
          Image.network(
            widget.getIconUrl(context, hourly.weather.first.icon),
            scale: 2.5,
          ),
          Text(
            '${hourly.humidity} %',
            style: AppStyles.simpleForecastItemMax,
          ),
          Text(
            '${hourly.temp.toStringAsFixed(1)}°',
            style: AppStyles.simpleForecastItemMax,
          ),
        ],
      );
}
