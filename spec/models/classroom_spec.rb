require 'rails_helper'

RSpec.describe Classroom, type: :model do
  describe "validations" do
    it { should validate_presence_of(:name) }
    it { should validate_length_of(:name).is_at_least(2).is_at_most(100)}
    it { should validate_presence_of(:course_code) }
    it {should validate_uniqueness_of(:course_code)}
  end

  describe "associations" do
    it { should belong_to(:teacher).class_name("User").with_foreign_key("user_id")}
    it { should have_many(:enrollments).dependent(:destroy) }
    it { should have_many(:users).through(:enrollments)}
    it { should have_many(:assignments).dependent(:destroy)}
    it{ should have_many(:posts).dependent(:destroy)}
  end
end
