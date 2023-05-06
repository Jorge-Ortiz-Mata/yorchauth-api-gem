module Yorchauthapi
  module Api
    class UsersController < ApplicationController
      def index
        @users = User.all
        render json: @users, status: :ok
      end

      def create
        @user = User.new user_params

        if @user.save
          render json: @user, status: :ok
        else
          render json: @user, status: :unprocessable_entity
        end
      end

      private

      def user_params
        params.require(:user).permit(:email, :password, :password_confirmation)
      end
    end
  end
end
