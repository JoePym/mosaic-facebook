require 'httparty'

module Mosaic
  module Facebook
    class Object
      include HTTParty
      debug_output

      def initialize(attributes = {})
        attributes.each { |key,value| instance_variable_set("@#{key}".to_sym, value) }
      end

      def delete(path, options = {})
        query = { :access_token => facebook_access_token }.merge(options)
        body = Hash[instance_variables.collect { |ivar| [ivar.sub(/@/,''),instance_variable_get(ivar)] }].to_json
        self.class.delete path, :query => query, :body => body
      end

      def post(path, options)
        query = { :access_token => facebook_access_token }.merge(options)
        body = Hash[instance_variables.collect { |ivar| [ivar.sub(/@/,''),instance_variable_get(ivar)] }].to_json
        self.class.post path, :query => query, :body => body
      end


      class << self
        def attr_accessor(*names)
          self.attribute_names += names.collect(&:to_s)
          super
        end

        def attribute_names
          @attribute_names ||= []
        end

        def attribute_names=(names)
          @attribute_names = names
        end

        def configuration
          @configuration ||= configuration_from_file
        end

        def configuration_file
          Rails.root.join('config','facebook.yml')
        end

        def configuration_from_file
          YAML.load_file(configuration_file) rescue nil
        end

        def facebook_access_token
          @facebook_access_token ||= configuration && configuration['access_token']
        end

        def facebook_user
          @facebook_user ||= configuration['user']
        end

        def get(path, options)
          super(path, :query => options)
        end

      private
        def perform_request_with_retry(http_method, path, options)
          with_retry do
            perform_request_without_retry(http_method, path, options)
          end
        end
        # alias_method_chain :perform_request, :retry
        alias_method :perform_request_without_retry, :perform_request
        alias_method :perform_request, :perform_request_with_retry

        def with_retry(exception = Exception, attempts = 3)
          tries = 0
          begin
            return yield
          rescue exception => e
            if tries < attempts
              tries += 1
              RAILS_DEFAULT_LOGGER.debug "#{e.class.name}: #{e.message}: retry ##{tries}"
              retry
            end
            raise e
          end
        end
      end
    end
  end
end
