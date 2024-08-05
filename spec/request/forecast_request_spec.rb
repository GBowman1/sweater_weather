require "rails_helper"

RSpec.describe "Forecast Request", type: :request do
  describe "GET /api/v1/forecast" do
    before(:each) do
      location_json = File.read('spec/fixtures/location_fixture.json')
      stub_request(:get, "http://www.mapquestapi.com/geocoding/v1/address?key=#{Rails.application.credentials.mapquest[:api_key]}&location=dallas,tx")
        .with(
          headers: {
        'Accept'=>'*/*',
        'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
        'User-Agent'=>'Faraday v2.10.1'
          })
        .to_return(status: 200, body: location_json, headers: {})

      forecast_json = File.read('spec/fixtures/forecast_fixture.json')

      stub_request(:get, "https://api.weatherapi.com/v1/forecast.json?days=5&key=#{Rails.application.credentials.weatherapi[:api_key]}&q=32.77822,-96.79512")
        .with(
          headers: {
        'Accept'=>'*/*',
        'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
        'Content-Type'=>'application/json',
        'User-Agent'=>'Faraday v2.10.1'
          })
        .to_return(status: 200, body: forecast_json, headers: {})
    end
    it "returns forecast data for a location" do
      get "/api/v1/forecast?location=dallas,tx"

      expect(response).to be_successful
      
      weather_data = JSON.parse(response.body, symbolize_names: true)

      current_weather = weather_data[:data][:attributes][:current_weather]

      expect(current_weather[:last_updated]).to eq("2024-08-04 20:00")
      expect(current_weather[:temperature]).to eq(94.7)
      expect(current_weather[:feels_like]).to eq(95.5)
      expect(current_weather[:humidity]).to eq(31)
      expect(current_weather[:uvi]).to eq(9.0)
      expect(current_weather[:visibility]).to eq(6.0)
      expect(current_weather[:condition]).to eq("Sunny")
      expect(current_weather[:icon]).to eq("//cdn.weatherapi.com/weather/64x64/day/113.png")

      daily_weather = weather_data[:data][:attributes][:daily_weather].first

      expect(daily_weather[:date]).to eq("2024-08-04")
      expect(daily_weather[:sunrise]).to eq("06:43 AM")
      expect(daily_weather[:sunset]).to eq("08:22 PM")
      expect(daily_weather[:max_temp]).to eq(100.3)
      expect(daily_weather[:min_temp]).to eq(79.9)
      expect(daily_weather[:condition]).to eq("Sunny")
      expect(daily_weather[:icon]).to eq("//cdn.weatherapi.com/weather/64x64/day/113.png")

      hourly_weather = weather_data[:data][:attributes][:hourly_weather].first
      expect(hourly_weather[:time]).to eq("00:00")
      expect(hourly_weather[:temperature]).to eq(87.5)
      expect(hourly_weather[:conditions]).to eq("Clear ")
      expect(hourly_weather[:icon]).to eq("//cdn.weatherapi.com/weather/64x64/night/113.png")
    end
  end
end