class WeatherService

  def self.conn
    Faraday.new('https://api.weatherapi.com') do |req|
      req.headers['Content-Type'] = 'application/json'
    end
  end

  def self.get_forecast(location)
    response = conn.get('/v1/forecast.json') do |req|
      req.params['key'] = Rails.application.credentials.weatherapi[:api_key]
      req.params['q'] = "#{location[:lat]},#{location[:lng]}"
      req.params['days'] = 5
    end
    JSON.parse(response.body, symbolize_names: true)
  end
end