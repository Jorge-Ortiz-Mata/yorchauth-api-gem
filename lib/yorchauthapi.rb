# frozen_string_literal: true

require 'jwt'
require 'yorchauthapi/version'
require 'yorchauthapi/engine'

module Yorchauthapi
  def self.encode_jwt(user)
    hmac_secret = 'yorchAuthAPIKey190896'
    payload = { id: user.id, email: user.email, auth_token: user.authentication_token.auth_token }

    JWT.encode payload, hmac_secret, 'HS256'
  end

  def self.decode_jwt(token)
    return unless token.present?

    hmac_secret = 'yorchAuthAPIKey190896'
    decoded_token = JWT.decode token, hmac_secret, true, { algorithm: 'HS256' }
    decoded_token.first
  end
end
