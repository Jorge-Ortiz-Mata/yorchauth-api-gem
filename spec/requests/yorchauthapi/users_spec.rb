require 'rails_helper'

RSpec.describe "Users", type: :request do
  let(:user_first) { create(:yorchauthapi_user, :with_email, :with_password, :with_password_confirmation) }
  let(:user_second) { build(:yorchauthapi_user, :with_email, :with_password, :with_password_confirmation) }
  let(:valid_params) { { email: 'user@example.com', password: '1234user', password_confirmation: '1234user' } }
  let(:invalid_params) { { email: 'user.com', password: '1234', password_confirmation: '3456' } }

  describe "GET /yorchauthapi/api/users" do
    before { user_first.reload }

    it 'should get users' do
      user_second.update(email: 'second_user@email.com')
      user_second.save

      get yorchauthapi.api_users_path

      data = JSON.parse response.body
      expect(response).to have_http_status(:ok)
      expect(data.count).to eql(2)
    end
  end

  describe "GET /yorchauthapi/api/user" do
    it 'should return success if the ID is correct' do
      get yorchauthapi.api_user_path(user_first.id)

      data = JSON.parse response.body
      expect(response).to have_http_status(:ok)
      expect(data['email']).to eql('user@email.com')
    end
  end

  describe "POST /yorchauthapi/api/users" do
    it 'should return success and create the user with correct params' do
      post yorchauthapi.api_users_path(user: valid_params)

      expect(response).to have_http_status(:ok)
    end

    it 'should return unprocessable entity if params are not correct' do
      post yorchauthapi.api_users_path(user: invalid_params)

      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe "PATCH /yorchauthapi/api/user" do
    it 'should return success and update the user with correct params' do
      expect(user_first.email).to eql('user@email.com')
      patch yorchauthapi.api_user_path(user_first.id), params: { user: valid_params }

      data = JSON.parse response.body
      expect(response).to have_http_status(:ok)
      expect(data['email']).to eql('user@example.com')
    end

    it 'should return unprocessable_entity if params are not correct' do
      expect(user_first.email).to eql('user@email.com')
      patch yorchauthapi.api_user_path(user_first.id), params: { user: invalid_params }

      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe "DELETE /yorchauthapi/api/user" do
    it 'should return success and delete a user' do
      delete yorchauthapi.api_user_path(user_first)
      get yorchauthapi.api_users_path

      data = JSON.parse response.body
      expect(response).to have_http_status(:ok)
      expect(data.count).to eql(0)
    end
  end
end
