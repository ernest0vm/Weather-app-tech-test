import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:travel_app/blocs/home_bloc.dart';
import 'package:travel_app/helpers/date_parser.dart';
import 'package:travel_app/models/places_model.dart';
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
  final LinearGradient background = AppColors.verticalGradient;
  TextEditingController searchController = TextEditingController();
  FocusNode searchFocusNode = FocusNode();

  @override
  void initState() {
    widget.requestLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: background,
        ),
        child: GestureDetector(
          onTap: () => dismissKeyboard(),
          child: RefreshIndicator(
            onRefresh: () async {
              PlacesModel selectedPlace = widget.getSelectedPlace;
              if (selectedPlace != null) {
                dismissKeyboard();
                widget.requestWeather(selectedPlace.lat, selectedPlace.long);
              } else {
                widget.requestLocation();
              }

              return;
            },
            child: body(),
          ),
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

  Widget searchBar() => Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: TextFormField(
              controller: searchController,
              focusNode: searchFocusNode,
              style: AppStyles.sectionTitleDark,
              decoration: InputDecoration(
                hintText: 'Find a place?',
                hintStyle: AppStyles.sectionTitleDark,
                focusColor: Colors.transparent,
                focusedBorder: InputBorder.none,
                border: InputBorder.none,
                filled: false,
                fillColor: Colors.transparent,
                suffixIcon: IconButton(
                  icon: Icon(
                    Icons.search,
                    color: Colors.black,
                    size: 30,
                  ),
                  onPressed: () => widget.requestCities(searchController.text),
                ),
              ),
              keyboardType: TextInputType.name,
              textInputAction: TextInputAction.search,
              onEditingComplete: () {
                FocusScope.of(context).unfocus();
                widget.requestCities(searchController.text);
              },
              onChanged: (city) {
                if (city.isNotEmpty) {
                  widget.requestCities(city);
                } else {
                  dismissKeyboard();
                }
              },
              onTap: () {
                FocusScope.of(context).requestFocus(searchFocusNode);
              },
            ),
          ),
          StreamBuilder(
            stream: widget.getPlacesListStream,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Container(
                  height: 250,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(15),
                      bottomRight: Radius.circular(15),
                    ),
                  ),
                  child: StreamBuilder<List<PlacesModel>>(
                    stream: widget.getPlacesListStream,
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return errorMessage();
                      } else if (snapshot.hasData) {
                        List<PlacesModel> placesList = snapshot.data;
                        if (placesList.isEmpty) {
                          return emptyListMessage();
                        } else {
                          return ListView.builder(
                            itemCount: placesList.length,
                            itemBuilder: (context, index) {
                              return Material(
                                child: ListTile(
                                  onTap: () {
                                    widget.setSelectedPlace(placesList[index]);
                                    widget.requestWeather(
                                        widget.getSelectedPlace.lat,
                                        widget.getSelectedPlace.long);
                                    dismissKeyboard();
                                  },
                                  title: Text(placesList[index].cityName),
                                  subtitle: Text(
                                      '${placesList[index].state}, ${placesList[index].country}'),
                                ),
                              );
                            },
                          );
                        }
                      }

                      return Container();
                    },
                  ),
                );
              }

              return Container();
            },
          ),
        ],
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
        height: MediaQuery.of(context).size.height * 0.45,
        margin: EdgeInsets.all(10),
        padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
        child: StreamBuilder<WeatherModel>(
          stream: widget.getWeatherStream,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return errorMessage();
            } else if (snapshot.hasData) {
              return mainCardContent(snapshot.data.current);
            }
            return loader();
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
              StreamBuilder<PlacesModel>(
                stream: widget.getSelectedPlaceStream,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Text(
                      '${snapshot.data.cityName.capitalize()}, ${snapshot.data.state.capitalize()}',
                      style: AppStyles.dailyForeCastDescription,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    );
                  }

                  return Container();
                },
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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                current.weather.first.description.capitalize(),
                style: AppStyles.dailyForeCastDescription,
                textAlign: TextAlign.center,
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
              FontAwesomeIcons.wind, '${current.windSpeed} m/s'),
          currentWeatherExtraItem(
              FontAwesomeIcons.tachometerAlt, '${current.pressure} hPa'),
          currentWeatherExtraItem(
              FontAwesomeIcons.tint, '${current.humidity} %'),
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
              color: Colors.black54,
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
              return errorMessage();
            } else if (snapshot.hasData) {
              if (snapshot.data.daily.isEmpty) {
                return emptyListMessage();
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

            return loader();
          },
        ),
      );

  Widget forecastWeekList() => Container(
        height: MediaQuery.of(context).size.height * 0.2,
        child: StreamBuilder<WeatherModel>(
          stream: widget.getWeatherStream,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return errorMessage();
            } else if (snapshot.hasData) {
              if (snapshot.data.daily.isEmpty) {
                return emptyListMessage();
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

            return loader();
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
              return errorMessage();
            } else if (snapshot.hasData) {
              if (snapshot.data.daily.isEmpty) {
                return emptyListMessage();
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

            return loader();
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

  Widget loader() => Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Loading data...'),
            SizedBox(
              width: 150,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: LinearProgressIndicator(),
              ),
            )
          ],
        ),
      );

  Widget errorMessage() => Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.cancel, size: 40, color: Colors.redAccent),
            SizedBox(
              height: 10,
            ),
            Text('Ops, an error occurred...'),
          ],
        ),
      );

  Widget emptyListMessage() => Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.list, size: 40, color: Colors.grey),
            SizedBox(
              height: 10,
            ),
            Text('No data to show...'),
          ],
        ),
      );

  void dismissKeyboard() {
    FocusScope.of(context).unfocus();
    widget.setPlaces(null);
    searchController.clear();
  }
}
