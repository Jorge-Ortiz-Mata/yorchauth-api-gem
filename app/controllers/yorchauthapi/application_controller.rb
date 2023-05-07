module Yorchauthapi
  class ApplicationController < ActionController::Base
    def encode_jwt(user)
      AuthenticationToken.create(user_id: user.id)

      hmac_secret = 'yorchAuthAPIKey190896'
      payload = { email: user.email, auth_token: user.authentication_token.auth_token }

      JWT.encode payload, hmac_secret, 'HS256'
    end

    def decode_jwt(token)
      hmac_secret = 'yorchAuthAPIKey190896'

      begin
        decoded_token = JWT.decode token, hmac_secret, true, { algorithm: 'HS256' }
        decoded_token.first
      rescue JWT::VerificationError
        render json: { errors: ['JWT Validation incorrect'] }, status: :unprocessable_entity
      rescue JWT::DecodeError
        render json: { errors: ['No JWT provided'] }, status: :unauthorized
      end
    end
  end
end
