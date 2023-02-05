FactoryBot.define do
  factory :user do
    email { Faker::Internet.unique.email }
    password { 'password' }

    factory :user_known do
      email { 'user@example.com' }
    end
  end
end
