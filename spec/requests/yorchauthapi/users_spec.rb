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

  describe "POST /yorchauthapi/api/users" do
    it 'should return success if params are correct' do
      post yorchauthapi.api_users_path(user: valid_params)

      data = JSON.parse response.body
      expect(response).to have_http_status(:ok)
      expect(data['email']).to eql('user@example.com')
    end

    it 'should return unprocessable entity if params are not correct' do
      post yorchauthapi.api_users_path(user: invalid_params)

      expect(response).to have_http_status(:unprocessable_entity)
    end
  end
end
