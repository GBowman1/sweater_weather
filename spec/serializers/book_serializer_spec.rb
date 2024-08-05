require "rails_helper"

RSpec.describe BookSerializer, type: :request do
  describe "Book Serializer" do
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

      book_json = File.read('spec/fixtures/book_fixture.json')

      stub_request(:get, "https://openlibrary.org/search.json?limit=5&q=place:dallas,tx")
        .with(
          headers: {
        'Accept'=>'*/*',
        'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
        'User-Agent'=>'Faraday v2.10.1'
          })
        .to_return(status: 200, body: book_json, headers: {})
    end
    it "Serializes book weather data" do
      get "/api/v1/book-search?location=dallas,tx&quantity=5"

      expect(response).to be_successful

      book_data = JSON.parse(response.body, symbolize_names: true)

      expect(book_data).to have_key(:data)
      expect(book_data[:data]).to have_key(:id)
      expect(book_data[:data]).to have_key(:type)
      expect(book_data[:data]).to have_key(:attributes)

      expect(book_data[:data][:attributes]).to have_key(:destination)
      expect(book_data[:data][:attributes]).to have_key(:forecast)
      expect(book_data[:data][:attributes]).to have_key(:books)
      expect(book_data[:data][:attributes]).to have_key(:total_books_found)

      expect(book_data[:data][:id]).to eq(nil)
      expect(book_data[:data][:type]).to eq("books")
      expect(book_data[:data][:attributes][:forecast]).to have_key(:temperature)
      expect(book_data[:data][:attributes][:forecast]).to have_key(:summary)
      expect(book_data[:data][:attributes][:books].first).to have_key(:title)
      expect(book_data[:data][:attributes][:books].first).to have_key(:isbn)
      expect(book_data[:data][:attributes][:books].first).to have_key(:publisher)
    end
  end
end