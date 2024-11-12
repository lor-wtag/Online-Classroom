FactoryBot.define do
  factory :assignment do
    title { "Sample Assignment" }
    description { "This is a sample assignment description." }
    due_date { 1.week.from_now }
    association :classroom

    after(:build) do |assignment|
      file_path = Rails.root.join("spec", "download.jpeg")
      assignment.files.attach(io: File.open(file_path), filename: "download.jpeg", content_type: "image")
    end
  end
end