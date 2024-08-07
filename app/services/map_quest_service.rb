class MapQuestService
  def self.conn
    Faraday.new('http://www.mapquestapi.com')
  end

  def self.get_grid(location)
    response = conn.get('/geocoding/v1/address') do |req|
      req.params['key'] = Rails.application.credentials.mapquest[:api_key]
      req.params['location'] = location
    end
    JSON.parse(response.body, symbolize_names: true)
  end

  def self.get_directions(origin, destination)
    response = conn.get('/directions/v2/route') do |req|
      req.params['key'] = Rails.application.credentials.mapquest[:api_key]
      req.params['from'] = origin
      req.params['to'] = destination
    end
    JSON.parse(response.body, symbolize_names: true)
  end
end