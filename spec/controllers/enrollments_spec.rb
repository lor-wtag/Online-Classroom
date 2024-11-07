require 'rails_helper'

RSpec.describe EnrollmentsController, type: :controller do
  let!(:teacher) { create(:teacher) }
  let!(:student) { create(:student) }
  let!(:classroom) { create(:classroom, teacher: teacher) }
  let!(:enrollment) { create(:enrollment, classroom: classroom, user: student) }

  before do
    login(teacher)
  end

  describe "DELETE #destroy" do
    it "removes the student from the classroom" do
      # enrollment_to_delete = Enrollment.find_by(user_id: student.id, classroom_id: classroom.id)
      # puts "++++++++++++++++#{enrollment_to_delete.user.name}"
      # expect(enrollment_to_delete).not_to be_nil
      expect {
        delete :destroy, params: { classroom_id: classroom.id, id: enrollment.id }
    }.to change(Enrollment, :count).by(-1)
      # expect(Enrollment.find_by(id: enrollment_to_delete.id)).to be_nil

      # expect(response).to redirect_to(classroom_path(classroom))
      # expect(flash[:notice]).to eq("Student removed from this classroom")
    end
  end
end
