require 'rails_helper'

RSpec.describe AssignmentsController, type: :controller do
  let!(:teacher) { create(:teacher) }
  let!(:admin) { create(:admin) }
  let!(:student) { create(:student) }
  let!(:classroom) { create(:classroom, teacher: teacher) }
  let!(:assignment) { create(:assignment, classroom: classroom) }
  let!(:enrollment) { create(:enrollment, classroom: classroom, user: student) }


  describe "GET #index" do
    context "as a student" do
      before { login(student) }

      it "allows access and returns http success" do
        get :index, params: { classroom_id: enrollment.classroom.id }
        expect(response).to have_http_status(:success)
      end
    end

    context "as a student" do
      before { login(teacher) }

      it "allows access and returns http success" do
        get :index, params: { classroom_id: classroom.id }
        expect(response).to have_http_status(:success)
      end
    end
  end

  describe "POST #create" do
    let(:assignment_params) { attributes_for(:assignment) }

    context "as a teacher" do
      before { login(teacher) }

      it "allows creating an assignment" do
        expect {
          post :create, params: { classroom_id: classroom.id, assignment: assignment_params }
        }.to change(Assignment, :count).by(1)
        expect(response).to redirect_to(classroom_path(classroom))
        expect(flash[:notice]).to eq("Assignment created successfully.")
      end
    end

    context "as a student" do
      before { login(student) }

      it "denies creating an assignment" do
        expect {
          post :create, params: { classroom_id: classroom.id, assignment: assignment_params }
        }.not_to change(Assignment, :count)
      end
    end
  end

  describe "PUT #update" do
    let(:new_attributes) { { title: "Updated Assignment" } }

    context "as a teacher" do
      before { login(teacher) }

      it "allows updating the assignment" do
        put :update, params: { classroom_id: classroom.id, id: assignment.id, assignment: new_attributes }
        assignment.reload
        expect(assignment.title).to eq("Updated Assignment")
        expect(response).to redirect_to(classroom_assignment_path(classroom, assignment))
        expect(flash[:notice]).to eq("Assignment updated successfully")
      end
    end

    context "as a student" do
      before { login(student) }

      it "denies updating the assignment" do
        put :update, params: { classroom_id: classroom.id, id: assignment.id, assignment: new_attributes }
        assignment.reload
        expect(assignment.title).not_to eq("Updated Assignment")
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe "DELETE #destroy" do
    context "as an admin" do
      before { login(admin) }

      it "allows deleting the assignment" do
        delete :destroy, params: { classroom_id: classroom.id, id: assignment.id }
        expect(response).to redirect_to(classroom_path(classroom))
        expect(flash[:notice]).to eq("Assignment was successfully deleted.")
        expect { assignment.reload }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context "as a teacher" do
      before { login(teacher) }

      it "allows deleting the assignment" do
        delete :destroy, params: { classroom_id: classroom.id, id: assignment.id }
        expect(response).to redirect_to(classroom_path(classroom))
        expect(flash[:notice]).to eq("Assignment was successfully deleted.")
        expect { assignment.reload }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context "as a student" do
      before { login(student) }

      it "denies deleting the assignment" do
        delete :destroy, params: { classroom_id: classroom.id, id: assignment.id }
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe "GET #show" do
    context "as a student" do
      before { login(student) }

      it "allows access to view an assignment" do
        get :show, params: { classroom_id: classroom.id, id: assignment.id }
        expect(response).to have_http_status(:success)
      end
    end

    context "as a teacher" do
      before { login(teacher) }

      it "allows access to view an assignment" do
        get :show, params: { classroom_id: classroom.id, id: assignment.id }
        expect(response).to have_http_status(:success)
      end
    end
  end
end
