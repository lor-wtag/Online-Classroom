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
      puts "======================Student: #{student.id}, Classroom: #{classroom.id}"
      puts "==============Enrollment: #{enrollment.inspect}"
      expect {
        delete :destroy, params: { classroom_id: classroom.id, user_id: student.id }
      }.to change(Enrollment, :count).by(-1)

      expect(response).to redirect_to(classroom_path(classroom)) 
      expect(flash[:notice]).to eq("Student removed from this classroom")
    end
  end
end