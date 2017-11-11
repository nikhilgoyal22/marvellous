module Marvellous
  class Response < Hash
    include Hashie::Extensions::MergeInitializer
    include Hashie::Extensions::KeyConversion
    include Hashie::Extensions::MethodAccess
    include Hashie::Extensions::IndifferentAccess

    attr_reader :raw_response

    def self.create(response)
      case response.code
      when 200
        res = Response.new(response)
        res['data']['results'] rescue res
      else
        InvalidResponse.new(response)
      end
    end

    def initialize(base)
      @base_response = base
      super(base)
    end
  end

  class InvalidResponse < Response; end
end
