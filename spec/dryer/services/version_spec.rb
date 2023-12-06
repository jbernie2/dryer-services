require_relative "../../../lib/dryer/services/version.rb"

RSpec.describe Dryer::Services do
  it "returns the current gem version" do
    expect(Dryer::Services::VERSION).to be_truthy
  end
end
