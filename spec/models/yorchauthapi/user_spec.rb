require 'rails_helper'

module Yorchauthapi
  RSpec.describe User, type: :model do
    let(:valid_user) { build(:yorchauthapi_user, :with_email, :with_password, :with_password_confirmation) }
    let(:invalid_user) { build(:yorchauthapi_user) }

    describe 'instances' do
      it 'should do be valid' do
        expect(valid_user).to be_valid
      end

      it 'should do be valid' do
        expect(invalid_user).to_not be_valid
      end
    end
  end
end
