require "rails_helper"

RSpec.describe ForecastSerializer, type: :request do
  describe "Forecast Serializer" do
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
    it "Serializes forecast data" do
      get "/api/v1/forecast?location=dallas,tx"

      expect(response).to be_successful

      weather_data = JSON.parse(response.body, symbolize_names: true)

      expect(weather_data).to have_key(:data)
      expect(weather_data[:data]).to have_key(:id)
      expect(weather_data[:data]).to have_key(:type)
      expect(weather_data[:data]).to have_key(:attributes)
      expect(weather_data[:data][:attributes][:id]).to eq(nil)
      expect(weather_data[:data][:type]).to eq("forecast")

      expect(weather_data[:data][:attributes]).to have_key(:current_weather)
      expect(weather_data[:data][:attributes]).to have_key(:daily_weather)
      expect(weather_data[:data][:attributes]).to have_key(:hourly_weather)

      current_weather = weather_data[:data][:attributes][:current_weather]
      expect(current_weather).to have_key(:last_updated)
      expect(current_weather).to have_key(:temperature)
      expect(current_weather).to have_key(:feels_like)
      expect(current_weather).to have_key(:humidity)
      expect(current_weather).to have_key(:uvi)
      expect(current_weather).to have_key(:visibility)
      expect(current_weather).to have_key(:condition)
      expect(current_weather).to have_key(:icon)

      daily_weather = weather_data[:data][:attributes][:daily_weather].first
      expect(daily_weather).to have_key(:date)
      expect(daily_weather).to have_key(:sunrise)
      expect(daily_weather).to have_key(:sunset)
      expect(daily_weather).to have_key(:max_temp)
      expect(daily_weather).to have_key(:min_temp)
      expect(daily_weather).to have_key(:condition)
      expect(daily_weather).to have_key(:icon)

      hourly_weather = weather_data[:data][:attributes][:hourly_weather].first
      expect(hourly_weather).to have_key(:time)
      expect(hourly_weather).to have_key(:temperature)
      expect(hourly_weather).to have_key(:conditions)
      expect(hourly_weather).to have_key(:icon)

    end
  end
end
# current_weather, holds current weather data:
  # last_updated, in a human-readable format such as “2023-04-07 16:30”
  # temperature, floating point number indicating the current temperature in Fahrenheit
  # feels_like, floating point number indicating a temperature in Fahrenheit
  # humidity, numeric (int or float)
  # uvi, numeric (int or float)
  # visibility, numeric (int or float)
  # condition, the text description for the current weather condition
  # icon, png string for current weather condition

# daily_weather, array of the next 5 days of daily weather data:
  # date, in a human-readable format such as “2023-04-07”
  # sunrise, in a human-readable format such as “07:13 AM”
  # sunset, in a human-readable format such as “08:07 PM”
  # max_temp, floating point number indicating the maximum expected temperature in Fahrenheit
  # min_temp, floating point number indicating the minimum expected temperature in Fahrenheit
  # condition, the text description for the weather condition
  # icon, png string for weather condition

# hourly_weather, array of all 24 hour’s hour data for the current day:
  # time, in a human-readable format such as “22:00”
  # temperature, floating point number indicating the temperature in Fahrenheit for that hour
  # conditions, the text description for the weather condition at that hour
  # icon, string, png string for weather condition at that hour
