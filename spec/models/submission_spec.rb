require 'rails_helper'

RSpec.describe Submission, type: :model do
  describe "validations" do
    it { is_expected.to validate_presence_of(:assignment_id) }
    it { is_expected.to validate_presence_of(:user_id) }
    it { is_expected.to validate_numericality_of(:grade) }
    it { is_expected.to validate_length_of(:feedback).is_at_most(300) }
  end

  describe "associations" do
    it { is_expected.to belong_to(:assignment) }
    it { is_expected.to belong_to(:user) }
  end
end
