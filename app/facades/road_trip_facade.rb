class RoadTripFacade
  def self.create_road_trip(origin, destination)
    travel_data = MapQuestService.get_directions(origin, destination)
    destination_location = MapQuestFacade.get_grid(destination)
    weather = WeatherService.get_forecast(destination_location)
    start_end_points = { start_city: origin, end_city: destination }
    RoadTrip.new(travel_data, weather, start_end_points)
  end
end