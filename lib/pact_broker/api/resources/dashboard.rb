require 'pact_broker/api/resources/base_resource'
require 'pact_broker/api/decorators/dashboard_decorator'

module PactBroker
  module Api
    module Resources

      class Dashboard < BaseResource

        def content_types_provided
          [["application/hal+json", :to_json]]
        end

        def allowed_methods
          ["GET"]
        end

        def to_json
          PactBroker::Api::Decorators::DashboardDecorator.new(index_items).to_json(user_options: decorator_context)
        end

        private

        def index_items
          index_service.find_index_items
        end
      end
    end
  end
end