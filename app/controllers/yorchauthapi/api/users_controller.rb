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
          render json: @user, status: :ok
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
    end
  end
end
