require 'jwt'

module Yorchauthapi
  module Api
    class AuthenticatedController < ApplicationController
      private

      def authenticate_user
        jwt_token = request.headers['HTTP_AUTHORIZATION']

        if jwt_token.present?
          decoded_token = decode_jwt(jwt_token)
          authentication_token = AuthenticationToken.find_by(auth_token: decoded_token['auth_token'])

          render json: { errors: ['JWT expired'] }, status: :unauthorized unless authentication_token.present?
        else
          render json: { errors: ['JWT was not provided'] }, status: :unauthorized
        end
      end

      def user_permissions
        jwt_token = request.headers['HTTP_AUTHORIZATION']
        decoded_token = decode_jwt(jwt_token)
        authentication_token = AuthenticationToken.find_by(auth_token: decoded_token['auth_token'])

        return if authentication_token.user_id == params[:id].to_i

        render json: { errors: ['You are not allowed to perform this action'] }, status: :unauthorized
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
end
