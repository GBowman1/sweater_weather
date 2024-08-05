class ForecastSerializer
  include FastJsonapi::ObjectSerializer
  set_id { nil }
  set_type :forecast

  attribute :current_weather do |weather|
    weather.current_forecast
  end

  attribute :daily_weather do |weather|
    weather.daily_forecast
  end

  attribute :hourly_weather do |weather|
    weather.hourly_forecast
  end
end