class Weather
  attr_reader :current_forecast, :daily_forecast, :hourly_forecast

  def initialize(data)
    @current_forecast = format_forecast_current(data[:current])
    @daily_forecast = format_forecast_daily(data[:forecast][:forecastday])
    @hourly_forecast = format_forecast_hourly(data[:forecast][:forecastday])
  end

  def format_forecast_current(data)
    {
      last_updated: data[:last_updated],
      temperature: data[:temp_f],
      feels_like: data[:feelslike_f],
      humidity: data[:humidity],
      uvi: data[:uv],
      visibility: data[:vis_miles],
      condition: data[:condition][:text],
      icon: data[:condition][:icon]
    }
  end

  def format_forecast_daily(data)
    data.map do |day|
      {
        date: day[:date],
        sunrise: day[:astro][:sunrise],
        sunset: day[:astro][:sunset],
        max_temp: day[:day][:maxtemp_f],
        min_temp: day[:day][:mintemp_f],
        condition: day[:day][:condition][:text],
        icon: day[:day][:condition][:icon]
      }
    end
  end

  def format_forecast_hourly(data)
    data.flat_map do |day|
      day[:hour].map do |hour|
        {
          time: hour[:time].split(' ').last,
          temperature: hour[:temp_f],
          conditions: hour[:condition][:text],
          icon: hour[:condition][:icon]
        }
      end
    end
  end
end