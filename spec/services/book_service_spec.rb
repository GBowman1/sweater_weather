require "rails_helper"

RSpec.describe BookService do
  it "can get books about a location" do
    fixture = File.read("spec/fixtures/book_fixture.json")
    stub_request(:get, "https://openlibrary.org/search.json?q=place:dallas,tx&limit=5").to_return(status: 200, body: fixture, headers: { 'Content-Type' => 'application/json' })

    response = BookService.get_books("dallas,tx", 5)

    expect(response).to have_key(:docs)
    expect(response).to have_key(:numFound)
    expect(response[:numFound]).to eq(2)

    books = response[:docs].first
    expect(books).to be_an(Hash)
    expect(books).to have_key(:title)
    expect(books).to have_key(:isbn)
    expect(books).to have_key(:publisher)
  end
end