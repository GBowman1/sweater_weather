require "rails_helper"

RSpec.describe "Book Search Request", type: :request do
  describe "get /api/v1/book-search" do
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
    it "can get books about a location with weather data" do
      get "/api/v1/book-search?location=dallas,tx&quantity=5"

      expect(response).to be_successful

      book_data = JSON.parse(response.body, symbolize_names: true)

      expect(book_data).to have_key(:data)
      expect(book_data[:data]).to have_key(:id)
      expect(book_data[:data]).to have_key(:type)
      expect(book_data[:data]).to have_key(:attributes)
      expect(book_data[:data][:id]).to eq(nil)
      expect(book_data[:data][:type]).to eq("books")
      expect(book_data[:data][:attributes]).to have_key(:destination)
      expect(book_data[:data][:attributes]).to have_key(:forecast)
      expect(book_data[:data][:attributes]).to have_key(:books)
      expect(book_data[:data][:attributes]).to have_key(:total_books_found)

      attributes = book_data[:data][:attributes]
      expect(attributes[:forecast][:temperature]).to eq("94.7 F")
      expect(attributes[:forecast][:summary]).to eq("Sunny")
      expect(attributes[:books].first[:title]).to eq("The last investigation")
      expect(attributes[:books].first[:isbn]).to eq(
        [
                "1560250526",
                "9781560250791",
                "1626360782",
                "1628734973",
                "9781510713932",
                "9780980121353",
                "9781626360785",
                "0980121353",
                "9781510740327",
                "151071393X",
                "1560250798",
                "9781560250524",
                "9781628734973",
                "9781510740358",
                "1510740325",
                "151074035X"
            ]
      )
      expect(attributes[:books].first[:publisher]).to eq(
        [
                "Brand: The Mary Ferrell Foundation",
                "Skyhorse",
                "Thunder's Mouth P.",
                "Thunder's Mouth Press",
                "The Mary Ferrell Foundation",
                "Distributed by Publishers Group West",
                "Skyhorse Publishing Company, Incorporated"
            ]
      )
      expect(attributes[:total_books_found]).to eq(2)
      expect(attributes[:destination]).to eq("dallas,tx")


      

    end
    it "returns an error if quantity is less then 0" do
      get "/api/v1/book-search?location=dallas,tx&quantity=-1"

      expect(response).to_not be_successful

      error = JSON.parse(response.body, symbolize_names: true)

      expect(error[:error][:message]).to eq("Quantity Can't Be Less Than 0")
      expect(error[:error][:status]).to eq(400)
    end
  end
end