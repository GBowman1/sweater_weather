require 'rails_helper'

RSpec.describe BookFacade, type: :facade do
  describe 'class methods' do
    before :each do
      book_json = File.read('spec/fixtures/book_fixture.json')
      stub_request(:get, "https://openlibrary.org/search.json?limit=5&q=place:dallas,%20tx")
        .with(
          headers: {
            'Accept'=>'*/*',
            'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
            'User-Agent'=>'Faraday v2.10.1'
          })
        .to_return(status: 200, body: book_json, headers: {})
      weather_json = File.read('spec/fixtures/forecast_fixture.json')
      stub_request(:get, "https://api.weatherapi.com/v1/forecast.json?days=5&key=#{Rails.application.credentials.weatherapi[:api_key]}&q=32.77822,-96.79512")
        .with(
          headers: {
            'Accept'=>'*/*',
            'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
            'User-Agent'=>'Faraday v2.10.1'
          })
        .to_return(status: 200, body: weather_json, headers: {})
      location_json = File.read('spec/fixtures/location_fixture.json')
      stub_request(:get, "http://www.mapquestapi.com/geocoding/v1/address?key=#{Rails.application.credentials.mapquest[:api_key]}&location=dallas,%20tx")
        .with(
          headers: {
          'Accept'=>'*/*',
          'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
          'User-Agent'=>'Faraday v2.10.1'
          })
        .to_return(status: 200, body: location_json, headers: {})
    end

    it ".books_and_weather uses 3 services for location, weather, and books to create BookWeather Objects" do
      book_weather = BookFacade.books_and_weather("dallas, tx", 5)

      expect(book_weather).to be_a(BookWeather)
      expect(book_weather.destination).to eq("dallas, tx")
      expect(book_weather.forecast).to be_a(Hash)
      expect(book_weather.forecast[:temperature]).to eq("94.7 F")
      expect(book_weather.forecast[:summary]).to eq("Sunny")
      expect(book_weather.books).to be_an(Array)
      expect(book_weather.total_books_found).to eq(2)
    end
  end
end