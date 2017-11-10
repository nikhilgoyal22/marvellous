module Marvellous
  class Client
    include HTTParty
    base_uri 'http://gateway.marvel.com'

    attr_accessor :public_key, :private_key

    class InvalidRouteError < StandardError; end

    def initialize(options)
      @public_key = options[:public_key]
      @private_key = options[:private_key]
      @prefix = '/v1/public'
      @routes = Marvellous::ROUTES
    end

    private

    def params(additional_params = {})
      base_hash = { :apikey => public_key, :ts => ts, :hash => digest }
      additional_params.merge(base_hash)
    end

    def digest
      Digest::MD5.hexdigest("#{ts}#{private_key}#{public_key}")
    end

    def ts
      begin
        Time.now.to_i
      end
    end

    def build_response_object(response)
      Response.create(response)
    end

    def fetch_response(route, options = {})
      self.class.get(@prefix+route, query: params(options), headers: { 'Accept-Encoding' => 'gzip' })
    end

    def routes
      @routes
    end

    def method_missing(method, *args, &block)
      if routes.keys.include?(method)
        endpoint = "#{routes[method]}"
        params = *args
        if params.any?
          params[0].each do |p_key, p_value|
            endpoint.gsub!(":#{p_key.to_s}", p_value.to_s)
          end
        end
        response = fetch_response(endpoint)
        build_response_object(response)
      else
        raise InvalidRouteError, "#{method} is not defined in the routes."
      end
    end

  end
end
