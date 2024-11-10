require 'rails_helper'

RSpec.describe Classroom do
  describe "validations" do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_length_of(:name).is_at_least(2).is_at_most(100) }
    it { is_expected.to validate_presence_of(:course_code) }
    it { is_expected.to validate_uniqueness_of(:course_code) }
  end

  describe "associations" do
    it { is_expected.to belong_to(:teacher).class_name("User").with_foreign_key("user_id") }
    it { is_expected.to have_many(:enrollments).dependent(:destroy) }
    it { is_expected.to have_many(:users).through(:enrollments) }
    it { is_expected.to have_many(:assignments).dependent(:destroy) }
    it { is_expected.to have_many(:posts).dependent(:destroy) }
  end
end
