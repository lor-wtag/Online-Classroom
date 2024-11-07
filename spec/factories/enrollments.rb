FactoryBot.define do
  factory :enrollment do
    classroom factory: :classroom
    user factory: :student
  end
end
