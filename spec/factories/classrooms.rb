FactoryBot.define do
  factory :classroom do
    name { "Sample Classroom" }
    course_code { "CS101" }
    classroom_code { SecureRandom.hex(4) }
    teacher factory: :teacher
  end
end
