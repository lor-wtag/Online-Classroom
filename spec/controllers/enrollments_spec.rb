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
      expect {
        delete :destroy, params: { classroom_id: classroom.id, id: enrollment.id }
    }.to change(Enrollment, :count).by(-1)
    end
  end
end
