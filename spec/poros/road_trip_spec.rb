require "rails_helper"

RSpec.describe RoadTrip do
  let(:travel_data) { JSON.parse(File.read('spec/fixtures/travel_fixture.json'), symbolize_names: true) }
  let(:weather_data) { JSON.parse(File.read('spec/fixtures/travel_weather_fixture.json'), symbolize_names: true) }
  let(:start_end_points) { { start_city: "Seguin", end_city: "Dallas" } }
  let(:road_trip) { RoadTrip.new(travel_data, weather_data, start_end_points) }

  describe 'RoadTrip Object' do
    it "exists" do
      expect(road_trip).to be_a(RoadTrip)
    end

    it "has attributes" do
      expect(road_trip.start_city).to eq("Seguin")
      expect(road_trip.end_city).to eq("Dallas")
      expect(road_trip.travel_time).to eq("03 hours, 29 minutes")
      expect(road_trip.weather_at_eta).to be_a(Hash)
    end

    it "can find weather at eta" do
      expect(road_trip.weather_at_eta).to eq({temperature: "86.8 F", conditions: "Clear "})
    end
  end
end