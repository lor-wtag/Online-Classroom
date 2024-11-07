FactoryBot.define do
  factory :user do
    name { "Jane Doe" }
    email { "janedoes@gmail.com" }
    password { "123456789" }
    password_confirmation { "123456789" }
    role { :student }
  end

  factory :teacher, class: 'User' do
    name { "Jane Doe Teacher" }
    email { "teacher1@gmail.com" }
    password { "123456789" }
    password_confirmation { "123456789" }
    role { :teacher }
  end

  factory :student, class: 'User' do
    name { "Jane Doe Student" }
    email { "student1@gmail.com" }
    password { "123456789" }
    password_confirmation { "123456789" }
    role { :student }
  end
end
