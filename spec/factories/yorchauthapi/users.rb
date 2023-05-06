FactoryBot.define do
  factory :yorchauthapi_user, class: 'Yorchauthapi::User' do
    trait :with_email do
      email { "user@email.com" }
    end

    trait :with_password do
      password { "userpassword1234" }
    end

    trait :with_password_confirmation do
      password_confirmation { "userpassword1234" }
    end
  end
end
