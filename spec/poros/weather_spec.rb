require "rails_helper"

RSpec.describe Weather do
  let(:data) { JSON.parse(File.read('spec/fixtures/forecast_fixture.json'), symbolize_names: true) }
  let(:weather) { Weather.new(data) }
  describe 'Weather Object' do
    it "exists" do
      expect(weather).to be_a(Weather)
    end
    it "has attributes" do
      expect(weather.current_forecast).to be_a(Hash)
      expect(weather.daily_forecast).to be_a(Array)
      expect(weather.hourly_forecast).to be_a(Array)
    end
    it "can return current forecast" do
      expect(weather.current_forecast[:last_updated]).to eq("2024-08-04 20:00")
      expect(weather.current_forecast[:temperature]).to eq(94.7)
      expect(weather.current_forecast[:feels_like]).to eq(95.5)
      expect(weather.current_forecast[:humidity]).to eq(31)
      expect(weather.current_forecast[:uvi]).to eq(9.0)
      expect(weather.current_forecast[:visibility]).to eq(6.0)
      expect(weather.current_forecast[:condition]).to eq("Sunny")
      expect(weather.current_forecast[:icon]).to eq("//cdn.weatherapi.com/weather/64x64/day/113.png")
    end
    it "can return daily forecast" do
      expect(weather.daily_forecast.first[:date]).to eq("2024-08-04")
      expect(weather.daily_forecast.first[:sunrise]).to eq("06:43 AM")
      expect(weather.daily_forecast.first[:sunset]).to eq("08:22 PM")
      expect(weather.daily_forecast.first[:max_temp]).to eq(100.3)
      expect(weather.daily_forecast.first[:min_temp]).to eq(79.9)
      expect(weather.daily_forecast.first[:condition]).to eq("Sunny")
      expect(weather.daily_forecast.first[:icon]).to eq("//cdn.weatherapi.com/weather/64x64/day/113.png")
    end
    it "can return hourly forecast" do
      expect(weather.hourly_forecast.first[:time]).to eq("00:00")
      expect(weather.hourly_forecast.first[:temperature]).to eq(87.5)
      expect(weather.hourly_forecast.first[:conditions]).to eq("Clear ")
      expect(weather.hourly_forecast.first[:icon]).to eq("//cdn.weatherapi.com/weather/64x64/night/113.png")
    end
  end
end