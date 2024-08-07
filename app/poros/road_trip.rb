class RoadTrip
  attr_reader :start_city, :end_city, :travel_time, :weather_at_eta
  def initialize(travel_data, weather, start_end_points)
    @travel_time = format_time(travel_data)
    @start_city = start_end_points[:start_city]
    @end_city = start_end_points[:end_city]
    @weather_at_eta = find_weather_at_eta(travel_data, weather)
  end

  def find_weather_at_eta(travel_data, weather)
    if travel_data[:info][:statuscode] == 402
      {}
    else
      eta = calculate_eta(travel_data)
      round_eta = eta.round(3600)
      epoch = round_eta.to_i

      eta_forecast = find_forecast_for_eta(epoch, weather)
      if eta_forecast
        {
          temperature: "#{eta_forecast[:temp_f]} F",
          conditions: eta_forecast[:condition][:text]
        }
      else
        "Could not find forecast for ETA"
      end
    end
  end

  def format_time(travel_data)
    if travel_data[:info][:statuscode] == 402
      "impossible"
    else
      time = travel_data[:route][:formattedTime]
      "#{time.split(":")[0]} hours, #{time.split(":")[1]} minutes"
    end
  end

  def calculate_eta(travel_data)
    Time.now + travel_data[:route][:realTime]
  end

  def find_forecast_for_eta(eta_epoch, weather)
    weather[:forecast][:forecastday].each do |day|
      forecast = day[:hour].find do |hour|
        hour[:time_epoch] >= eta_epoch
      end
      return forecast if forecast
    end
  end

end