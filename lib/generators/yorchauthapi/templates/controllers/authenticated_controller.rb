# frozen_string_literal: true

require 'jwt'

module Api
  class AuthenticatedController < ApplicationController
    private

    def authenticate_user
      jwt_token = request.headers['HTTP_AUTHORIZATION']

      if jwt_token.present?
        decoded_token = Yorchauthapi.decode_jwt(jwt_token)
        authentication_token = AuthenticationToken.find_by(auth_token: decoded_token['auth_token'])

        if authentication_token.present?
          return if authentication_token.user_id == params[:id].to_i

          render json: { errors: ['You are not allowed to perform this action'] }, status: :unauthorized
        else
          render json: { errors: ['Your JWT is invalid. Please, close the session and request a new token'] }, status: :unauthorized
        end
      else
        render json: { errors: ['JWT was not provided'] }, status: :unauthorized
      end
    end

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
