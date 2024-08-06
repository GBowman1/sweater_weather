require "rails_helper"

RSpec.describe "Sessions", type: :request do
  describe "POST /sessions" do
    it "returns http success" do
      test = User.create!(email: "garrett.r.bowman@gmail.com", password: "password", password_confirmation: "password")
      post "/api/v1/sessions", params:  { email: "garrett.r.bowman@gmail.com", password: "password" } 

      expect(response).to be_successful

      body = JSON.parse(response.body, symbolize_names: true)

      expect(body).to have_key(:data)
      expect(body[:data][:id]).to eq(test.id.to_s)
      expect(body[:data][:type]).to eq("users")
      expect(body[:data][:attributes][:email]).to eq(test.email)
      expect(body[:data][:attributes][:api_key]).to eq(test.api_key)
    end
    it "returns error if credentials dont match the record" do
      User.create!(email: "garrett.r.bowman@gmail.com", password: "password", password_confirmation: "password")
      post "/api/v1/sessions", params:  { email: "garrett.r.bowman@gmail.com", password: "pass" }

      expect(response).to_not be_successful

      body = JSON.parse(response.body, symbolize_names: true)

      expect(body[:error][:status]).to eq(400)
      expect(body[:error][:message]).to eq("Invalid Credentials")
    end
  end
end