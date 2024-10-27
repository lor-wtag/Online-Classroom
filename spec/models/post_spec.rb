require 'rails_helper'

RSpec.describe Post, type: :model do
  describe "validations" do
    it { should validate_presence_of(:title)}
    it { should validate_length_of(:title).is_at_least(5).is_at_most(100) }
    it { should validate_presence_of(:content)}
    it { should validate_length_of(:content).is_at_least(5).is_at_most(300) }
    it { should validate_presence_of(:user_id)}
    it { should validate_presence_of(:classroom_id)}
  end

  describe "assocations" do
    it { should belong_to(:classroom)}
    it { should belong_to(:user)}
    it { should have_many(:comments).dependent(:destroy) }
  end


end
