FactoryBot.define do
  factory :yorchauthapi_user, class: 'Yorchauthapi::User' do
    trait :as_old_user do
      email { "user-old-email@email.com" }
    end

    trait :as_new_user do
      email { "user-new-email@email.com" }
    end

    trait :with_password do
      password { "userpassword1234" }
    end

    trait :with_password_confirmation do
      password_confirmation { "userpassword1234" }
    end
  end
end
