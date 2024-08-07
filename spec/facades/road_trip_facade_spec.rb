require "rails_helper"

RSpec.describe RoadTripFacade do
  it "will return a road trip object" do
    stub_request(:get, "https://api.weatherapi.com/v1/forecast.json?days=5&key=#{Rails.application.credentials.weatherapi[:api_key]}&q=32.77822,-96.79512").to_return(status: 200, body: File.read('spec/fixtures/travel_weather_fixture.json'), headers: {})

    stub_request(:get, "http://www.mapquestapi.com/geocoding/v1/address?key=#{Rails.application.credentials.mapquest[:api_key]}&location=dallas,tx").
        with(
          headers: {
        'Accept'=>'*/*',
        'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
        'User-Agent'=>'Faraday v2.10.1'
          }).
        to_return(status: 200, body: File.read('spec/fixtures/location_fixture.json'), headers: {})

    stub_request(:get, "http://www.mapquestapi.com/directions/v2/route?from=seguin,tx&key=#{Rails.application.credentials.mapquest[:api_key]}&to=dallas,tx").
        with(
          headers: {
        'Accept'=>'*/*',
        'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
        'User-Agent'=>'Faraday v2.10.1'
          }).
        to_return(status: 200, body: File.read('spec/fixtures/travel_fixture.json'), headers: {})

    road_trip = RoadTripFacade.create_road_trip("seguin,tx", "dallas,tx")

    expect(road_trip).to be_a(RoadTrip)
    expect(road_trip.start_city).to eq("seguin,tx")
    expect(road_trip.end_city).to eq("dallas,tx")
    expect(road_trip.travel_time).to eq("03 hours, 29 minutes")
    expect(road_trip.weather_at_eta).to be_a(Hash)
  end
end