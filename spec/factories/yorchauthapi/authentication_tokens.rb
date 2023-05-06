FactoryBot.define do
  factory :yorchauthapi_authentication_token, class: 'Yorchauthapi::AuthenticationToken' do
    trait :with_user_id do
      user_id { create(:yorchauthapi_user, :with_email, :with_password, :with_password_confirmation) }
    end
  end
end
