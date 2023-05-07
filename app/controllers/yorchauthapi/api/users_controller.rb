require 'jwt'

module Yorchauthapi
  module Api
    class UsersController < AuthenticatedController
      before_action :validate_same_user, only: %i[show update destroy]
      before_action :set_user, except: %i[create]

      def show
        render json: { email: @user.email }, status: :ok
      end

      def create
        @user = User.new user_params

        if @user.save
          token_encoded = encode_jwt(@user)
          render json: { auth_token: token_encoded }, status: :ok
        else
          render json: { errors: @user.errors }, status: :unprocessable_entity
        end
      end

      def update
        if @user.update user_params
          render json: @user, status: :ok
        else
          render json: { errors: @user.errors }, status: :unprocessable_entity
        end
      end

      def destroy
        if @user.present?
          @user.destroy
          render json: { response: ['Email has been deleted succesfully'] }, status: :ok
        else
          render json: { errors: ['Email account has not been found'] }, status: :unprocessable_entity
        end
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
