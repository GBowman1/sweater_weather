class User < ApplicationRecord
  validates :email, presence: true, uniqueness: true
  validates :password, presence: true
  validates :password_confirmation, presence: true
  validates :api_key, uniqueness: true

  has_secure_password
  before_create :create_key

  def create_key
    self.api_key = SecureRandom.hex(20)
  end
end
