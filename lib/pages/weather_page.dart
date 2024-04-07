import 'package:flutter/material.dart';
import 'package:weather_app/model/weather_model.dart';
import 'package:lottie/lottie.dart';
import 'package:weather_app/services/weather_service.dart';


class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {

  // api key
  final _weatherService = WeatherService("cf261a82637b54f9dcf06092630ae30a");
  Weather? _weather;

  //fetch weather
  _fetchWeather() async {
    // get current city
    String cityName = await _weatherService.getCurrentCity();

    //get weather for the city
    try{
      final weather = await _weatherService.getWeather(cityName);
      setState(() {
        _weather = weather;
      });
    }catch(e){
      print(e);
    }
  }

  //weather animations
  String getWeatherAnimation(String? mainCondition){
    if(mainCondition == null) return "assets/sunny.json";
    switch(mainCondition.toLowerCase()){
      case 'clouds':
      case "mist":
      case 'smoke':
      case 'haze':
      case 'dust':
      case 'fog':
        return 'assets/cloud-anime.json';
      case "rain":
      case 'drizzle':
      case 'shower rain':
        return 'assets/rainy.json';
      case "thunderstorm":
        return 'assets/thunder.json';
      case 'clear':
        return 'assets/sunny.json';
      default:
        return 'assets/sunny.json';

    }
  }

  //init state
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    //fetch weather on start-up
    _fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //city name
            Text(_weather?.cityName ?? "loading city.."  , style: TextStyle(fontSize: 40),),

            Lottie.asset(getWeatherAnimation(_weather?.mainCondition)),
            //temperature
            Text("${_weather?.temp.round()} °C" , style: TextStyle(fontSize: 25),),

            //weather condition
            Text(_weather?.mainCondition ?? "")
          ],
        ),
      ),
    );
  }
}
