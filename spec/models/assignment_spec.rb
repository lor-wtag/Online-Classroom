require 'rails_helper'

RSpec.describe Assignment, type: :model do
  describe "validations" do
    it { should validate_presence_of(:title)}
    it { should validate_length_of(:title).is_at_least(5).is_at_most(200)}
    it{ should validate_presence_of(:classroom_id) }
  end

  describe "associations" do
    it { should belong_to(:classroom)}
    it{should have_many(:submissions).dependent(:destroy)}
    it{should have_many(:comments).dependent(:destroy)}

  end
end
