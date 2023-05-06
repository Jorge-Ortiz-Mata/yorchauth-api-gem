require 'rails_helper'

module Yorchauthapi
  RSpec.describe User, type: :model do
    let(:valid_user) { build(:yorchauthapi_user, :with_email, :with_password, :with_password_confirmation) }
    let(:invalid_user) { build(:yorchauthapi_user) }

    describe 'validations' do
      context 'pre-defined validations' do
        it { should validate_presence_of(:email) }
        it { should validate_uniqueness_of(:email) }

        it { should validate_presence_of(:password) }
        it { should validate_length_of(:password).is_at_least(6) }

        it { should validate_presence_of(:password_confirmation) }
        it { should validate_length_of(:password_confirmation).is_at_least(6) }
      end

      context 'custom validations' do
        it 'should arrise an error if email does not have @' do
          valid_user.update(email: 'user.com')

          expect(valid_user).to_not be_valid
        end
      end
    end

    describe 'associations' do
      it { should have_one(:authentication_token) }
    end

    describe 'has secure password bycrpt' do
      it { should have_secure_password }
    end

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
