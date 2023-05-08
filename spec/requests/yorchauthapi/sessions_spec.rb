require 'rails_helper'

RSpec.describe "Sessions", type: :request do
  let(:user) { build(:yorchauthapi_user, :as_old_user, :with_password, :with_password_confirmation) }
  let(:valid_params) { { email: 'user-old-email@email.com', password: 'userpassword1234', password_confirmation: 'userpassword1234' } }
  let(:invalid_params) { { email: 'user.com', password: '1234', password_confirmation: '3456' } }

  describe 'POST /login' do
    before { user.save }

    it 'should authenticate the user and return the auth token' do
      post yorchauthapi.api_login_path, params: valid_params

      data = JSON.parse(response.body)
      expect(response).to have_http_status(:ok)
      expect(data.keys).to match_array(['auth_token'])
    end

    it 'should return error when params are not correct' do
      post yorchauthapi.api_login_path, params: invalid_params

      data = JSON.parse(response.body)
      expect(response).to have_http_status(:unprocessable_entity)
      expect(data.keys).to match_array(['errors'])
      expect(data['errors']).to eql(['Email or password are incorrect'])
    end
  end

  describe 'DELETE /logout' do
    it 'should delete the auth token when user closes session (logout)' do
      user.save
      post yorchauthapi.api_login_path, params: valid_params
      encoded_token = JSON.parse(response.body)['auth_token']
      expect(Yorchauthapi::AuthenticationToken.all.count).to eql(1)

      delete yorchauthapi.api_logout_path, params: {}, headers: { 'Authorization': encoded_token }

      data = JSON.parse(response.body)
      expect(response).to have_http_status(:ok)
      expect(data['response']).to eql('Authentication token was successfully deleted')
      expect(Yorchauthapi::AuthenticationToken.all.count).to eql(0)
    end
  end

  describe 'Request with 2 sessions active' do
    before do
      user.save
      post yorchauthapi.api_login_path, params: valid_params
      @encoded_old_token = JSON.parse(response.body)['auth_token']
      expect(Yorchauthapi::AuthenticationToken.all.count).to eql(1)

      post yorchauthapi.api_login_path, params: valid_params
      @encoded_new_token = JSON.parse(response.body)['auth_token']
      expect(Yorchauthapi::AuthenticationToken.all.count).to eql(1)
    end


    it 'should delete the previous token and render error when using old token' do
      delete yorchauthapi.api_logout_path, params: {}, headers: { 'Authorization': @encoded_old_token }

      data = JSON.parse(response.body)
      expect(response).to have_http_status(:unprocessable_entity)
      expect(data.keys).to match_array(['errors'])
      expect(data['errors']).to eql(['Authentication token was not found'])

      delete yorchauthapi.api_logout_path, params: {}, headers: { 'Authorization': @encoded_new_token }

      data = JSON.parse(response.body)
      expect(response).to have_http_status(:ok)
      expect(data['response']).to eql('Authentication token was successfully deleted')
      expect(Yorchauthapi::AuthenticationToken.all.count).to eql(0)
    end

    it 'should denied the request when using an old token' do
      get yorchauthapi.api_user_path(user.id), params: {}, headers: { 'Authorization': @encoded_old_token }

      data = JSON.parse(response.body)
      expect(response).to have_http_status(:unauthorized)
      expect(data['errors']).to eql(['Your JWT is invalid. Please, close the session and request a new token'])

      get yorchauthapi.api_user_path(user.id), params: {}, headers: { 'Authorization': @encoded_new_token }

      data = JSON.parse(response.body)
      expect(response).to have_http_status(:ok)
      expect(data.keys).to match_array(%w[email id])
    end
  end
end
