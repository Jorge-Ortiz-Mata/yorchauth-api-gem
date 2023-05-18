require 'jwt'

module Yorchauthapi
  module Api
    class SessionsController < AuthenticatedController
      def login
        user = User.find_by(email: params[:email])

        if user&.authenticate(params[:password])
          authentication_token = AuthenticationToken.find_by(user_id: user.id)
          authentication_token.destroy if authentication_token.present?

          token_encoded = encode_jwt(user)
          render json: { auth_token: token_encoded }, status: :ok
        else
          render json: { errors: ['Email or password are incorrect'] }, status: :unprocessable_entity
        end
      end

      def logout
        jwt_token = request.headers['HTTP_AUTHORIZATION']
        decoded_token = decode_jwt(jwt_token)
        authentication_token = AuthenticationToken.find_by(auth_token: decoded_token['auth_token'])

        if authentication_token.present?
          authentication_token.destroy
          render json: { response: 'Authentication token was successfully deleted' }, status: :ok
        else
          render json: { errors: ['Authentication token was not found'] }, status: :unprocessable_entity
        end
      end
    end
  end
end
