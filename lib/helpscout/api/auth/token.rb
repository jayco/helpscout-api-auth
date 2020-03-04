# frozen_string_literal: true

require 'net/http'
require 'json'

module Helpscout
  module Api
    module Auth
      class Token
        attr_reader :access_token

        def initialize(endpoint: 'https://api.helpscout.net/v2/oauth2/token', client_id:, client_secret:, expires_in: 300)
          @endpoint = endpoint
          @expires_in = Time.now + expires_in
          @credentials = URI.encode_www_form(client_id: client_id, client_secret: client_secret, grant_type: 'client_credentials')
          @access_token = nil
        end

        def fetch
          refresh
        end

        def to_s
          "Bearer #{@access_token}"
        end

        private

        def refresh
          get_token if is_expired? || @access_token.nil?
          @access_token
        end

        def get_token
          res = Net::HTTP.post(URI(@endpoint), @credentials, { 'Content-Type': 'application/x-www-form-urlencoded' }.freeze)
          parsed = JSON.parse(res.body)
          @expires_in = Time.now.to_i + parsed['expires_in'].to_i
          @access_token = parsed['access_token']
        end

        def is_expired?
          @expires_in.to_i <= Time.now.to_i
        end
      end
    end
  end
end
