class WeatherResponse {
  const WeatherResponse({required this.clouds});
  final int clouds;

  factory WeatherResponse.fromJson(json){
    return WeatherResponse(
      clouds: json['clouds']['all'],
      );
  }
}
