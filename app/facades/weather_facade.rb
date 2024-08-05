class WeatherFacade
  def self.weather_data(location)
    data = WeatherService.get_forecast(location)
    Weather.new(data)
  end
end