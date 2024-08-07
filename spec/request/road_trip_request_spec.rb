require "rails_helper"

RSpec.describe "Road Trip Request", type: :request do
  before :each do
    @user = User.create!(email: "garrett.r.bowman@gmail.com", password: "password", password_confirmation: "password")

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
  end
  describe "POST /api/v1/road_trip" do
    it "returns a road trip object" do
      post "/api/v1/road_trip", params: {
        "origin": "seguin,tx",
        "destination": "dallas,tx",
        "api_key": @user.api_key
      }

      expect(response).to be_successful

      road_trip = JSON.parse(response.body, symbolize_names: true)

      expect(road_trip[:data][:id]).to eq(nil)
      expect(road_trip[:data][:type]).to eq("road_trip")
      expect(road_trip[:data][:attributes][:start_city]).to eq("seguin,tx")
      expect(road_trip[:data][:attributes][:end_city]).to eq("dallas,tx")
      expect(road_trip[:data][:attributes][:travel_time]).to eq("03 hours, 29 minutes")
      expect(road_trip[:data][:attributes][:weather_at_eta]).to be_a(Hash)
      expect(road_trip[:data][:attributes][:weather_at_eta][:temperature]).to eq("86.8 F")
      expect(road_trip[:data][:attributes][:weather_at_eta][:conditions]).to eq("Clear ")
    end
    it "returns an error if api key is incorrect" do
      post "/api/v1/road_trip", params: {
        "origin": "seguin,tx",
        "destination": "dallas,tx",
        "api_key": "NoTaReAlApIkEy"
      }

      error = JSON.parse(response.body, symbolize_names: true)[:error]
      expect(error[:status]).to eq(401)
      expect(error[:message]).to eq("Invalid Key")
    end
  end
end