require 'rails_helper'

RSpec.describe Assignment do
  describe "validations" do
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_length_of(:title).is_at_least(5).is_at_most(200) }
    it { is_expected.to validate_presence_of(:classroom_id) }
  end

  describe "associations" do
    it { is_expected.to belong_to(:classroom) }
    it { is_expected.to have_many(:submissions).dependent(:destroy) }
    it { is_expected.to have_many(:comments).dependent(:destroy) }
  end
end
