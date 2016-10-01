module Concerns::Models
  module SlackAdapter
    extend ActiveSupport::Concern

    API_URL = ENV['SLACK_API_URL']
    TOKEN   = ENV['SLACK_TOKEN']

    # Initialize instance.
    # @param [Hash] parameters parameters of model.
    def initialize(parameters)
      parameters.each do |column, value|
        if respond_to?("#{column}=")
          send("#{column}=", value)
        else
          Rails.logger.warn "undefined column `#{column}`."
        end
      end
    end

    class_methods do
      # Define column.
      # @param [Symbol] name column name.
      def column(name)
        attr_accessor name
      end

      # Define API singleton method.
      # @param [Symbol] name      API name.
      # @param [String] method    Method name.
      # @param [String] reference Reference.
      def api_singleton_method(name, method, reference)
        reference  = reference.to_s
        collection = (reference.pluralize == reference.pluralize)

        define_singleton_method name do |params={}|
          result = request!(method, params)

          if collection
            result[reference].map { |d| new(d) }
          else
            new(result[reference])
          end
        end
      end

      private

      # Request to slack.
      # @raise when return error.
      # @param [String] method Slack API method.
      # @param [Hash]   params Parameters
      # @return [Hash] result
      def request!(method, params)
        result = JSON.parse(Net::HTTP.get(create_uri(method, params)))
        if result['ok']
          result
        else
          raise result['error']
        end
      end

      # Create request uri.
      # @param [String] method Slack API method.
      # @param [Hash]   params Parameters
      # @return [URI] URI
      def create_uri(method, params)
        URI.parse([Concerns::Models::SlackAdapter::API_URL, method].join('/')).tap do |uri|
          uri.query = URI.encode_www_form(params.merge(token: Concerns::Models::SlackAdapter::TOKEN))
        end
      end
    end
  end
end