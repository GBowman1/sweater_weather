class BookSerializer
  include FastJsonapi::ObjectSerializer
  set_id { nil }
  set_type :books

  attribute :destination do |book_weather|
    book_weather.destination
  end

  attribute :forecast do |book_weather|
    book_weather.forecast
  end

  attribute :total_books_found do |book_weather|
    book_weather.total_books_found
  end

  attribute :books do |book_weather|
    book_weather.books
  end
end