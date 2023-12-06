require_relative "./dryer/services/services/result_service.rb"
require_relative "./dryer/services/services/simple_service.rb"

module Dryer
  module Services
    class SimpleService < Dryer::Services::Services::SimpleService
    end
    class ResultService < Dryer::Services::Services::ResultService
    end
  end
end
