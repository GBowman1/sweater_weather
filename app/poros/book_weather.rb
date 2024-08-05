class BookWeather
  attr_reader :forecast, :book_deatils, :total_books_found
  def initialize(books, weather)
    @forecast = format_forecast_current(weather[:current])
    @books = format_books(books[:docs])
    @total_books_found = books[:numFound]
    @destination = @location
  end

  def format_forecast_current(data)
    {
      temperature: data[:temp_f],
      summary: data[:condition][:text]
    }
  end

  def format_books(data)
    data.map do |book|
      {
        title: book[:title],
        isbn: book[:isbn],
        publisher: book[:publisher]
      }
    end
  end
end