require "rails_helper"

RSpec.describe ErrorSerializer do
  let(:error) { ErrorMessage.new("Error message", 400) }
  it "formats error message" do
    serialized = ErrorSerializer.serialize(error)

    expect(serialized).to eq(
      {
        error: {
          message: "Error message",
          status: 400
        }
    })
  end
end