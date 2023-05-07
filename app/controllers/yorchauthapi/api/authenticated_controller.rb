require 'jwt'

module Yorchauthapi
  module Api
    class AuthenticatedController < ApplicationController
      protect_from_forgery with: :null_session

      private

      def validate_same_user
        @token = request.headers['HTTP_AUTHORIZATION']
        @hmac_secret = 'YORCH_AUTH_API_SECRET_2048'
        decoded_token = jwt_validation(@token, @hmac_secret)
        authentication_token = AuthenticationToken.find_by(auth_token: decoded_token[0]['auth_token'])

        if authentication_token.present?
          return if authentication_token.user_id == params[:id].to_i

          render json: { errors: ['You are not allowed to perform this action'] }, status: :unauthorized
        else
          render json: { errors: ['Your JWT is invalid. Please, close the session and request a new'] }, status: :unauthorized
        end
      end

      def jwt_validation(token, hmac_secret)
        begin
          JWT.decode token, hmac_secret, true, { algorithm: 'HS256' }
        rescue JWT::VerificationError
          render json: { errors: ['JWT Format Invalid'] }, status: :unprocessable_entity
        rescue JWT::DecodeError
          render json: { errors: ['No JWT provided'] }, status: :unauthorized
        end
      end
    end
  end
end
