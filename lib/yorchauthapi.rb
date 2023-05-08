# frozen_string_literal: true

require 'jwt'
require 'yorchauthapi/version'
require 'yorchauthapi/engine'

module Yorchauthapi
  def self.decode_jwt(token)
    return unless token.present?

    hmac_secret = 'yorchAuthAPIKey190896'
    decoded_token = JWT.decode token, hmac_secret, true, { algorithm: 'HS256' }
    decoded_token.first
  end
end
