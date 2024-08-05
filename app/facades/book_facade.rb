class BookFacade
  def self.books_and_weather(location, quantity)
    grid = MapQuestFacade.get_grid(location)
    books = BookService.get_books(location, quantity)
    weather = WeatherService.get_forecast(grid)
    BookWeather.new(books, weather, location)
  end
end