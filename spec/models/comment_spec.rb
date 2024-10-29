require 'rails_helper'

RSpec.describe Comment, type: :model do
  describe "validations" do
    it { should validate_presence_of(:content)}
    it { should validate_length_of(:content).is_at_most(500)}
  end

  describe "associations" do
    it { should belong_to(:commentable)}
    it { should belong_to(:user)}
  end
end
