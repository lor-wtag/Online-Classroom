# spec/models/ability_spec.rb
require 'rails_helper'
require 'cancan/matchers'

RSpec.describe Ability, type: :model do
  let!(:teacher) { create(:teacher) }
  let!(:teacher_2) { create(:teacher, name: "Teacher 2", email: "teacher2@gmail.com") }
  let!(:student) { create(:student) }
  let!(:student_2) { create(:student, name: "Student 2", email: "student2@gmail.com") }
  let!(:classroom) { create(:classroom, teacher: teacher) }
  let!(:other_classroom) { create(:classroom, name: "Classroom-2", course_code: "CS404", teacher: teacher_2) }

  subject(:ability) { Ability.new(user) }

  context "when user is a teacher" do
    let(:user) { teacher }
    it "allows teachers to manage their own classrooms" do
      expect(ability).to be_able_to(:manage, classroom)
    end

    it "does not allow teachers to manage other classrooms" do
      expect(ability).not_to be_able_to(:manage, other_classroom)
    end

    it "allows teachers to send invitations" do
      expect(ability).to be_able_to(:send_invitations, classroom)
    end
  end

  context "when user is a student" do
    let(:user) { student }

    it "allows students to read classrooms they are enrolled in" do
      student.classrooms_as_student << classroom
      expect(ability).to be_able_to(:read, classroom)
    end

    it "does not allow students to read classrooms they are not enrolled in" do
      expect(ability).not_to be_able_to(:read, other_classroom)
    end

    it "allows students to join classrooms" do
      expect(ability).to be_able_to(:join, classroom)
    end

    it "does not allow students to manage classrooms" do
      expect(ability).not_to be_able_to(:manage, classroom)
    end

    it "allows students to destroy their own enrollments" do
      enrollment = create(:enrollment, user: student, classroom: classroom)
      expect(ability).to be_able_to(:destroy, enrollment)
    end

    it "does not allow students to destroy enrollments of other students" do
      other_enrollment = create(:enrollment, user: student_2, classroom: classroom)
      expect(ability).not_to be_able_to(:destroy, other_enrollment)
    end
  end
end
