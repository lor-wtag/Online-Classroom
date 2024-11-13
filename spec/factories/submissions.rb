FactoryBot.define do
  factory :submission_for_students, class: "Submission" do
    grade { nil }
    feedback { nil }
    graded_at { nil }
    association :user, factory: :student
    association :assignment

      after(:create) do |submission|
        file_path = Rails.root.join("spec", "fixtures", "download.jpeg")
        submission.files.attach(io: File.open(file_path), filename: "download.jpeg", content_type: "image/jpeg")
    end
  end

  factory :submission_for_teachers, class: "Submission" do
    grade { 89 }
    feedback { "Great Job!"}
    graded_at { Time.now}

    association :user, factory: :teacher
    association :assignment

  end
end
