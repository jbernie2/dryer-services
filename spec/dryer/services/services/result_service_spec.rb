require_relative "../../../../lib/dryer/services/services/result_service.rb"
require 'dry-monads'

RSpec.describe Dryer::Services::Services::ResultService do
  include Dry::Monads[:result]

  class SuccessService < described_class
    def initialize; end
    def call; true end
  end

  class FailureService < described_class
    def initialize; end
    def call; StandardError.new("foo") end
  end

  class UnnamedArgumentService < described_class
    def initialize(a, b, c); end
    def call; true end
  end

  class NamedArgumentService < described_class
    def initialize(a:, b:, c:); end
    def call; true end
  end

  class ArrayArgumentService < described_class
    def initialize(a)
      @a = a
    end
    def call
      @a
    end
  end

  class VariadicArgumentService < described_class
    def initialize(*args); @args = args end
    def call; @args end
  end

  class SuccessResultService < described_class
    def initialize(a); @a = a end
    def call; Dry::Monads::Success(@a) end
  end

  class FailureResultService < described_class
    def initialize(a); @a = a end
    def call; Dry::Monads::Failure(@a) end
  end

  class TestService < described_class
    def initialize(a); @a = a end
    def call; @a end
  end

  context "when successful" do
    let(:service) { SuccessService }
    it "returns a success object" do
      expect(service.call).to be_a(Dry::Monads::Success)
    end
  end

  context "when an error is returned" do
    let(:service) { FailureService }
    it "returns a failure object" do
      expect(service.call).to be_a(Dry::Monads::Failure)
    end
  end

  context "when passed an array of arguments" do
    let(:service) { UnnamedArgumentService }
    it "can parse them" do
      expect(service.call(1, 2, 3)).to be_a(Dry::Monads::Success)
    end
  end

  context "when passed a hash of arguments" do
    let(:service) { NamedArgumentService }
    it "can parse them" do
      expect(service.call(a: 1, b:2, c:3)).to be_a(Dry::Monads::Success)
    end
  end

  context "when passed an array of hash of arguments" do
    let(:service) { ArrayArgumentService }
    it "can parse them" do
      expect(
        service.call([{a:1}, {b:2}, {c:3}])
      ).to eq(Dry::Monads::Success([{a:1}, {b:2}, {c:3}]))
    end
  end

  context "when passed an array of a single hash" do
    let(:service) { ArrayArgumentService }
    it "can parse them" do
      expect(
        service.call([{a:1}])
      ).to eq(Dry::Monads::Success([{a:1}]))
    end
  end

  context "when passing hashes to a service that accepts a variable number of arguments" do
    let(:service) { VariadicArgumentService }
    it "can parse one hash argument" do
      expect(
        service.call({a:1, b:2})
      ).to eq(Dry::Monads::Success([{a:1, b:2}]))
    end

    it "can parse multiple hash arguments" do
      expect(
        service.call({a:1, b:2},{a:1, b:2})
      ).to eq(Dry::Monads::Success([{a:1, b:2}, {a:1, b:2}]))
    end
  end

  context "when the service explicitly returns a Success Monad" do
    let(:service) { SuccessResultService }
    it "does not re-wrap the return value" do
      expect(service.call("foo").value!).to eq("foo")
    end
  end

  context "when the service explicitly returns a Failure Monad" do
    let(:service) { FailureResultService }
    it "does not re-wrap the return value" do
      expect(service.call("foo").failure).to eq("foo")
    end
  end

  context "when the service returns an array of monads" do
    context "when they are all successful" do
      let(:service) { TestService.call([Success(1), Success(2)]) }
      it "returns a success monad containing an array of the values" do
        expect(service).to eq(Success([1,2]))
      end
    end
    context "when one or more is a failure" do
      let(:service) { TestService.call([Success(1), Failure("foo")]) }
      it "returns a failure monad with the first error encountered" do
        expect(service).to eq(Failure("foo"))
      end
    end
  end
end
