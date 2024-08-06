require "rails_helper"

RSpec.describe 'Users Endpoints', type: :request do
  describe 'POST /api/v1/users' do
    it 'can create a new user' do
      user_params = {
        email: 'garrett.r.bowman@gmail.com',
        password: 'password',
        password_confirmation: 'password'
      }

      post '/api/v1/users', params: { user: user_params }

      expect(response).to be_successful

      user = User.last

      expect(user.email).to eq(user_params[:email])
      expect(user.api_key).to_not be_nil
      expect(user.api_key.length).to eq(40)
    end
    it 'cannot create a new user with missing information' do
      user_params = {
        email: '',
        password: 'password',
        password_confirmation: 'password'
      }

      post '/api/v1/users', params: { user: user_params }

      puts response.inspect

      expect(response).to_not be_successful
      test = JSON.parse(response.body, symbolize_names: true)
      expect(test[:error][:status]).to eq(400)
      expect(test[:error][:message]).to eq("Validation failed: Email can't be blank")
    end
  end
end