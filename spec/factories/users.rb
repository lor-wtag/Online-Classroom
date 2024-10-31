FactoryBot.define do
  factory :user do
    name { "Jane Doe" }
    # sequence(:email) { |n| "user_no#{n}@gmail.com" }
    email { "janedoes@gmail.com" }
    role { :student }
    password { "123456789" }
  end
end
