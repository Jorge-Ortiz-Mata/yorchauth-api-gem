require 'jwt'

module Yorchauthapi
  module Api
    class AuthenticatedController < ApplicationController
      protect_from_forgery with: :null_session

      private

      def validate_same_user
        @jwt_token = request.headers['HTTP_AUTHORIZATION']
        decoded_token = decode_jwt(@jwt_token)

        authentication_token = AuthenticationToken.find_by(auth_token: decoded_token['auth_token'])

        if authentication_token.present?
          return if authentication_token.user_id == params[:id].to_i

          render json: { errors: ['You are not allowed to perform this action'] }, status: :unauthorized
        else
          render json: { errors: ['Your JWT is invalid. Please, close the session and request a new token'] }, status: :unauthorized
        end
      end
    end
  end
end
