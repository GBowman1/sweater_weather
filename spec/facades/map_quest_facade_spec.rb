require "rails_helper"

RSpec.describe MapQuestFacade do
  it "will return location data in a hash containing lat and lng" do
    stub_request(:get, "http://www.mapquestapi.com/geocoding/v1/address?key=#{Rails.application.credentials.mapquest[:api_key]}&location=Dallas,%20TX").
      with(
        headers: {
      'Accept'=>'*/*',
      'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
      'User-Agent'=>'Faraday v2.10.1'
        }).
      to_return(status: 200, body: File.read('spec/fixtures/location_fixture.json') , headers: {})

    location = "Dallas, TX"
    response = MapQuestFacade.get_grid(location)

    expect(response).to be_a(Hash)
    expect(response).to have_key(:lat)
    expect(response).to have_key(:lng)
  end
end