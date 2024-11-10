require 'rails_helper'

RSpec.describe User, type: :model do
  describe "validations" do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_uniqueness_of(:email) }
    it { is_expected.to allow_value("lamiya@gmail.com").for(:email) }
    it { is_expected.to_not allow_value("lamiya@").for(:email) }
    it { is_expected.to_not allow_value("lamiygmail.@com").for(:email) }
    it { is_expected.to validate_presence_of(:role) }
    it { is_expected.to define_enum_for(:role).with_values(%i[admin teacher student]) }
  end

  describe "associations" do
    it { is_expected.to have_many(:classrooms).with_foreign_key(:user_id).dependent(:destroy) }
    it { is_expected.to have_many(:enrollments).dependent(:destroy) }
    it { is_expected.to have_many(:classrooms_as_student).through(:enrollments).source(:classroom) }
    it { is_expected.to have_many(:posts).dependent(:destroy) }
    it { is_expected.to have_many(:comments).dependent(:destroy) }
  end
end
