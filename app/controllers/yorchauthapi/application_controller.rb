module Yorchauthapi
  class ApplicationController < ActionController::Base
    def encode_jwt(user)
      AuthenticationToken.create(user_id: user.id)

      hmac_secret = 'yorchAuthAPIKey190896'
      payload = { email: user.email, auth_token: user.authentication_token.auth_token }

      JWT.encode payload, hmac_secret, 'HS256'
    end

    def decode_jwt(token)
      return unless token.present?

      hmac_secret = 'yorchAuthAPIKey190896'
      decoded_token = JWT.decode token, hmac_secret, true, { algorithm: 'HS256' }
      decoded_token.first
    end
  end
end
