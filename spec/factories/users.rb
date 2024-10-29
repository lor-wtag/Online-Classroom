FactoryBot.define do
  factory :user do
    name {"Jane Doe"}
    email {"janedoe@gmail.com"}
    role{:student}
    password {"123456789"}
  end
end