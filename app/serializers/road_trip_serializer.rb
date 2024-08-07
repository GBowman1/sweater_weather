class RoadTripSerializer
  include FastJsonapi::ObjectSerializer
  set_id { nil }
  set_type :road_trip
  attributes :start_city, :end_city, :travel_time, :weather_at_eta
end