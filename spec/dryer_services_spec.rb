require_relative "../lib/dryer_services.rb"

RSpec.describe Dryer::Services do
  it "loads the correct classes" do
    expect(
      Dryer::Services::SimpleService.superclass
    ).to eq(Dryer::Services::Services::SimpleService)
    expect(
      Dryer::Services::ResultService.superclass
    ).to eq(Dryer::Services::Services::ResultService)
  end
end
