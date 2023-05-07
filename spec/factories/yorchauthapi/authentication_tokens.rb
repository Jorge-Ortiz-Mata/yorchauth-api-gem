FactoryBot.define do
  factory :yorchauthapi_authentication_token, class: 'Yorchauthapi::AuthenticationToken' do
    trait :with_user_id do
      user_id { create(:yorchauthapi_user, :as_new_user, :with_password, :with_password_confirmation) }
    end
  end
end
