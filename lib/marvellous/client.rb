module Marvellous
  class Client
    include HTTParty
    base_uri 'http://gateway.marvel.com'

    attr_accessor :public_key, :private_key

    class InvalidRouteError < StandardError; end

    DEF_PAGE_SIZE = 10
    DEF_PAGE_NUM = 1

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

    def paginate(options)
      return {} if options[:paginate] == false
      page_num = options[:page_num] || DEF_PAGE_NUM
      page_size = options[:page_size] || DEF_PAGE_SIZE
      {offset: (page_num-1)*page_size, limit: page_size}
    end

    def build_uri(method, params={})
      endpoint = "#{routes[method][:path]}"
      if params.any?
        params.each do |p_key, p_value|
          endpoint.gsub!(":#{p_key.to_s}", p_value.to_s)
        end
      end
      endpoint
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
        params = args[0] || {}
        endpoint = build_uri(method, params)
        page_hash = (routes[method][:collection] rescue false) ? paginate(params) : {}
        response = fetch_response(endpoint, page_hash)
        build_response_object(response)
      else
        raise InvalidRouteError, "#{method} is not defined in the routes."
      end
    end

  end
end
