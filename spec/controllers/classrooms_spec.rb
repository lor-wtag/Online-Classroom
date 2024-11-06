require 'rails_helper'

RSpec.describe ClassroomsController, type: :controller do
  let!(:teacher) { create(:teacher) }
  let!(:student) { create(:student) }
  let!(:classroom_1) { create(:classroom, name: "Classroom-1", course_code: "CS101", teacher: teacher) }
  let!(:classroom_2) { create(:classroom, name: "Classroom-2", course_code: "CS404", teacher: teacher) }


  describe "GET #index" do
    context "when user is a teacher" do
      before { login(teacher) }

      it "assigns the teacher's classrooms to @classrooms" do
        get :index
        expect(assigns(:classrooms)).to match_array([ classroom_1, classroom_2 ])
      end
    end

    context "when user is a student" do
      before { login(student) }

      it "assigns the student's classrooms to @classrooms" do
        student.classrooms_as_student << classroom_1
        get :index
        expect(assigns(:classrooms)).to match_array([ classroom_1 ])
      end
    end
  end

  describe "POST #enroll" do
    context "when user is a student" do
      before { login(student) }

      it "enrolls the student in the classroom" do
        post :enroll, params: { classroom_code: classroom_1.classroom_code }
        expect(student.classrooms_as_student).to include(classroom_1)
        expect(flash[:notice]).to include("You have enrolled in #{classroom_1.name} successfully")
      end

      it "does not allow the student to join again" do
        student.classrooms_as_student << classroom_1
        post :enroll, params: { classroom_code: classroom_1.classroom_code }
        expect(student.classrooms_as_student.count).to eq(1)
        expect(flash[:alert]).to eq("Invalid/Duplicate enroll attempt. Please try again!")
      end
    end
  end

  describe "POST #send_invitations" do
    context "when valid student emails are provided" do
      before { login(teacher) }

      it "sends an invitation email to each student" do
        expect {
          post :send_invitations, params: { user_id: teacher.id, id: classroom_1.id, student_emails: "janedoes@gmail.com" }
        }.to change { ActionMailer::Base.deliveries.count }.by(1)

        expect(response).to redirect_to(classroom_path(classroom_1))
        expect(flash[:notice]).to eq("Classroom invitations have been sent to the students!")
      end
    end

    context "when invalid student emails are provided" do
      before { login(teacher) }

      it "renders the show page with an error message" do
        post :send_invitations, params: { user_id: teacher.id, id: classroom_1.id, student_emails: "" }
        expect(response).to render_template("show")
        expect(flash[:alert]).to eq("No valid student emails provided.")
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "GET #join" do
    context "joining the classroom via a valid invitation link" do
      before { login(student) }

      it "enrolls the student in the classroom" do
        get :join, params: { id: classroom_1.id }
        student.reload
        expect(student.classrooms_as_student).to include(classroom_1)
        expect(flash[:notice]).to eq("You have joined #{classroom_1.name} classroom")
      end
    end
  end


  describe "DELETE #destroy" do
    before { login(teacher) }

    it "allows the teacher to delete the classroom" do
      expect {
        delete :destroy, params: { id: classroom_1.id }
      }.to change(Classroom, :count).by(-1)

      expect(flash[:notice]).to eq("You have deleted this classroom")
      expect(response).to redirect_to(classrooms_path)
    end
  end
end
