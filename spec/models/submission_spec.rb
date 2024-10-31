require 'rails_helper'

RSpec.describe Submission, type: :model do
  describe "validations" do
    it { should validate_presence_of(:assignment_id) }
    it { should validate_presence_of(:user_id) }
    it { should validate_presence_of(:file) }
    it { should validate_numericality_of(:grade) }
    it { should validate_length_of(:feedback).is_at_most(300) }
  end

  describe "associations" do
    it { should belong_to(:assignment) }
    it { should belong_to(:user) }
  end
end
