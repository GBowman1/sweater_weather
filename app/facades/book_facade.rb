class BookFacade
  def self.books_and_weather(location, quantity)
    books = BookService.get_books(location, quantity)
    weather = WeatherService.get_forecast(location)
    BookWeather.new(books, weather, location)
  end
end