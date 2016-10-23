module Concerns::Models
  module SlackAdapter
    extend ActiveSupport::Concern

    CACHE_EXPIRES = 5.seconds

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
      # @param [Symbol]  name       API name.
      # @param [String]  method     Method name.
      # @param [String]  reference  Reference.
      # @param [Boolean] collection set api response is collection.
      def api_singleton_method(name, method, reference = nil, collection: nil)
        reference  = reference.to_s
        collection = (collection.nil? ? (reference.pluralize == reference.pluralize) : collection)

        define_singleton_method name do |params={}|
          result = request!(method, params)

          if collection
            result[reference].map { |d| new(d) }
          else
            new(reference.present? ? result[reference] : result)
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
          Rails.cache.fetch("#{method}::#{Digest::SHA256.hexdigest(params.to_json)}", expires_in: CACHE_EXPIRES) do
            result
          end
        else
          raise result['error']
        end
      end

      # Create request uri.
      # @param [String] method Slack API method.
      # @param [Hash]   params Parameters
      # @return [URI] URI
      def create_uri(method, params)
        URI.parse([Stalck.config.slack.api_url, method].join('/')).tap do |uri|
          uri.query = URI.encode_www_form({ token: Stalck.config.slack.token }.merge(params))
        end
      end
    end
  end
end
