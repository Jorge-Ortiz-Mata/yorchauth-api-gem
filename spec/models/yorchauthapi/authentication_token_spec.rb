require 'rails_helper'

module Yorchauthapi
  RSpec.describe AuthenticationToken, type: :model do
    let(:authentication_token) { build(:yorchauthapi_authentication_token, :with_user_id) }

    describe 'instances' do
      it 'should be valid' do
        expect(authentication_token).to be_valid
      end
    end

    describe 'has secure token' do
      it { should have_secure_token(:auth_token).ignoring_check_for_db_index }
    end
  end
end
