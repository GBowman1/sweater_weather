class RoadTripFacade
  def self.create_road_trip(origin, destination)
    travel_data = MapQuestService.get_directions(origin, destination)
    destination_location = MapQuestService.get_grid(destination)
    weather = WeatherService.get_forecast(destination_location[:lat], destination_location[:lng])

    RoadTrip.new(travel_data, weather)
  end
end