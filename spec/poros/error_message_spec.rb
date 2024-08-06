require "rails_helper"

RSpec.describe ErrorMessage do
  it "exists" do
    error = ErrorMessage.new("Error message", 400)

    expect(error).to be_a(ErrorMessage)
  end

  it "has attributes" do
    error = ErrorMessage.new("Error message", 400)

    expect(error.message).to eq("Error message")
    expect(error.status).to eq(400)
  end
end