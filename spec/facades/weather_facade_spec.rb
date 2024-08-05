require "rails_helper"

RSpec.describe WeatherFacade do
  it "will return weather data objects" do
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
    weather = WeatherFacade.weather_data(location)

    expect(weather).to be_a(Weather)
    expect(weather.current_forecast).to be_a(Hash)
    expect(weather.daily_forecast).to be_a(Array)
    expect(weather.hourly_forecast).to be_a(Array)
  end
end