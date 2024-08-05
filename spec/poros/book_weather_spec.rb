require "rails_helper"

RSpec.describe BookWeather do
  let(:weather) {JSON.parse(File.read('spec/fixtures/forecast_fixture.json'), symbolize_names: true)}
  let(:books) {JSON.parse(File.read('spec/fixtures/book_fixture.json'), symbolize_names: true)}
  let(:book_weather) { BookWeather.new(books, weather, "dallas, tx") }

  it "exists" do
    expect(book_weather).to be_a(BookWeather)
  end

  it "has attributes" do
    expect(book_weather.destination).to eq("dallas, tx")
    expect(book_weather.forecast).to be_a(Hash)
    expect(book_weather.books).to be_a(Array)
    expect(book_weather.total_books_found).to eq(2)
  end

  it "can format forecast" do
    expect(book_weather.forecast[:temperature]).to eq(94.7)
    expect(book_weather.forecast[:summary]).to eq("Sunny")
  end

  it "can format books" do
    expect(book_weather.books.first[:title]).to eq("The last investigation")
    expect(book_weather.books.first[:isbn]).to eq(
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
    expect(book_weather.books.first[:publisher]).to eq(
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
  end
end