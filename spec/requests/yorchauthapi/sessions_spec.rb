require 'rails_helper'

RSpec.describe "Sessions", type: :request do
  let(:user) { create(:yorchauthapi_user, :with_email, :with_password, :with_password_confirmation) }
  let(:authentication_token) { build(:yorchauthapi_authentication_token) }
  let(:valid_params) { { email: 'user@email.com', password: 'userpassword1234' } }
  let(:invalid_params) { { email: 'user@email.com', password: 'userpasword' } }

  describe "POST /login" do
    before { user.reload }

    it 'returns success and the auth token' do
      post yorchauthapi.api_login_path, params: valid_params
      expect(response).to have_http_status(:ok)
    end

    it 'returns unprocessable entity if params are incorrect' do
      post yorchauthapi.api_login_path, params: invalid_params
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe "DELETE /logout" do
    it 'should delete the auth token when user closes session (logout)' do
      user.reload
      post yorchauthapi.api_login_path, params: valid_params

      token = Yorchauthapi::User.find(user.id).authentication_token

      expect(response).to have_http_status(:ok)
      expect(token).to be_present

      delete yorchauthapi.api_logout_path, params: valid_params

      token = Yorchauthapi::User.find(user.id).authentication_token

      expect(token).to be_nil
    end
  end
end
