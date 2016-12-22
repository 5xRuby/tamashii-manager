require "codeme/manager/errors/authorization_error"
require "codeme/manager/config"

module Codeme
  module Manager
    module Authorizator
      class Token
        attr_reader :client_id

        def initialize
          @client_id = nil
          @authorized = false
        end

        def verify!(data)
          p Config.env
          @client_id, token = data.split(",")
          Manager.logger.debug("Client #{@client_id} try to verify token: #{Config.env.production? ? "FILTERED" : token}")
          raise AuthorizationError.new("Token mismatch!") unless @authorized = Config.token == token
        end
      end
    end
  end
end
