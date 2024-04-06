require 'json'
require 'net/http'
require 'uri'


class WeatherApiCall
    def fetch_weather_info
      uri = URI("https://api.open-meteo.com/v1/forecast?latitude=29.95&longitude=-90.07&current=temperature_2m,wind_speed_10m&hourly=temperature_2m,relative_humidity_2m,wind_speed_10m")
      response = Net::HTTP.get(uri)
      data = JSON.parse(response)
      
      data["current"]
    end
  end