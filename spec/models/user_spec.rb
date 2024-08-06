require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email) }

    it { should validate_presence_of(:password) }
    it { should validate_presence_of(:password_confirmation) }

    it { should validate_uniqueness_of(:api_key) }
  end
  describe 'class methods' do
    it 'can create a key' do
      user = User.create!(email: 'garrett.r.bowman@gmail.com', password: 'password', password_confirmation: 'password')
      expect(user.api_key).to_not be_nil
      expect(user.api_key.length).to eq(40)
    end
  end
end
