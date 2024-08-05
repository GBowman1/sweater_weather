require "rails_helper"

describe MapQuestService do
  it "can get location data" do
    stub_request(:get, "http://www.mapquestapi.com/geocoding/v1/address?key=#{Rails.application.credentials.mapquest[:api_key]}&location=Dallas,%20TX").
      with(
        headers: {
      'Accept'=>'*/*',
      'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
      'User-Agent'=>'Faraday v2.10.1'
        }).
      to_return(status: 200, body: File.read('spec/fixtures/location_fixture.json') , headers: {})

    location = "Dallas, TX"
    response = MapQuestService.get_grid(location)

    expect(response).to be_a(Hash)
    expect(response).to have_key(:results)
    expect(response[:results].first).to have_key(:locations)
    expect(response[:results].first[:locations].first).to have_key(:latLng)
    expect(response[:results].first[:locations].first[:latLng]).to have_key(:lat)
    expect(response[:results].first[:locations].first[:latLng]).to have_key(:lng)
  end
end