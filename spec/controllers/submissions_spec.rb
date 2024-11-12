require 'rails_helper'

RSpec.describe SubmissionsController, type: :controller do
  let!(:admin) { create(:admin) }
  let!(:teacher) { create(:teacher) }
  let!(:student) { create(:student) }
  let!(:classroom) { create(:classroom, teacher: teacher) }
  let!(:assignment) { create(:assignment, classroom: classroom) }
  let!(:submission) { create(:submission, assignment: assignment, user: student) }

  describe 'GET #index' do
    context 'when user is a teacher' do
      before { sign_in teacher }

      it 'allows access to the submissions of the assignment' do
        get :index, params: { classroom_id: classroom.id, assignment_id: assignment.id }
        expect(assigns(:submissions)).to eq([submission])
        expect(response).to render_template(:index)
      end
    end

    context 'when user is a student' do
      before { sign_in student }

      it 'denies access to the submissions' do
        get :index, params: { classroom_id: classroom.id, assignment_id: assignment.id }
        expect(response).to redirect_to(root_path) # Or some unauthorized path
      end
    end
  end

  describe 'GET #new' do
    context 'when user is a student' do
      before { sign_in student }

      it 'allows access to the new submission form' do
        get :new, params: { classroom_id: classroom.id, assignment_id: assignment.id }
        expect(response).to render_template(:new)
      end
    end

    context 'when user is not authorized' do
      before { sign_in teacher }

      it 'denies access to the new submission form' do
        get :new, params: { classroom_id: classroom.id, assignment_id: assignment.id }
        expect(response).to redirect_to(root_path) # Or some unauthorized path
      end
    end
  end

  describe 'POST #create' do
    context 'when user is a student' do
      before { sign_in student }

      it 'creates a submission with valid attributes' do
        expect {
          post :create, params: { classroom_id: classroom.id, assignment_id: assignment.id, submission: { files: [fixture_file_upload('files/sample_file.txt')] } }
        }.to change(Submission, :count).by(1)
        expect(response).to redirect_to(classroom_assignment_path(classroom, assignment))
        expect(flash[:notice]).to eq('Your submission was successful!')
      end

      it 'does not create a submission with invalid attributes' do
        expect {
          post :create, params: { classroom_id: classroom.id, assignment_id: assignment.id, submission: { files: nil } }
        }.to_not change(Submission, :count)
        expect(response).to render_template(:new)
      end
    end

    context 'when user is a teacher' do
      before { sign_in teacher }

      it 'denies submission creation' do
        post :create, params: { classroom_id: classroom.id, assignment_id: assignment.id, submission: { files: [fixture_file_upload('files/sample_file.txt')] } }
        expect(response).to redirect_to(root_path) # Or some unauthorized path
      end
    end
  end

  describe 'GET #edit' do
    context 'when user is the owner of the submission' do
      before { sign_in student }

      it 'allows access to the edit page' do
        get :edit, params: { classroom_id: classroom.id, assignment_id: assignment.id, id: submission.id }
        expect(response).to render_template(:edit)
      end
    end

    context 'when user is not the owner of the submission' do
      before { sign_in teacher }

      it 'denies access to the edit page' do
        get :edit, params: { classroom_id: classroom.id, assignment_id: assignment.id, id: submission.id }
        expect(response).to redirect_to(root_path) # Or some unauthorized path
      end
    end
  end

  describe 'PATCH #update' do
    context 'when user is the owner of the submission' do
      before { sign_in student }

      it 'updates the submission with valid attributes' do
        patch :update, params: { classroom_id: classroom.id, assignment_id: assignment.id, id: submission.id, submission: { files: [fixture_file_upload('files/sample_file.txt')] } }
        expect(submission.reload.files.count).to eq(1)
        expect(response).to redirect_to(classroom_assignment_submission_path(classroom, assignment, submission))
        expect(flash[:notice]).to eq('Your submission was updated successfully!')
      end
    end

    context 'when user is not the owner of the submission' do
      before { sign_in teacher }

      it 'denies update access' do
        patch :update, params: { classroom_id: classroom.id, assignment_id: assignment.id, id: submission.id, submission: { files: [fixture_file_upload('files/sample_file.txt')] } }
        expect(response).to redirect_to(root_path) # Or some unauthorized path
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'when user is the owner of the submission' do
      before { sign_in student }

      it 'deletes the submission' do
        expect {
          delete :destroy, params: { classroom_id: classroom.id, assignment_id: assignment.id, id: submission.id }
        }.to change(Submission, :count).by(-1)
        expect(response).to redirect_to(classroom_assignment_submissions_path(classroom, assignment))
      end
    end

    context 'when user is not the owner of the submission' do
      before { sign_in teacher }

      it 'denies access to delete the submission' do
        delete :destroy, params: { classroom_id: classroom.id, assignment_id: assignment.id, id: submission.id }
        expect(response).to redirect_to(root_path) # Or some unauthorized path
      end
    end
  end
end
