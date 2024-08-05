class BookService
  
  def self.conn
    Faraday.new(url: "https://openlibrary.org") do |faraday|
    end
  end

  def self.get_books(location, quantity)
    response = conn.get("/search.json?q=place:#{location}&limit=#{quantity}")
    JSON.parse(response.body, symbolize_names: true)
  end
end