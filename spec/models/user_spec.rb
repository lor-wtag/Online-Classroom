require 'rails_helper'

RSpec.describe User, type: :model do
  describe "validations" do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of (:email) }
    it { should validate_uniqueness_of(:email) }
    it { should allow_value("lamiya@gmail.com").for(:email) }
    it { should_not allow_value("lamiya@").for(:email) }
    it { should_not allow_value("lamiygmail.@com").for(:email) }
    it { should validate_presence_of(:role) }
    it { should define_enum_for(:role).with_values(%i[admin teacher student]) 
  end

  describe "associations" do
    it { should have_many(:classrooms).with_foreign_key(:user_id).dependent(:destroy) }
    it { should have_many(:enrollments).dependent(:destroy) }
    it { should have_many(:classrooms_as_student).through(:enrollments).source(:classroom) }
    it { should have_many(:posts).dependent(:destroy) }
    it { should have_many(:comments).dependent(:destroy) }
  end
end
