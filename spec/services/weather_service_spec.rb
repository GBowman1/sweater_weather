require 'rails_helper'

RSpec.describe WeatherService do
  it "returns forecast data for a location" do
    stub_request(:get, "https://api.weatherapi.com/v1/forecast.json?days=5&key=3c08dc2862914920b26205950240408&q=32.77822,-96.79512").
      with(
        headers: {
      'Accept'=>'*/*',
      'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
      'Content-Type'=>'application/json',
      'User-Agent'=>'Faraday v2.10.1'
        }).
      to_return(status: 200, body: File.read('spec/fixtures/forecast_fixture.json'), headers: {})

    location = { lat: 32.77822, lng: -96.79512 }
    weather_data = WeatherService.get_forecast(location)

    expect(weather_data).to have_key(:current)
    expect(weather_data[:current]).to have_key(:temp_f)
    expect(weather_data[:current]).to have_key(:feelslike_f)
    expect(weather_data[:current]).to have_key(:humidity)
    expect(weather_data[:current]).to have_key(:uv)
    expect(weather_data[:current]).to have_key(:vis_miles)
    expect(weather_data[:current]).to have_key(:condition)
    expect(weather_data[:current][:condition]).to have_key(:text)
    expect(weather_data[:current][:condition]).to have_key(:icon)
  end
end