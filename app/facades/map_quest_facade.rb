class MapQuestFacade
  def self.get_grid(location)
    response = MapQuestService.get_grid(location)
    grid_coords = response[:results][0][:locations][0][:latLng]
    { lat: grid_coords[:lat], lng: grid_coords[:lng] }
  end
end