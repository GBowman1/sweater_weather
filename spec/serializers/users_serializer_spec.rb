require "rails_helper"

RSpec.describe UsersSerializer do
  it "can serialize a user signup/login response" do
    user = User.create!(email: 'garrett.r.bowman@gmail.com', password: 'password', password_confirmation: 'password')

    serialized_user = UsersSerializer.new(user).serializable_hash

    expect(serialized_user[:data][:type]).to eq(:users)
    expect(serialized_user[:data][:id]).to eq(user.id.to_s)
    expect(serialized_user[:data][:attributes][:email]).to eq(user.email)
    expect(serialized_user[:data][:attributes][:api_key]).to eq(user.api_key)
  end
end