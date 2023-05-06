require 'jwt'

module Yorchauthapi
  module Api
    class SessionsController < ApplicationController
      before_action :set_user_by_email

      def login
        if @user&.authenticate(params[:password])
          previous_token = AuthenticationToken.find_by(user_id: @user_id)
          previous_token.destroy if previous_token.present?

          render_jwt_token(@user)
        else
          render json: { response: false }, status: :unprocessable_entity
        end
      end

      def logout
        token = AuthenticationToken.find_by(user_id: @user.id)
        token.destroy
      end

      private

      def set_user_by_email
        @user = User.find_by(email: params[:email])
      end

      def render_jwt_token(user)
        AuthenticationToken.create(user_id: user.id)

        hmac_secret = 'YORCH_AUTH_API_SECRET_2048'
        payload = { user: user.email, auth_token: user.authentication_token.auth_token }
        token = JWT.encode payload, hmac_secret, 'HS256'

        render json: token, status: :ok
      end
    end
  end
end
