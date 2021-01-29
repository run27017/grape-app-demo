module Rack
  module Test
    module Methods
      def_delegators :current_session, :last_env
    end

    class Session
      attr_reader :last_env

      def custom_request(verb, uri, params = {}, env = {}, &block)
        uri = parse_uri(uri, env)
        @last_env = env_for(uri, env.merge(method: verb.to_s.upcase, params: params))
        process_request(uri, @last_env, &block)
      end
    end
  end
end

module Resources
  class Test < Models::Test
    include Rack::Test::Methods

    def app
      Resources::Index
    end

    def presents(key)
      value = last_env[Grape::Env::API_ENDPOINT].body[key]
      value = value.map { |item| extract_original_object(item) } if value.is_a?(Array)
      extract_original_object(value)
    end

    private
    
    def extract_original_object(value)
      value.is_a?(Grape::Entity) ? value.object : value
    end
  end
end
