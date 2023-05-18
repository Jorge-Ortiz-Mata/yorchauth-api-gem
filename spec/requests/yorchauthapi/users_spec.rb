require 'rails_helper'

RSpec.describe 'Users', type: :request do
  let(:old_user) { build(:yorchauthapi_user, :as_old_user, :with_password, :with_password_confirmation) }
  let(:new_user) { build(:yorchauthapi_user, :as_new_user, :with_password, :with_password_confirmation) }
  let(:valid_params) { { email: 'user-old-email@email.com', password: 'userpassword1234', password_confirmation: 'userpassword1234' } }
  let(:invalid_params) { { email: 'user.com', password: '1234', password_confirmation: '3456' } }

  describe 'POST - create /yorchauthapi/api/users' do
    it 'should return error when params are not correct' do
      post yorchauthapi.api_users_path(user: invalid_params)

      data = JSON.parse(response.body)
      expect(response).to have_http_status(:unprocessable_entity)
      expect(data['errors'].count).to eql(3)
    end

    it 'should create a new user and return the authentication token' do
      post yorchauthapi.api_users_path(user: valid_params)

      data = JSON.parse(response.body)
      expect(response).to have_http_status(:ok)
      expect(data.keys).to match_array(['auth_token'])
    end
  end

  describe 'GET - show /yorchauthapi/api/user' do
    before { old_user.save }

    it 'should return error when no jwt is provided' do
      get yorchauthapi.api_user_path(old_user.id)

      data = JSON.parse response.body
      expect(response).to have_http_status(:unauthorized)
      expect(data['errors']).to eql(['JWT was not provided'])
    end

    it 'should return error when JWT is different from the saved one' do
      post yorchauthapi.api_login_path, params: valid_params
      old_token = JSON.parse(response.body)['auth_token']

      expect(response).to have_http_status(:ok)
      expect(Yorchauthapi::AuthenticationToken.count).to eql(1)

      post yorchauthapi.api_login_path, params: valid_params
      expect(response).to have_http_status(:ok)
      expect(Yorchauthapi::AuthenticationToken.count).to eql(1)

      get yorchauthapi.api_user_path(old_user.id), params: {}, headers: { 'Authorization': old_token }

      data = JSON.parse response.body
      expect(response).to have_http_status(:unauthorized)
      expect(data['errors']).to eql(['JWT expired'])
    end

    it 'should return error when the current user is different from the user data' do
      new_user.save
      post yorchauthapi.api_login_path, params: valid_params
      new_token = JSON.parse(response.body)['auth_token']

      get yorchauthapi.api_user_path(new_user.id), params: {}, headers: { 'Authorization': new_token }

      data = JSON.parse(response.body)
      expect(response).to have_http_status(:unauthorized)
      expect(data['errors']).to eql(['You are not allowed to perform this action'])
    end

    it 'should get the user information' do
      post yorchauthapi.api_login_path, params: valid_params
      encoded_token = JSON.parse(response.body)['auth_token']

      get yorchauthapi.api_user_path(old_user.id), params: {}, headers: { 'Authorization': encoded_token }

      data = JSON.parse(response.body)
      expect(response).to have_http_status(:ok)
      expect(data.keys).to match_array(%w[email id])
    end
  end

  describe 'PATCH - update /yorchauthapi/api/user' do
    before do
      new_user.save
      old_user.save
    end

    it 'should return errors when :user_id is different from the current user' do
      post yorchauthapi.api_login_path, params: valid_params
      encoded_token = JSON.parse(response.body)['auth_token']
      patch yorchauthapi.api_user_path(new_user.id), params: { user: valid_params }, headers: { 'Authorization': encoded_token }

      data = JSON.parse(response.body)
      expect(response).to have_http_status(:unauthorized)
      expect(data['errors']).to eql(['You are not allowed to perform this action'])
    end

    it 'should return errors when params are not correct' do
      post yorchauthapi.api_login_path, params: valid_params
      encoded_token = JSON.parse(response.body)['auth_token']
      patch yorchauthapi.api_user_path(old_user.id), params: { user: invalid_params }, headers: { 'Authorization': encoded_token }

      data = JSON.parse(response.body)
      expect(response).to have_http_status(:unprocessable_entity)
      expect(data['errors']['email']).to eql(['should be a valid email'])
    end

    it 'should update a user record' do
      post yorchauthapi.api_login_path, params: valid_params
      encoded_token = JSON.parse(response.body)['auth_token']
      patch yorchauthapi.api_user_path(old_user.id), params: { user: { email: 'old_updated@email.com' } }, headers: { 'Authorization': encoded_token }

      data = JSON.parse(response.body)
      expect(response).to have_http_status(:ok)
      expect(data.keys).to match_array(['email', 'id'])
      expect(data['email']).to eql('old_updated@email.com')
    end
  end

  describe 'DELETE /yorchauthapi/api/user' do
    before do
      new_user.save
      old_user.save
    end

    it 'should return errors when :user_id is different from the current user' do
      post yorchauthapi.api_login_path, params: valid_params
      encoded_token = JSON.parse(response.body)['auth_token']
      delete yorchauthapi.api_user_path(new_user), params: {}, headers: { 'Authorization': encoded_token }


      data = JSON.parse(response.body)
      expect(response).to have_http_status(:unauthorized)
      expect(data['errors']).to eql(['You are not allowed to perform this action'])
    end

    it 'should delete a user' do
      post yorchauthapi.api_login_path, params: valid_params
      encoded_token = JSON.parse(response.body)['auth_token']

      delete yorchauthapi.api_user_path(old_user), params: {}, headers: { 'Authorization': encoded_token }

      data = JSON.parse response.body
      expect(response).to have_http_status(:ok)
      expect(data['response']).to eql(['Email has been deleted succesfully'])
      expect(Yorchauthapi::User.all.count).to eql(1)
    end
  end
end
