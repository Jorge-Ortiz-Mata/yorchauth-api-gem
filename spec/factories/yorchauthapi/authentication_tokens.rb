FactoryBot.define do
  factory :authentication_token do
    auth_token { "MyString" }
    user_id { 1 }
  end
end
