require 'jwt'

module Yorchauthapi
  module Api
    class UsersController < ApplicationController
      before_action :set_user, only: %i[show update destroy]

      def index
        @users = User.all
        render json: @users, status: :ok
      end

      def show
        render json: @user, status: :ok
      end

      def create
        @user = User.new user_params

        if @user.save
          render_jwt_token(@user)
        else
          render json: @user, status: :unprocessable_entity
        end
      end

      def update
        if @user.update user_params
          render json: @user, status: :ok
        else
          render json: @user, status: :unprocessable_entity
        end
      end

      def destroy
        @user.destroy
      end

      private

      def user_params
        params.require(:user).permit(:email, :password, :password_confirmation)
      end

      def set_user
        @user = User.find(params[:id])
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
